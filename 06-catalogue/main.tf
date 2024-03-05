resource "aws_lb_target_group" "catalogue" {
  name     = "${local.name}-${var.tags.component}"
  port     = 80
  protocol = "HTTP"
  vpc_id   = data.aws_ssm_parameter.vpc_id.value
   health_check {
      healthy_threshold   = 2
      interval            = 10
      unhealthy_threshold = 3
      timeout             = 5
      path                = "/health"
      port                = 8080
      matcher             = "200-299"
  }
}


module "catalogue" {
  source  = "terraform-aws-modules/ec2-instance/aws"  # it is the open source module
  ami = data.aws_ami.centos8.id
  name = "${local.name}-${var.tags.component}-ami"
  instance_type          = "t2.micro"
  vpc_security_group_ids = [data.aws_ssm_parameter.catalogue_sg_id.value]
  subnet_id              = element(split(",", data.aws_ssm_parameter.private_subnet_id.value), 0)
  iam_instance_profile = "ShellScriptRoleForRoboshop"

  tags = merge(
    var.common_tags,  
    var.tags       
  )
}


resource "null_resource" "catalogue" {
  # Changes to any instance of the cluster requires re-provisioning
  triggers = {
    instance_id = module.catalogue.id
  }

  # Bootstrap script can run on any instance of the cluster
  # So we just choose the first in this case
  connection {
    host = module.catalogue.private_ip
    type = "ssh"
    user = "centos"
    password = "DevOps321"
  }

 provisioner "file" {
        source      = "bootstrap.sh"
        destination = "/tmp/bootstrap.sh"
      }

  provisioner "remote-exec" {
    # Bootstrap script called with private_ip of each node in the cluster
    inline = [
      "chmod +x /tmp/bootstrap.sh",
      "sudo sh /tmp/bootstrap.sh catalogue dev"      
    ]
  }
}
 ### stop the instance
resource "aws_ec2_instance_state" "catalogue" {
  instance_id = module.catalogue.id
  state       = "stopped"
  depends_on = [ null_resource.catalogue ]
}

#### create  AMI for the catalogue instance

resource "aws_ami_from_instance" "catalogue" {
  name               = "${local.name}-${var.tags.component}-${local.current_time}"
  source_instance_id = module.catalogue.id
  depends_on = [ aws_ec2_instance_state.catalogue ]
}

#### termninate the catalogue instance

resource "null_resource" "catalogue_delete" {
  # Changes to any instance of the cluster requires re-provisioning
  triggers = {
    instance_id = module.catalogue.id
  }

  provisioner "local-exec" {
    command =  "aws ec2 terminate-instances --instance-ids ${module.catalogue.id}"               
  }
  depends_on = [ aws_ami_from_instance.catalogue ]
}