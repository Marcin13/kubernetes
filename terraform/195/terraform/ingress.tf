
# data "aws_eks_cluster" "eks_cluster" {
#   name = "${local.env}-${local.eks_name}-eks-cluster"
# }

# data "aws_eks_cluster_auth" "eks_cluster" {
#   name = "${local.env}-${local.eks_name}-eks-cluster"
# }

# provider "kubernetes" {
#   host                   = data.aws_eks_cluster.eks_cluster.endpoint
#   cluster_ca_certificate = base64decode(data.aws_eks_cluster.eks_cluster.certificate_authority[0].data)
#   token                  = data.aws_eks_cluster_auth.eks_cluster.token
# }

# resource "aws_iam_openid_connect_provider" "eks" {
#   client_id_list  = ["sts.amazonaws.com"]
#   thumbprint_list = [data.aws_eks_cluster.eks_cluster.identity.0.oidc.0.thumbprint]
#   url             = data.aws_eks_cluster.eks_cluster.identity.0.oidc.0.issuer
# }

# resource "aws_iam_policy" "nginx_ingress_policy" {
#   name        = "NGINXIngressControllerPolicy"
#   description = "Policy for NGINX Ingress Controller to access AWS resources"
#   policy      = <<EOF
# {
#   "Version": "2012-10-17",
#   "Statement": [
#     {
#       "Effect": "Allow",
#       "Action": [
#         "ec2:DescribeInstances",
#         "ec2:DescribeTags",
#         "elasticloadbalancing:*",
#         "iam:ListServerCertificates",
#         "iam:GetServerCertificate",
#         "acm:ListCertificates",
#         "acm:DescribeCertificate",
#         "waf-regional:GetWebACLForResource",
#         "waf-regional:AssociateWebACL",
#         "waf-regional:DisassociateWebACL",
#         "wafv2:GetWebACLForResource",
#         "wafv2:AssociateWebACL",
#         "wafv2:DisassociateWebACL",
#         "shield:GetSubscriptionState",
#         "shield:DescribeProtection",
#         "shield:CreateProtection",
#         "shield:DeleteProtection"
#       ],
#       "Resource": "*"
#     }
#   ]
# }
# EOF
# }

# resource "aws_iam_role" "nginx_ingress_role" {
#   name = "nginx-ingress-role"

#   assume_role_policy = <<EOF
# {
#   "Version": "2012-10-17",
#   "Statement": [
#     {
#       "Effect": "Allow",
#       "Principal": {
#         "Federated": "${aws_iam_openid_connect_provider.eks.arn}"
#       },
#       "Action": "sts:AssumeRoleWithWebIdentity",
#       "Condition": {
#         "StringEquals": {
#           "${replace(data.aws_eks_cluster.eks_cluster.identity[0].oidc[0].issuer, "https://", "")}:sub": "system:serviceaccount:kube-system:nginx-ingress"
#         }
#       }
#     }
#   ]
# }
# EOF
# }

# resource "aws_iam_role_policy_attachment" "nginx_ingress_policy_attachment" {
#   role       = aws_iam_role.nginx_ingress_role.name
#   policy_arn = aws_iam_policy.nginx_ingress_policy.arn
# }

# resource "kubernetes_service_account" "nginx_ingress" {
#   metadata {
#     name      = "nginx-ingress"
#     namespace = "kube-system"
#     annotations = {
#       "eks.amazonaws.com/role-arn" = aws_iam_role.nginx_ingress_role.arn
#     }
#   }
# }

# module "helm_nginx_ingress" {
#   source  = "terraform-helm-repo/modules/helm"
#   name    = "nginx-ingress"
#   chart   = "ingress-nginx"
#   version = "4.0.6"

#   set {
#     name  = "controller.serviceAccount.create"
#     value = "false"
#   }

#   set {
#     name  = "controller.serviceAccount.name"
#     value = "nginx-ingress"
#   }

#   set {
#     name  = "controller.service.type"
#     value = "LoadBalancer"
#   }
# }
