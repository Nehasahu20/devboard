resource "aws_eks_cluster" "main" {                                                                                                                        
    name     = "${var.project_name}-cluster"                                                                                                                 
    version  = var.cluster_version                                                                                                                           
    role_arn = var.eks_cluster_role_arn                                                                                                                      
    vpc_config {                                                                                                                                             
      subnet_ids              = concat(var.private_subnet_ids, var.public_subnet_ids)                                                                        
      endpoint_public_access  = true                                                                                                                         
      endpoint_private_access = true                                                                                                                         
    }                                                                                                                                                        
    tags = { Project = var.project_name }                                                                                                                    
  }                                                                                                                                                          
                                                                                                                                                             
  resource "aws_eks_node_group" "main" {                                                                                                                     
    cluster_name    = aws_eks_cluster.main.name
    node_group_name = "${var.project_name}-nodes"                                                                                                            
    node_role_arn   = var.eks_nodegroup_role_arn                                                                                                             
    subnet_ids      = var.private_subnet_ids                                                                                                                 
    instance_types  = [var.node_instance_type]                                                                                                               
    scaling_config {                                                                                                                                         
      desired_size = var.node_desired_size                                                                                                                   
      min_size     = var.node_min_size                                                                                                                       
      max_size     = var.node_max_size                                                                                                                       
    }                                                                                                                                                        
    update_config { max_unavailable = 1 }                                                                                                                    
    tags       = { Project = var.project_name }                                                                                                              
    depends_on = [aws_eks_cluster.main]                                                                                                                      
  }                                                                                                                                                          
                                                                                                                                                             
                                                                                                                                                             
  resource "aws_eks_addon" "coredns" {                                                                                                                       
    cluster_name = aws_eks_cluster.main.name
    addon_name   = "coredns"                                                                                                                                 
    depends_on   = [aws_eks_node_group.main]                                                                                                                 
  }                                                                                                                                                          
                                                                                                                                                             
  resource "aws_eks_addon" "kube_proxy" {                                                                                                                    
    cluster_name = aws_eks_cluster.main.name
    addon_name   = "kube-proxy"                                                                                                                              
    depends_on   = [aws_eks_node_group.main]                                                                                                                 
  }                                 
