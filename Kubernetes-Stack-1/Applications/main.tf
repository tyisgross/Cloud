provider "aws" {
  region = "us-west-2"
}

resource "aws_vpc" "network" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true
  
  tags = {
    Name = "my-vpc"
  }
}

resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.network.id

  tags = {
    Name = "main-gateway"
  }
}

resource "aws_subnet" "subnet" {
  vpc_id = aws_vpc.network.id
  cidr_block = "10.0.1.0/24"

  tags = {
    Name = "my-subnet"
  }
}

resource "aws_route_table" "route" {
  vpc_id = aws_vpc.network.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw.id
  }

  tags = {
    Name = "public-route-table"
  }
}

resource "aws_route_table_association" "public" {
  subnet_id      = aws_subnet.subnet.id
  route_table_id = aws_route_table.route.id
}

resource "aws_security_group" "web" {
  name   = "web-sg"
  vpc_id = aws_vpc.network.id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["67.168.201.91/32"]
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["67.168.201.91/32"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

module "eks" {
  source  = "terraform-aws-modules/eks/aws"

  cluster_name    = "lab-cluster"
  cluster_version = "1.31"

  vpc_id     = aws_vpc.network.id
  subnet_ids = aws_subnet.subnet.id

  eks_managed_node_groups = {
    default = {
      instance_types = ["t3.medium"]

      min_size     = 1
      max_size     = 3
      desired_size = 2
    }
  }
}

data "aws_eks_cluster" "eks" {
  name = module.eks.lab-cluster
}

data "aws_eks_cluster_auth" "eks" {
  name = module.eks.lab-cluster
}

provider "kubernetes" {
  host = data.aws_eks_cluster.eks.endpoint

  cluster_ca_certificate = base64decode(
    data.aws_eks_cluster.eks.certificate_authority[0].data
  )

  token = data.aws_eks_cluster_auth.eks.token
}

provider "helm" {
  kubernetes {
    host = data.aws_eks_cluster.eks.endpoint

    cluster_ca_certificate = base64decode(
      data.aws_eks_cluster.eks.certificate_authority[0].data
    )

    token = data.aws_eks_cluster_auth.eks.token
  }
}

resource "helm_release" "nginx" {
  name             = "nginx"
  namespace        = "nginx"
  create_namespace = true

  repository = "https://kubernetes.github.io/ingress-nginx"
  chart      = "ingress-nginx"
}

data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name = "name"
    values = ["ubuntu/images/hvm-ssd-gp3/ubuntu-noble-24.04-amd64-server-*"]
  }

  owners = ["099720109477"] # Canonical
}

resource "aws_instance" "flask_server" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = "t3.micro"

  subnet_id = aws_subnet.subnet.id

  vpc_security_group_ids = [aws_security_group.web.id]

  associate_public_ip_address = true

  key_name = "MyKeyPair"

  tags = {
    Name = "flask-app"
  }

  user_data = <<-EOF
              #!/bin/bash
              apt update
              apt install docker.io -y
              systemctl start docker
              systemctl enable docker
              docker pull tyanthonygross/cloud-apps:flask
              docker run -d -p 80:8000 tyanthonygross/cloud-apps:flask
              EOF
}

output "public_ip" {
  value = aws_instance.flask_server.public_ip
}