output "cluster_name"            { value = module.eks.cluster_name }                                                                                       
  output "cluster_endpoint"        { value = module.eks.cluster_endpoint }                                                                                   
  output "ecr_frontend_url"        { value = module.ecr.repository_urls["frontend"] }                                                                        
  output "ecr_backend_url"         { value = module.ecr.repository_urls["backend"] }                                                                         
  output "github_actions_role_arn" { value = module.iam.github_actions_role_arn }                                                                            
  output "vpc_id"                  { value = module.vpc.vpc_id }                
