# Configure the AWS Provider
provider "aws" {
  region = var.region
}

locals {
  prefijo_recursos = "ejemplodocker"
  prefijo_numero = 4
}

resource "aws_vpc" "mivpc"{
    
    cidr_block = "10.10.0.0/16"
    enable_dns_hostnames = true
    enable_dns_support = true
    tags = {
        Name = "${local.prefijo_recursos}-vpc"
        numero = local.prefijo_numero 
    }
}

resource "aws_subnet" "misubnet" {
  vpc_id     = aws_vpc.mivpc.id
  cidr_block = "10.10.10.0/24"

  tags = {
    Name = "${local.prefijo_recursos}-subnet"
    numero = local.prefijo_numero
  }
}

resource "aws_internet_gateway" "miinternetgateway" {
  vpc_id = aws_vpc.mivpc.id

  tags = {
    Name = "${local.prefijo_recursos}-internetgateway"
    numero = local.prefijo_numero
  }
}

resource "aws_route_table" "miroutetable" {
  vpc_id = aws_vpc.mivpc.id

  route = [
    {
      cidr_block = "0.0.0.0/0"
      gateway_id = aws_internet_gateway.miinternetgateway.id
      carrier_gateway_id         = ""
      destination_prefix_list_id = ""
      egress_only_gateway_id     = ""
      instance_id                = ""
      ipv6_cidr_block            = ""
      local_gateway_id           = ""
      nat_gateway_id             = ""
      network_interface_id       = ""
      transit_gateway_id         = ""
      vpc_endpoint_id            = ""
      vpc_peering_connection_id  = ""
    }
  ]

  tags = {
    Name = "${local.prefijo_recursos}-routetable"
    numero = local.prefijo_numero
  }
}

resource "aws_route_table_association" "miroutetableassociation" {
  subnet_id      = aws_subnet.misubnet.id
  route_table_id = aws_route_table.miroutetable.id

}

resource "aws_security_group" "misecuritygroup" {
  name        = "${local.prefijo_recursos}-securitygroup"
  description = "Allow all inbound traffic"
  vpc_id      = aws_vpc.mivpc.id
  
  tags = {
    Name = "${local.prefijo_recursos}-securitygroup"
    numero = local.prefijo_numero
  }
}

resource "aws_security_group_rule" "mireglasecuritygroupssh"{
  type = "ingress"
  from_port        = 22
  to_port          = 22
  protocol         = "tcp"
  cidr_blocks      = ["0.0.0.0/0"]
  ipv6_cidr_blocks = ["::/0"]
  security_group_id = aws_security_group.misecuritygroup.id

}

resource "aws_security_group_rule" "mireglasecuritygroupweb"{
  type = "ingress"
  from_port        = 80
  to_port          = 80
  protocol         = "tcp"
  cidr_blocks      = ["0.0.0.0/0"]
  ipv6_cidr_blocks = ["::/0"]
  security_group_id = aws_security_group.misecuritygroup.id

}

resource "aws_security_group_rule" "mireglasecuritygroupwebsecure"{
  type = "ingress"
  from_port        = 443
  to_port          = 443
  protocol         = "tcp"
  cidr_blocks      = ["0.0.0.0/0"]
  ipv6_cidr_blocks = ["::/0"]
  security_group_id = aws_security_group.misecuritygroup.id

}

resource "aws_security_group_rule" "mireglasecuritygroupegress" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks      = ["0.0.0.0/0"]
  security_group_id = aws_security_group.misecuritygroup.id
}

resource "aws_instance" "web" {
  ami           = var.ami_image
  instance_type = var.tipo_instancia
  subnet_id = aws_subnet.misubnet.id
  associate_public_ip_address = var.asocia_ip_publica
  key_name = "EC2-WEB-SERVER"
  security_groups = ["${aws_security_group.misecuritygroup.id}"]
  connection {
      type = "ssh"
      user = "ec2-user"
      port = 22
      host = self.public_ip 
      private_key = file(var.private_key)
  }

  provisioner "remote-exec" {
      inline = [
          "sleep 3m",
          "sudo yum update -y",
          "sudo yum install docker -y",
          "sudo systemctl start docker",
          "sudo systemctl enable docker",
          "sudo docker run -p 80:80 --name blogdocker -d wordpress"
      ]
  }
  tags = {
    Name = "${local.prefijo_recursos}-instance"
    numero = local.prefijo_numero
  }
}


