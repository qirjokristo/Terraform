resource "aws_eks_cluster" "kristo" {
  name = "kristo-test-cluster"
  role_arn = aws_iam_role.eks.arn
  vpc_config {
    subnet_ids = aws_subnet.pub[*].id
    security_group_ids = [aws_security_group.ec2_sg.id]
    endpoint_public_access = true
    endpoint_private_access = true
  }
}

resource "aws_eks_node_group" "kristo" {
  cluster_name = aws_eks_cluster.kristo.name
  subnet_ids = aws_subnet.pub[*].id
  node_role_arn = aws_iam_role.eks.arn
  node_group_name = "kristo-test-ng"
  scaling_config {
    desired_size = 3
    max_size = 6
    min_size = 2
  }
}