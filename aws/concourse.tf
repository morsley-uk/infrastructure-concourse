#     _____                                          
#    / ____|                                         
#   | |     ___  _ __   ___ ___  _   _ _ __ ___  ___ 
#   | |    / _ \| '_ \ / __/ _ \| | | | '__/ __|/ _ \
#   | |___| (_) | | | | (_| (_) | |_| | |  \__ \  __/
#    \_____\___/|_| |_|\___\___/ \__,_|_|  |___/\___|
#                                                   

# 1. Read our cluster YAML from S3

# https://www.terraform.io/docs/providers/aws/d/s3_bucket-object.html

data "aws_s3_bucket_object" "rancher-cluster-yaml" {
  
  bucket = var.bucket_name
  key = "/${var.name}/kube_config.yaml"
  
}

resource "local_file" "kube-config-yaml" {
  
  content = data.aws_s3_bucket_object.rancher-cluster-yaml.body
  filename = "${path.cwd}/${var.name}/kube_config.yaml"
  
}

data "aws_s3_bucket_object" "node-public-dns" {

  bucket = var.bucket_name
  key = "/${var.name}/node_public_dns.txt"

}

resource "local_file" "node-public-dns" {

  content = data.aws_s3_bucket_object.node-public-dns.body
  filename = "${path.cwd}/${var.name}/node_public_dns.txt"

}

data "aws_s3_bucket_object" "node-private-key" {

  bucket = var.bucket_name
  key = "/${var.name}/node.pem"

}

resource "local_file" "node-private-key" {

  content = data.aws_s3_bucket_object.node-private-key.body
  filename = "${path.cwd}/${var.name}/node.pem"

}

resource "null_resource" "install-concourse" {

  depends_on = [
    data.aws_s3_bucket_object.rancher-cluster-yaml
  ]

  connection {
    type        = "ssh"
    host        = data.aws_s3_bucket_object.node-public-dns.body
    user        = "ubuntu"
    private_key = data.aws_s3_bucket_object.node-private-key.body
  }

  # https://www.terraform.io/docs/provisioners/local-exec.html

  provisioner "local-exec" {
    command = "chmod +x scripts/install_concourse.sh && bash scripts/install_concourse.sh"
  }

}