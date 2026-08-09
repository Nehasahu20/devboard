resource "aws_ecr_repository" "repos" {
    for_each             = toset(var.repositories)                                                                                                           
    name                 = "${var.project_name}-${each.key}"                                                                                                 
    image_tag_mutability = "MUTABLE"                                                                                                                         
    image_scanning_configuration { scan_on_push = true }                                                                                                     
    tags = { Project = var.project_name }                                                                                                                    
  }                                                                                                                                                          
                                                                                                                                                             
  resource "aws_ecr_lifecycle_policy" "cleanup" {                                                                                                            
    for_each   = aws_ecr_repository.repos                                                                                                                    
    repository = each.value.name                                                                                                                             
    policy = jsonencode({                                                                                                                                    
      rules = [{                                                                                                                                             
        rulePriority = 1                                                                                                                                     
        description  = "Remove untagged images after 7 days"                                                                                                 
        selection = {                                                                                                                                        
          tagStatus   = "untagged"                                                                                                                           
          countType   = "sinceImagePushed"                                                                                                                   
          countUnit   = "days"                                                                                                                               
          countNumber = 7                                                                                                                                    
        }                                                                                                                                                    
        action = { type = "expire" }                                                                                                                         
      }]                                                                                                                                                     
    })                                                                                                                                                       
  }                               
