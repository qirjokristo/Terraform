resource "aws_eks_cluster" "kristo" {
  name = "kristo-test-cluster"
  role_arn = aws_iam_role.eks.arn
  vpc_config {
    subnet_ids = aws_subnet.public[*].id
    security_group_ids = [aws_security_group.ec2_sg]
    endpoint_public_access = true
    endpoint_private_access = true
  }
}