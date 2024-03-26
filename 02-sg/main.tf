module "vpn" {
  source = "git::https://github.com/ramana11k/terraform-aws-security-group.git?ref=main"
  project_name = var.project_name
  environment = var.environment
  sg_decription = "SG for vpn"
  vpc_id = data.aws_vpc.default.id
  sg_name = "vpn" 
  common_tags = var.common_tags
  sg_tags = var.sg_tags
  #sg_ingress_rules = var.mongodb_sg_ingress_rules
}


module "mongodb" {
  source = "git::https://github.com/ramana11k/terraform-aws-security-group.git?ref=main"
  project_name = var.project_name
  environment = var.environment
  sg_decription = "SG for mongodb"
  vpc_id = data.aws_ssm_parameter.vpc_id.value
  sg_name = "mongodb" 
  common_tags = var.common_tags
  sg_tags = var.sg_tags
  #sg_ingress_rules = var.mongodb_sg_ingress_rules #this will add port 80 and 443
}

module "redis" {
  source = "git::https://github.com/ramana11k/terraform-aws-security-group.git?ref=main"
  project_name = var.project_name
  environment = var.environment
  sg_decription = "SG for redis"
  vpc_id = data.aws_ssm_parameter.vpc_id.value
  sg_name = "redis" 
  common_tags = var.common_tags
  sg_tags = var.sg_tags  
}

module "mysql" {
  source = "git::https://github.com/ramana11k/terraform-aws-security-group.git?ref=main"
  project_name = var.project_name
  environment = var.environment
  sg_decription = "SG for mysql"
  vpc_id = data.aws_ssm_parameter.vpc_id.value
  sg_name = "mysql" 
  common_tags = var.common_tags
  sg_tags = var.sg_tags  
}

module "rabbitmq" {
  source = "git::https://github.com/ramana11k/terraform-aws-security-group.git?ref=main"
  project_name = var.project_name
  environment = var.environment
  sg_decription = "SG for rabbitmq"
  vpc_id = data.aws_ssm_parameter.vpc_id.value
  sg_name = "rabbitmq" 
  common_tags = var.common_tags
  sg_tags = var.sg_tags  
}


module "catalogue" {
  source = "git::https://github.com/ramana11k/terraform-aws-security-group.git?ref=main"
  project_name = var.project_name
  environment = var.environment
  sg_decription = "SG for catalogue"
  vpc_id = data.aws_ssm_parameter.vpc_id.value
  sg_name = "catalogue" 
  common_tags = var.common_tags
  sg_tags = var.sg_tags
  #sg_ingress_rules = var.mongodb_sg_ingress_rules

}

module "user" {
  source = "git::https://github.com/ramana11k/terraform-aws-security-group.git?ref=main"
  project_name = var.project_name
  environment = var.environment
  sg_decription = "SG for user"
  vpc_id = data.aws_ssm_parameter.vpc_id.value
  sg_name = "user" 
  common_tags = var.common_tags
  sg_tags = var.sg_tags  
}

module "cart" {
  source = "git::https://github.com/ramana11k/terraform-aws-security-group.git?ref=main"
  project_name = var.project_name
  environment = var.environment
  sg_decription = "SG for cart"
  vpc_id = data.aws_ssm_parameter.vpc_id.value
  sg_name = "cart" 
  common_tags = var.common_tags
  sg_tags = var.sg_tags  
}

module "shipping" {
  source = "git::https://github.com/ramana11k/terraform-aws-security-group.git?ref=main"
  project_name = var.project_name
  environment = var.environment
  sg_decription = "SG for shipping"
  vpc_id = data.aws_ssm_parameter.vpc_id.value
  sg_name = "shipping" 
  common_tags = var.common_tags
  sg_tags = var.sg_tags  
}

module "payment" {
  source = "git::https://github.com/ramana11k/terraform-aws-security-group.git?ref=main"
  project_name = var.project_name
  environment = var.environment
  sg_decription = "SG for payment"
  vpc_id = data.aws_ssm_parameter.vpc_id.value
  sg_name = "payment" 
  common_tags = var.common_tags
  sg_tags = var.sg_tags  
}

module "web" {
  source = "git::https://github.com/ramana11k/terraform-aws-security-group.git?ref=main"
  project_name = var.project_name
  environment = var.environment
  sg_decription = "SG for web"
  vpc_id = data.aws_ssm_parameter.vpc_id.value
  sg_name = "web" 
  common_tags = var.common_tags
  sg_tags = var.sg_tags  
}


module "app_alb" {
  source = "git::https://github.com/ramana11k/terraform-aws-security-group.git?ref=main"
  project_name = var.project_name
  environment = var.environment
  sg_decription = "SG for APP ALB"
  vpc_id = data.aws_ssm_parameter.vpc_id.value
  sg_name = "app_alb" 
  common_tags = var.common_tags
  sg_tags = var.sg_tags  
}

