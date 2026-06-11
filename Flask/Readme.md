This Flasck project was a proof of concept and learning opportunity in administering cloud applications via docker and terraform. This was the first time I have pulled an application from github and pushed it to my docker hub. This was also my first project building infrastructure in AWS via terraform. I was able to generate all of the necessary networking and security configurations to connect to the instance I created via SSH, but was unable to get the flask app to correctly run. Here was the error I received when looking at the logs of the Flask application: 

"Traceback (most recent call last):
  File "/app/app.py", line 1, in <module>
    from flask import Flask
ModuleNotFoundError: No module named 'flask'
ubuntu@ip-10-0-1-128:~$"


I have decided to move onto a new project that will use Kubernetes and the respective AWS services utilizing Kubernetes.