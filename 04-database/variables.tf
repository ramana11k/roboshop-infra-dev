variable "common_tags" {
    default = {
        Project = "roboshop"
        Environment = "dev"
        Terraform = "true"
    }
}

variable "project_name" {
    default = "roboshop"  
}

variable "environment" {
    default = "dev"  
}

variable "mongodb_subnet_tags" {
    default = {}  
}


variable "zone_name" {
    default = "nikhildevops.online"  
}