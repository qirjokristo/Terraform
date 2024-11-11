resource "aws_eks_cluster" "panamax" {
  name     = "panamax-cluster"
  role_arn = aws_iam_role.ekscontrol.arn
  tags     = var.common_tags
  vpc_config {
    subnet_ids              = [aws_subnet.pub[0].id, aws_subnet.pub[1].id, aws_subnet.pub[2].id]
    endpoint_public_access  = true
    endpoint_private_access = true
  }
}

resource "null_resource" "eks_context" {
  depends_on = [aws_eks_cluster.panamax]
  provisioner "local-exec" {
    command = "aws eks update-kubeconfig --name panamax-cluster --region ${var.region}"
  }
}

resource "aws_launch_template" "panamax" {
  name          = "nodegroup-lt"
  instance_type = "t2.micro"
  tags          = var.common_tags
  iam_instance_profile {
    arn = aws_iam_instance_profile.EKSWorker.arn
  }
  tag_specifications {
    resource_type = "instance"
    tags          = merge(var.common_tags, { Name = "Panamax--cluster-node" })
  }
  metadata_options {
    http_endpoint               = "enabled"
    http_tokens                 = "required"
    http_put_response_hop_limit = 2
  }
}

resource "aws_eks_node_group" "panamax" {
  depends_on    = [aws_launch_template.panamax, null_resource.calico]
  cluster_name  = aws_eks_cluster.panamax.name
  subnet_ids    = aws_subnet.pub[*].id
  node_role_arn = aws_iam_role.eksworker.arn
  launch_template {
    id      = aws_launch_template.panamax.id
    version = aws_launch_template.panamax.latest_version
  }
  node_group_name = "panamax-ng"
  tags            = var.common_tags
  scaling_config {
    desired_size = 3
    max_size     = 6
    min_size     = 2
  }
}