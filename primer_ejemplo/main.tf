# Configure the AWS Provider
provider "aws" {
  region = "us-east-1"
}

locals {
  prefijo_recursos = "YoutubeTerraform"
  prefijo_numero = 3
}

data "aws_vpc" "vpc_terraform_data"{
  filter {
    name = "tag:Name"
    values = ["DEFAULTVPC"]
  }
}

/* resource "aws_vpc" "mivpcconterraform" {
  cidr_block       = "192.0.0.0/16"
  instance_tenancy = "default"

  tags =  {
    Name = "${local.prefijo_recursos}"
    numero = local.prefijo_numero
  }
} */

resource "aws_subnet" "misubnetterraform" {
  vpc_id     = data.aws_vpc.vpc_terraform_data.id
  cidr_block = "172.31.160.0/20"

  tags = {
    Name = "${local.prefijo_recursos}"
    numero = local.prefijo_numero
  }
}

resource "aws_instance" "web" {
  ami           = var.ami_image
  instance_type = var.tipo_instancia
  subnet_id = aws_subnet.misubnetterraform.id
  associate_public_ip_address = var.asocia_ip_publica
  tags = {
    Name = "${local.prefijo_recursos}"
    numero = local.prefijo_numero
  }
}



