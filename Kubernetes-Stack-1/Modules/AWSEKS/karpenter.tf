module "karpenter" {
  source  = "terraform-aws-modules/eks/aws//modules/karpenter"
  version = "~> 20.0"

  cluster_name = module.eks.lab-cluster

  # Attach IAM policies needed for node bootstrapping
  node_iam_role_additional_policies = {
    AmazonSSMManagedInstanceCore = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
  }

  create_pod_identity_association = true
}

resource "helm_release" "karpenter" {
  namespace        = "kube-system"
  create_namespace = true
  name             = "karpenter"
  repository       = "oci://public.ecr.aws/karpenter"
  chart            = "karpenter"
  version          = "1.0.1" # check latest

  set = [
    {
      name  = "settings.clusterName"
      value = module.eks.lab-cluster
    },
    {
      name  = "settings.interruptionQueue"
      value = module.karpenter.queue_name
    },
    {
      name  = "serviceAccount.name"
      value = "karpenter"
    }
  ]
}

resource "kubectl_manifest"