module "web_alb" {
  source = "git::https://github.com/ramana11k/terraform-aws-security-group.git?ref=main"
  project_name = var.project_name
  environment = var.environment
  sg_decription = "SG for web ALB"
  vpc_id = data.aws_ssm_parameter.vpc_id.value
  sg_name = "web_alb" 
  common_tags = var.common_tags
  sg_tags = var.sg_tags  
}

################## security group rules  ##############

# APP ALB should accept the connection only from vpn, since it is internal
resource "aws_security_group_rule" "app_alb_vpn" {
  security_group_id = module.app_alb.sg_id  
  type              = "ingress"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  source_security_group_id = module.vpn.sg_id
}
## session:38 - 33.18 # The app_alb should accept the connection from web
resource "aws_security_group_rule" "app_alb_web" {
  security_group_id = module.app_alb.sg_id  
  type              = "ingress"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  source_security_group_id = module.web.sg_id
}

resource "aws_security_group_rule" "app_alb_cart" {
  security_group_id = module.app_alb.sg_id  
  type              = "ingress"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  source_security_group_id = module.cart.sg_id
}


resource "aws_security_group_rule" "app_alb_shipping" {
  security_group_id = module.app_alb.sg_id  
  type              = "ingress"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  source_security_group_id = module.shipping.sg_id
}


resource "aws_security_group_rule" "app_alb_payment" {
  security_group_id = module.app_alb.sg_id  
  type              = "ingress"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  source_security_group_id = module.payment.sg_id
}


resource "aws_security_group_rule" "app_alb_user" {
  security_group_id = module.app_alb.sg_id  
  type              = "ingress"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  source_security_group_id = module.user.sg_id
}


resource "aws_security_group_rule" "app_alb_catalogue" {
  security_group_id = module.app_alb.sg_id  
  type              = "ingress"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  source_security_group_id = module.catalogue.sg_id
}


# openvpn security group rule to accept the connection from laptop/home
resource "aws_security_group_rule" "vpn_home" {
  security_group_id = module.vpn.sg_id  
  type              = "ingress"
  from_port         = 0
  to_port           = 65535
  protocol          = "-1"
  cidr_blocks = ["0.0.0.0/0"] #ideally your home ip address, but it frequently changes
}
  
# security group rule for "mongodb" to accept connection from vpn, catalogue, and user
resource "aws_security_group_rule" "mongodb_vpn" {
  security_group_id = module.mongodb.sg_id  
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  source_security_group_id = module.vpn.sg_id
}

resource "aws_security_group_rule" "mongodb_catalogue" {
  security_group_id = module.mongodb.sg_id  
  type              = "ingress"
  from_port         = 27017
  to_port           = 27017
  protocol          = "tcp"
  source_security_group_id = module.catalogue.sg_id
}

resource "aws_security_group_rule" "mongodb_user" {
  security_group_id = module.mongodb.sg_id  
  type              = "ingress"
  from_port         = 27017
  to_port           = 27017
  protocol          = "tcp"
  source_security_group_id = module.user.sg_id
}


# security group rule for "redis" to accept connections from vpn, user, and cart
resource "aws_security_group_rule" "redis_vpn" {
  security_group_id = module.redis.sg_id  
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  source_security_group_id = module.vpn.sg_id
}

resource "aws_security_group_rule" "redis_user" {
  security_group_id = module.redis.sg_id  
  type              = "ingress"
  from_port         = 6379
  to_port           = 6379
  protocol          = "tcp"
  source_security_group_id = module.user.sg_id
}

resource "aws_security_group_rule" "redis_cart" {
  security_group_id = module.redis.sg_id  
  type              = "ingress"
  from_port         = 6379
  to_port           = 6379
  protocol          = "tcp"
  source_security_group_id = module.cart.sg_id
}

# security group rule for "mysql" to accept connections from vpn, and shipping

resource "aws_security_group_rule" "mysql_vpn" {
  security_group_id = module.mysql.sg_id  
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  source_security_group_id = module.vpn.sg_id
}

resource "aws_security_group_rule" "mysql_shipping" {
  security_group_id = module.mysql.sg_id  
  type              = "ingress"
  from_port         = 3306
  to_port           = 3306
  protocol          = "tcp"
  source_security_group_id = module.shipping.sg_id
}


# security group rule for "rabbitmq" to accept connections from vpn, and payment

resource "aws_security_group_rule" "rabbitmq_vpn" {
  security_group_id = module.rabbitmq.sg_id  
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  source_security_group_id = module.vpn.sg_id
}

resource "aws_security_group_rule" "rabbitmq_payment" {
  security_group_id = module.rabbitmq.sg_id  
  type              = "ingress"
  from_port         = 5672
  to_port           = 5672
  protocol          = "tcp"
  source_security_group_id = module.payment.sg_id
}


# security group rule for "catalogue" to accept connections from vpn, web, and cart

resource "aws_security_group_rule" "catalogue_vpn" {
  security_group_id = module.catalogue.sg_id  
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  source_security_group_id = module.vpn.sg_id
}


