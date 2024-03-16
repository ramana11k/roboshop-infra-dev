variable "common_tags" {
    default = {
        Project = "roboshop"
        Environment = "dev"
        Terraform = "true"
    }
}

# seperate tag         # user should provide these variables
variable "tags" {
    default = {
        component = "cart"
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


variable "iam_instance_profile" {
    default = "ShellScriptRoleForRoboshop"  
}

 