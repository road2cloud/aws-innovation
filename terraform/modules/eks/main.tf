resource "aws_ecr_repository" "arc" {
  name = "lab"
}

resource "aws_iam_role" "arc-cluster" {
  name = "arc-eks-cluster"

  assume_role_policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "eks.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
POLICY
}

resource "aws_iam_role_policy_attachment" "arc-cluster-AmazonEKSClusterPolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  role       = "${aws_iam_role.arc-cluster.name}"
}

resource "aws_iam_role_policy_attachment" "arc-cluster-AmazonEKSServicePolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSServicePolicy"
  role       = "${aws_iam_role.arc-cluster.name}"
}

resource "aws_security_group" "arc-cluster" {
  name        = "arc-eks-cluster"
  description = "Cluster communication with worker nodes"
  vpc_id      = "${var.vpc_id}"

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags {
    Name = "arc-eks"
  }
}

resource "aws_eks_cluster" "arc" {
  name            = "${var.cluster-name}"
  role_arn        = "${aws_iam_role.arc-cluster.arn}"

  vpc_config {
    security_group_ids = ["${aws_security_group.arc-cluster.id}"]
    subnet_ids         = ["${var.public_subnet1_id}", "${var.public_subnet2_id}"]
  }

  depends_on = [
    "aws_iam_role_policy_attachment.arc-cluster-AmazonEKSClusterPolicy",
    "aws_iam_role_policy_attachment.arc-cluster-AmazonEKSServicePolicy",
  ]
}

locals {
  kubeconfig = <<KUBECONFIG


apiVersion: v1
clusters:
- cluster:
    server: ${aws_eks_cluster.arc.endpoint}
    certificate-authority-data: ${aws_eks_cluster.arc.certificate_authority.0.data}
  name: kubernetes
contexts:
- context:
    cluster: kubernetes
    user: aws
  name: aws
current-context: aws
kind: Config
preferences: {}
users:
- name: aws
  user:
    exec:
      apiVersion: client.authentication.k8s.io/v1alpha1
      command: aws-iam-authenticator
      args:
        - "token"
        - "-i"
        - "${var.cluster-name}"
KUBECONFIG
}
