variable "tipo_instancia" {
    type = string
    default = "t2.large"
    description = "Tipo de instancia servidor Wordpress"
}

variable "ami_image" {
    type = string
    description = "Ami para usar en la instancia EC2"
}

variable "asocia_ip_publica" {
    type = bool
    description = "Valor que define si se requerirá una ip publica para la instancia"
}

