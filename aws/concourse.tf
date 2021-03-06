﻿#     _____                                          
#    / ____|                                         
#   | |     ___  _ __   ___ ___  _   _ _ __ ___  ___ 
#   | |    / _ \| '_ \ / __/ _ \| | | | '__/ __|/ _ \
#   | |___| (_) | | | | (_| (_) | |_| | |  \__ \  __/
#    \_____\___/|_| |_|\___\___/ \__,_|_|  |___/\___|
#                                                   

# https://www.terraform.io/docs/providers/aws/d/s3_bucket-object.html

data "aws_s3_bucket_object" "kube-config-yaml" {

  bucket = local.bucket_name
  key    = "/${var.cluster_name}/kube_config.yaml"

}

resource "local_file" "kube-config-yaml" {

  content  = data.aws_s3_bucket_object.kube-config-yaml.body
  filename = "${path.cwd}/${var.name}/kube_config.yaml"

}

data "aws_s3_bucket_object" "node-public-dns" {

  bucket = local.bucket_name
  key    = "/${var.cluster_name}/node_public_dns.txt"

}

resource "local_file" "node-public-dns" {

  content  = data.aws_s3_bucket_object.node-public-dns.body
  filename = "${path.cwd}/${var.name}/node_public_dns.txt"

}

data "aws_s3_bucket_object" "node-private-key" {

  bucket = local.bucket_name
  key    = "/${var.cluster_name}/node.pem"

}

resource "local_file" "node-private-key" {

  content  = data.aws_s3_bucket_object.node-private-key.body
  filename = "${path.cwd}/${var.name}/node.pem"

}

resource "aws_ebs_volume" "worker-ebs" {

  availability_zone = var.storage_availability_zone
  size              = var.worker_storage_size

  tags = {
    Name = "worker-storage-ebs"
  }

}

resource "local_file" "worker-persistent-volume-0-yaml" {

  content  = templatefile("${path.cwd}/k8s/worker-persistent-volume-0.yaml", { VOLUME_ID = aws_ebs_volume.worker-ebs.id })
  filename = "${path.cwd}/${var.name}/worker-persistent-volume-0.yaml"

}

resource "local_file" "worker-persistent-volume-1-yaml" {

  content  = templatefile("${path.cwd}/k8s/worker-persistent-volume-1.yaml", { VOLUME_ID = aws_ebs_volume.worker-ebs.id })
  filename = "${path.cwd}/${var.name}/worker-persistent-volume-1.yaml"

}

resource "aws_ebs_volume" "postgresql-ebs" {

  availability_zone = var.storage_availability_zone
  size              = var.postgresql_storage_size

  tags = {
    Name = "postgresql-storage-ebs"
  }

}

resource "local_file" "postgresql-persistent-volume-0-yaml" {

  content  = templatefile("${path.cwd}/k8s/postgresql-persistent-volume-0.yaml", { VOLUME_ID = aws_ebs_volume.postgresql-ebs.id })
  filename = "${path.cwd}/${var.name}/postgresql-persistent-volume-0.yaml"

}

resource "null_resource" "install-concourse" {

  depends_on = [
    aws_ebs_volume.worker-ebs,
    aws_ebs_volume.postgresql-ebs,
    data.aws_s3_bucket_object.kube-config-yaml
  ]

//  connection {
//    type        = "ssh"
//    host        = data.aws_s3_bucket_object.node-public-dns.body
//    user        = "ubuntu"
//    private_key = data.aws_s3_bucket_object.node-private-key.body
//  }

  # https://www.terraform.io/docs/provisioners/local-exec.html

  provisioner "local-exec" {
    command = "chmod +x scripts/install_concourse.sh && bash scripts/install_concourse.sh"
    environment = {
      FOLDER    = "${var.name}"
      NAME      = "${var.name}"
      NAMESPACE = "${var.name}"
    }
  }

}

resource "null_resource" "destroy-concourse" {

  depends_on = [
    aws_ebs_volume.worker-ebs,
    aws_ebs_volume.postgresql-ebs,
    local_file.kube-config-yaml
  ]

//  connection {
//    type        = "ssh"
//    host        = data.aws_s3_bucket_object.node-public-dns.body
//    user        = "ubuntu"
//    private_key = data.aws_s3_bucket_object.node-private-key.body
//  }

  # https://www.terraform.io/docs/provisioners/local-exec.html

  provisioner "local-exec" {
    when    = destroy
    command = "chmod +x ${path.cwd}//destroy.sh && bash scripts/destroy.sh"
  }

}