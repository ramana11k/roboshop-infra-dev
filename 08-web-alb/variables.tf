variable "common_tags" {
    default = {
        Project = "roboshop"
        Environment = "dev"
        Terraform = "true"
    }
}

# seperate tag
variable "tags" {
    default = {
        component = "web-alb"        
    }
}

variable "project_name" {
    default = "roboshop"  
}

variable "environment" {
    default = "dev"  
}

variable "zone_name" {
    default = "nikhildevops.online"  
}