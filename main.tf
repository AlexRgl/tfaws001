terraform {
  required_version = ">= 0.13"
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "3.22.0"
    }
  }
}
provider "aws" {
    region = "us-east-1"
}
# aws_instance.instance:
resource "aws_instance" "instance" {
    ami                          = "ami-0885b1f6bd170450c"
#    arn                          = "arn:aws:ec2:us-east-1:026931520972:instance/i-0d30a634b2c850752"
    associate_public_ip_address  = false
    availability_zone            = "us-east-1a"
   # cpu_core_count               = 1
  #  cpu_threads_per_core         = 1
    disable_api_termination      = false
    ebs_optimized                = false
    get_password_data            = false
    hibernation                  = false

 #   id                           = "i-0d30a634b2c850752"
 #   instance_state               = "running"

    user_data = <<-EOF
            #! /bin/bash
            sudo hostnamectl set-hostname apache2
            sudo sh -c 'echo root:Passw0rd | chpasswd'
            sudo apt update
            sudo apt-get -y upgrade
            sudo apt-get -y install apache2
            sudo a2enmod ssl
            sudo a2ensite default-ssl.conf
            sudo systemctl restart apache2
            sudo systemctl enable apache2
            sudo sed -i 's|80|8080|g' ports.conf
            sudo sed -i 's|443|8443|g' ports.conf
            sudo systemctl restart apache2
            EOF

    instance_type                = "t2.micro"
    ipv6_address_count           = 0
    ipv6_addresses               = []
    key_name                     = "Alex"
    monitoring                   = false
  #  primary_network_interface_id = "eni-0ecc1eca5123a1b65"
 #   private_dns                  = "ip-172-31-91-125.ec2.internal"
    private_ip                   = "172.31.91.125"
    secondary_private_ips        = []
    security_groups              = [
        "tf security group1",
    ]
    source_dest_check            = true
  #  subnet_id                    = "subnet-f38e1ad2"
    tags                         = {
        "ANO"   = "2021"
        "CURSO" = "GRSI"
        "Name"  = "Terraform"
    }
    tenancy                      = "default"
    volume_tags                  = {
        "ANO"   = "2021"
        "CURSO" = "GRSI"
    }
    vpc_security_group_ids = [ aws_security_group.instance.id,     ]



    credit_specification {
        cpu_credits = "standard"
    }

    enclave_options {
        enabled = false
    }

    metadata_options {
        http_endpoint               = "enabled"
        http_put_response_hop_limit = 1
        http_tokens                 = "optional"
    }

    root_block_device {
        delete_on_termination = true
     #   device_name           = "/dev/sda1"
        encrypted             = false
       # iops                  = 100
       # throughput            = 0
      #  volume_id             = "vol-0990b850e6ac72209"
        volume_size           = 24
        volume_type           = "gp2"
    }



    timeouts {}
}

# aws_security_group.instance:
resource "aws_security_group" "instance" {
  #  arn         = "arn:aws:ec2:us-east-1:026931520972:security-group/sg-04f9f4d4e2b4a5654"
    description = "tf security group1"
    egress      = [
        {
            cidr_blocks      = [
                "0.0.0.0/0",
            ]
            description      = ""
            from_port        = 0
            ipv6_cidr_blocks = []
            prefix_list_ids  = []
            protocol         = "-1"
            security_groups  = []
            self             = false
            to_port          = 0
        },
    ]
  #  id          = "sg-04f9f4d4e2b4a5654"
    ingress     = [
        {
            cidr_blocks      = [
                "82.154.9.231/32",
                "10.0.0.0/8",
                "172.16.0.0/12",
                "192.168.0.0/16",
            ]
            description      = ""
            from_port        = 0
            ipv6_cidr_blocks = []
            prefix_list_ids  = []
            protocol         = "-1"
            security_groups  = []
            self             = false
            to_port          = 0
        },
    ]
    name        = "tf security group1"
   # owner_id    = "026931520972"
    tags        = {
        name = "tf security group1"
    }


    timeouts {}


}
