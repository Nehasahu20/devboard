variable "project_name"           {}                                                                                                                       
  variable "cluster_version"        {}                                                                                                                       
  variable "vpc_id"                  {}                                                                                                                      
  variable "private_subnet_ids"     { type = list(string) }                                                                                                  
  variable "public_subnet_ids"      { type = list(string) }                                                                                                  
  variable "eks_cluster_role_arn"   {}                                                                                                                       
  variable "eks_nodegroup_role_arn" {}                                                                                                                       
  variable "node_instance_type"     {}                                                                                                                       
  variable "node_desired_size"      { type = number }                                                                                                        
  variable "node_min_size"          { type = number }                                                                                                        
  variable "node_max_size"          { type = number }       
