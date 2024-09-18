resource "aws_eks_cluster" "kristo" {
  name     = "kristo-cluster"
  role_arn = aws_iam_role.ekscontrol.arn
  tags     = var.common_tags
  vpc_config {
    subnet_ids              = [aws_subnet.pub[0].id, aws_subnet.pub[1].id, aws_subnet.pub[2].id]
    security_group_ids      = [aws_security_group.eks_sg.id]
    endpoint_public_access  = true
    endpoint_private_access = true
  }
}

resource "null_resource" "eks_context" {
  depends_on = [aws_eks_cluster.kristo]
  provisioner "local-exec" {
    command = "aws eks update-kubeconfig --name kristo-cluster --region ${var.region}"
  }
}

resource "aws_launch_template" "nodegroup" {
  name                   = "nodegroup-lt"
  instance_type          = "t2.micro"
  vpc_security_group_ids = [aws_security_group.eks_sg.id]
  tags                   = var.common_tags
  tag_specifications {
    resource_type = "instance"
    tags          = var.common_tags
  }
  metadata_options {
    http_tokens                 = "required"
    http_put_response_hop_limit = 3
  }
}

resource "aws_eks_node_group" "kristo" {
  depends_on      = [aws_launch_template.nodegroup, null_resource.calico]
  cluster_name    = aws_eks_cluster.kristo.name
  subnet_ids      = aws_subnet.pub[*].id
  node_role_arn   = aws_iam_role.eksworker.arn
  node_group_name = "kristo-ng"
  tags            = var.common_tags
  scaling_config {
    desired_size = 3
    max_size     = 6
    min_size     = 2
  }
}

# resource "null_resource" "dockerfile_build" {
#   depends_on = [aws_eks_cluster.kristo]
#   provisioner "local-exec" {
#     command = "aws eks update-kubeconfig --name kristo-cluster --region ${var.region}"
#   }
# }