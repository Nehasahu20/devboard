resource "aws_iam_role" "eks_cluster" {                                                                                                                    
    name = "${var.project_name}-eks-cluster-role"                                                                                                            
    assume_role_policy = jsonencode({                                                                                                                        
      Version = "2012-10-17"                                                                                                                                 
      Statement = [{ Effect = "Allow", Principal = { Service = "eks.amazonaws.com" }, Action = "sts:AssumeRole" }]                                           
    })                                                                                                                                                       
  }                                                                                                                                                          
                                                                                                                                                             
  resource "aws_iam_role_policy_attachment" "eks_cluster_policy" {                                                                                           
    role       = aws_iam_role.eks_cluster.name
    policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"                                                                                            
  }                                                                                                                                                          
                                                                                                                                                             
  resource "aws_iam_role" "eks_nodegroup" {                                                                                                                  
    name = "${var.project_name}-eks-nodegroup-role"
    assume_role_policy = jsonencode({                                                                                                                        
      Version = "2012-10-17"                                                                                                                                 
      Statement = [{ Effect = "Allow", Principal = { Service = "ec2.amazonaws.com" }, Action = "sts:AssumeRole" }]                                           
    })                                                                                                                                                       
  }                                                                                                                                                          
                                                                                                                                                             
  resource "aws_iam_role_policy_attachment" "eks_worker_node" {                                                                                              
    role       = aws_iam_role.eks_nodegroup.name
    policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"                                                                                         
  }                                                                                                                                                          
                                                                                                                                                             
  resource "aws_iam_role_policy_attachment" "eks_cni" {                                                                                                      
    role       = aws_iam_role.eks_nodegroup.name
    policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"                                                                                              
  }                                                                                                                                                          
                                                                                                                                                             
  resource "aws_iam_role_policy_attachment" "ecr_read" {                                                                                                     
    role       = aws_iam_role.eks_nodegroup.name
    policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"                                                                                
  }                                                                                                                                                          
                                                                                                                                                             
  data "tls_certificate" "github" {                                                                                                                          
    url = "https://token.actions.githubusercontent.com/.well-known/openid-configuration"
  }                                                                                                                                                          
                  
  resource "aws_iam_openid_connect_provider" "github" {                                                                                                      
    url             = "https://token.actions.githubusercontent.com"
    client_id_list  = ["sts.amazonaws.com"]                                                                                                                  
    thumbprint_list = [data.tls_certificate.github.certificates[0].sha1_fingerprint]                                                                         
  }                                                                                                                                                          
                                                                                                                                                             
  resource "aws_iam_role" "github_actions" {                                                                                                                 
    name = "${var.project_name}-github-actions-role"
    assume_role_policy = jsonencode({                                                                                                                        
      Version = "2012-10-17"                                                                                                                                 
      Statement = [{                                                                                                                                         
        Effect    = "Allow"                                                                                                                                  
        Principal = { Federated = aws_iam_openid_connect_provider.github.arn }                                                                               
        Action    = "sts:AssumeRoleWithWebIdentity"                                                                                                          
        Condition = {                                                                                                                                        
          StringLike   = { "token.actions.githubusercontent.com:sub" = "repo:${var.github_org}/${var.github_repo}:*" }                                       
          StringEquals = { "token.actions.githubusercontent.com:aud" = "sts.amazonaws.com" }                                                                 
        }                                                                                                                                                    
      }]                                                                                                                                                     
    })                                                                                                                                                       
  }               
                                                                                                                                                             
  resource "aws_iam_role_policy_attachment" "github_ecr" {                                                                                                   
    role       = aws_iam_role.github_actions.name
    policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryPowerUser"                                                                               
  }                                                                                                                                                          
                                                                                                                                                             
  resource "aws_iam_role_policy" "github_eks" {                                                                                                              
    name = "eks-access"                                                                                                                                      
    role = aws_iam_role.github_actions.id                                                                                                                    
    policy = jsonencode({                                                                                                                                    
      Version = "2012-10-17"                                                                                                                                 
      Statement = [{ Effect = "Allow", Action = ["eks:DescribeCluster", "eks:ListClusters"], Resource = "*" }]                                               
    })                                                                                                                                                       
  }                       
