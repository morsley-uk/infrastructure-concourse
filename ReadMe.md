     _____                _   __  __      _ 
    |  __ \              | | |  \/  |    | |
    | |__) |___  __ _  __| | | \  / | ___| |
    |  _  // _ \/ _` |/ _` | | |\/| |/ _ \ |
    | | \ \  __/ (_| | (_| | | |  | |  __/_|
    |_|  \_\___|\__,_|\__,_| |_|  |_|\___(_)
    
The purpose of this project is to install Concourse on a Kubernetes cluster. This
could have been hosted on any Cloud provider, but I have chosen AWS (Amazon Web
Services).

This is being achieved by using Terraform and Helm.

Useful links:

## AWS:

https://www.terraform.io/docs/providers/aws/index.html

## Concourse:

https://concourse-ci.org

https://github.com/concourse/concourse-chart 

## Install Concourse on the Kubernetes cluster

1. Add Helm chart repository.
2. Create a Concourse namespace.
3. Install Cert-Manager (Let's Encrypt).
4. Install Concourse with Helm.