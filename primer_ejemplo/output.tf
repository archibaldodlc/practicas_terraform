output "instancia_ip" {
    value = aws_instance.web.public_ip
}

/* output "subnet_cidr" {
    value = aws_vpc.mivpcconterraform.id
} */

output "all_subnet" {
    value = aws_subnet.misubnetterraform
}

output data_vpc {
    value = data.aws_vpc.vpc_terraform_data
}

output instancia_ip_private {
    value = aws_instance.web.private_ip
}