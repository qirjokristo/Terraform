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

resource "aws_eks_addon" "vpc-cni" {
  cluster_name = aws_eks_cluster.kristo.name
  addon_name   = "vpc-cni"
}

resource "aws_eks_addon" "eks-pod-identity-agent" {
  cluster_name = aws_eks_cluster.kristo.name
  addon_name   = "eks-pod-identity-agent"
}

resource "aws_eks_node_group" "kristo" {
  depends_on      = [aws_eks_addon.vpc-cni, aws_eks_addon.eks-pod-identity-agent]
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

resource "aws_eks_addon" "aws-ebs-csi-driver" {
  depends_on = [ aws_eks_node_group.kristo ]
  cluster_name = aws_eks_cluster.kristo.name
  addon_name   = "aws-ebs-csi-driver"
}