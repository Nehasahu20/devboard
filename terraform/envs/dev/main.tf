terraform {                                                                                                                                                
    required_version = ">= 1.5.0"                                                                                                                            
    required_providers {                                                                                                                                     
      aws = { source = "hashicorp/aws", version = "~> 5.0" }                                                                                                 
    }                                                                                                                                                        
  }                                                                                                                                                          
                                                                                                                                                             
  provider "aws" { region = var.aws_region }
                                                                                                                                                             
  module "vpc" {  
    source             = "../../modules/vpc"
    project_name       = var.project_name
    vpc_cidr           = var.vpc_cidr                                                                                                                        
    availability_zones = var.availability_zones                                                                                                              
    public_subnets     = var.public_subnets                                                                                                                  
    private_subnets    = var.private_subnets                                                                                                                 
  }                                                                                                                                                          
                                                                                                                                                             
  module "ecr" {                                                                                                                                             
    source       = "../../modules/ecr"
    project_name = var.project_name                                                                                                                          
    repositories = ["frontend", "backend"]                                                                                                                   
  }                                                                                                                                                          
                                                                                                                                                             
  module "iam" {                                                                                                                                             
    source         = "../../modules/iam"
    project_name   = var.project_name                                                                                                                        
    github_org     = var.github_org                                                                                                                          
    github_repo    = var.github_repo                                                                                                                         
    aws_account_id = data.aws_caller_identity.current.account_id                                                                                             
  }                                                                                                                                                          
  
  module "eks" {                                                                                                                                             
    source                 = "../../modules/eks"
    project_name           = var.project_name                                                                                                                
    cluster_version        = var.cluster_version                                                                                                             
    vpc_id                 = module.vpc.vpc_id                                                                                                               
    private_subnet_ids     = module.vpc.private_subnet_ids                                                                                                   
    public_subnet_ids      = module.vpc.public_subnet_ids                                                                                                    
    eks_cluster_role_arn   = module.iam.eks_cluster_role_arn                                                                                                 
    eks_nodegroup_role_arn = module.iam.eks_nodegroup_role_arn                                                                                               
    node_instance_type     = var.node_instance_type                                                                                                          
    node_desired_size      = var.node_desired_size                                                                                                           
    node_min_size          = var.node_min_size                                                                                                               
    node_max_size          = var.node_max_size                                                                                                               
  }                                                                                                                                                          
                                                                                                                                                             
  data "aws_caller_identity" "current" {}        
