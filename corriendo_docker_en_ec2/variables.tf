variable "region" {
    type = string
    default = "us-east-1"
    description = "Region of AWS"
}

variable "tipo_instancia" {
    type = string
    default = "t2.micro"
    description = "Tipo de instancia servidor Wordpress"
}

variable "ami_image" {
    type = string
    default = "ami-02e136e904f3da870"
    description = "Ami para usar en la instancia EC2"
}

variable "asocia_ip_publica" {
    type = bool
    default = true
    description = "Valor que define si se requerirá una ip publica para la instancia"
}

variable "private_key" {
    type = string
    default = "/Path/to/SSH_PRIVATE_KEY.pem"
    description = "Ruta completa al directorio de la private key"
}