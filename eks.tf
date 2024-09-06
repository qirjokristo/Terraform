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

resource "null_resource" "eks_context" {
  depends_on = [aws_eks_cluster.kristo]
  provisioner "local-exec" {
    command = "aws eks update-kubeconfig --name kristo-cluster --region ${var.region}"
  }
}


resource "null_resource" "calico" {
  depends_on = [null_resource.eks_context, aws_eks_addon.vpc-cni]
  provisioner "local-exec" {
    command = "kubectl apply -f ./eks_manifests/calico.yaml"
  }
}

resource "aws_launch_template" "nodegroup" {
  name = "nodegroup-lt"
  instance_type          = "t2.micro"
  vpc_security_group_ids = [aws_security_group.eks_sg.id]
  tags                   = var.common_tags
  tag_specifications {
    resource_type = "instance"
    tags          = var.common_tags
  }
  metadata_options {
    http_tokens = "required"
    http_put_response_hop_limit = 3
  }
}

resource "aws_eks_node_group" "kristo" {
  depends_on      = [aws_launch_template.nodegroup]
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

# resource "helm_release" "calico" {
#   depends_on = [ aws_eks_node_group.kristo ]
#   dependency_update = true
#   name       = "tigera-operator"
#   repository = "https://docs.tigera.io/calico/charts"
#   namespace  = "calico"
#   create_namespace = true
#   chart      = "tigera-operator"
#   values = [ file("${path.module}/eks_manifests/calico_values/values.yaml") ]
# }


resource "helm_release" "alb" {
  depends_on = [ aws_eks_node_group.kristo ]
  dependency_update = true
  name       = "aws-load-balancer-controller"
  repository = "https://aws.github.io/eks-charts"
  namespace  = "kube-system"
  chart      = "aws-load-balancer-controller"
  version = "v1.8.2"
  values = [file("${path.module}/eks_manifests/alb_values/values.yaml")]
}

resource "aws_eks_addon" "aws-ebs-csi-driver" {
  depends_on   = [aws_eks_node_group.kristo]
  cluster_name = aws_eks_cluster.kristo.name
  addon_name   = "aws-ebs-csi-driver"
}

# resource "null_resource" "cert" {
#   provisioner "local-exec" {
#     command = "kubectl apply --validate=false -f ./eks_manifests/cert.yaml"
#   }
# }

# resource "null_resource" "alb" {
#   depends_on = [ null_resource.cert ]
#   provisioner "local-exec" {
#     command = "kubectl apply -f ./eks_manifests/alb.yaml"
#   }
# }