resource "aws_security_group_rule" "catalogue_vpn_http" {
  security_group_id = module.catalogue.sg_id  
  type              = "ingress"
  from_port         = 8080
  to_port           = 8080
  protocol          = "tcp"
  source_security_group_id = module.vpn.sg_id
}


# resource "aws_security_group_rule" "catalogue_web" {
#   security_group_id = module.catalogue.sg_id  
#   type              = "ingress"
#   from_port         = 8080
#   to_port           = 8080
#   protocol          = "tcp"
#   source_security_group_id = module.web.sg_id
# }


resource "aws_security_group_rule" "catalogue_app_alb" {
  security_group_id = module.catalogue.sg_id  
  type              = "ingress"
  from_port         = 8080
  to_port           = 8080
  protocol          = "tcp"
  source_security_group_id = module.app_alb.sg_id
}

# resource "aws_security_group_rule" "catalogue_cart" {
#   security_group_id = module.catalogue.sg_id  
#   type              = "ingress"
#   from_port         = 8080
#   to_port           = 8080
#   protocol          = "tcp"
#   source_security_group_id = module.cart.sg_id
# }


# security group rule for "user" to accept connections from vpn, web, and payment

resource "aws_security_group_rule" "user_vpn" {
  security_group_id = module.user.sg_id  
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  source_security_group_id = module.vpn.sg_id
}

resource "aws_security_group_rule" "user_app_alb" {
  security_group_id = module.user.sg_id  
  type              = "ingress"
  from_port         = 8080
  to_port           = 8080
  protocol          = "tcp"
  source_security_group_id = module.app_alb.sg_id
}


resource "aws_security_group_rule" "cart_vpn" {
  security_group_id = module.cart.sg_id  
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  source_security_group_id = module.vpn.sg_id
}

resource "aws_security_group_rule" "cart_app_alb" {
  security_group_id = module.cart.sg_id  
  type              = "ingress"
  from_port         = 8080
  to_port           = 8080
  protocol          = "tcp"
  source_security_group_id = module.app_alb.sg_id
}

# resource "aws_security_group_rule" "user_web" {
#   security_group_id = module.user.sg_id  
#   type              = "ingress"
#   from_port         = 8080
#   to_port           = 8080
#   protocol          = "tcp"
#   source_security_group_id = module.web.sg_id
# }

# resource "aws_security_group_rule" "user_payment" {
#   security_group_id = module.user.sg_id  
#   type              = "ingress"
#   from_port         = 8080
#   to_port           = 8080
#   protocol          = "tcp"
#   source_security_group_id = module.payment.sg_id
# }


# security group rule for "shipping" to accept connections from vpn, and web

resource "aws_security_group_rule" "shipping_vpn" {
  security_group_id = module.shipping.sg_id  
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  source_security_group_id = module.vpn.sg_id
}

# resource "aws_security_group_rule" "shipping_web" {
#   security_group_id = module.shipping.sg_id  
#   type              = "ingress"
#   from_port         = 8080
#   to_port           = 8080
#   protocol          = "tcp"
#   source_security_group_id = module.web.sg_id
# }


resource "aws_security_group_rule" "shipping_app_alb" {
  security_group_id = module.shipping.sg_id  
  type              = "ingress"
  from_port         = 8080
  to_port           = 8080
  protocol          = "tcp"
  source_security_group_id = module.app_alb.sg_id
}

# security group rule for "payment" to accept connections from vpn, and web

resource "aws_security_group_rule" "payment_vpn" {
  security_group_id = module.payment.sg_id  
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  source_security_group_id = module.vpn.sg_id
}

# resource "aws_security_group_rule" "payment_web" {
#   security_group_id = module.payment.sg_id  
#   type              = "ingress"
#   from_port         = 8080
#   to_port           = 8080
#   protocol          = "tcp"
#   source_security_group_id = module.web.sg_id
# }


resource "aws_security_group_rule" "payment_app_alb" {
  security_group_id = module.payment.sg_id  
  type              = "ingress"
  from_port         = 8080
  to_port           = 8080
  protocol          = "tcp"
  source_security_group_id = module.app_alb.sg_id
}

# security group rule for "web" to accept connections from vpn, and internet

resource "aws_security_group_rule" "web_vpn" {
  security_group_id        = module.web.sg_id
  type                     = "ingress"
  from_port                = 22
  to_port                  = 22
  protocol                 = "tcp"
  source_security_group_id = module.vpn.sg_id
}

resource "aws_security_group_rule" "web_alb_vpn" {
  security_group_id = module.web_alb.sg_id  
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  source_security_group_id = module.vpn.sg_id
}

resource "aws_security_group_rule" "web_alb_internet" {
  security_group_id = module.web_alb.sg_id  
  type              = "ingress"
  from_port         = 443
  to_port           = 443
  protocol          = "tcp"
  cidr_blocks = ["0.0.0.0/0"]  
}
