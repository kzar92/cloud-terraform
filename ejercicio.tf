provider "aws" {
  region = "us-east-1"
}

resource "aws_vpc" "red_vpc" {
  cidr_block = "10.0.0.0/16"
  enable_dns_support = true
  enable_dns_hostnames = true


  tags = {
    Name = "red vpc"
  }
}


resource "aws_subnet" "subred_publica_1" {
  vpc_id     = aws_vpc.red_vpc.id
  cidr_block = "10.0.1.0/24"
  availability_zone = "us-east-1a"

  tags = {
    Name = "Subred publica 1"
  }
}


resource "aws_subnet" "subred_publica_2" {
  vpc_id     = aws_vpc.red_vpc.id
  cidr_block = "10.0.2.0/24"
  availability_zone = "us-east-1b"

  tags = {
    Name = "Subred publica 2"
  }
}


resource "aws_subnet" "subred_privada_1" {
  vpc_id     = aws_vpc.red_vpc.id
  cidr_block = "10.0.3.0/24"
  availability_zone = "us-east-1a"

  tags = {
    Name = "Subred privada 1"
  }
}


resource "aws_subnet" "subred_privada_2" {
  vpc_id     = aws_vpc.red_vpc.id
  cidr_block = "10.0.4.0/24"
  availability_zone = "us-east-1b"

  tags = {
    Name = "Subred privada 2"
  }
}

resource "internet_gateway" "gw" {
  vpc_id = aws_vpc.red_vpc.id

  tags = {
    Name = "Internet gateway"
  }
}


resource "aws_route_table" "tabla_rutas" {
  vpc_id = aws_vpc.red_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = internet_gateway.gw.id
  }

  tags = {
    Name = "Tabla de rutas publicas"
  }
}

resource "aws_route_table_association" "asociacion_subred_publica_1" {
  subnet_id      = aws_subnet.subred_publica_1.id
  route_table_id = aws_route_table.tabla_rutas.id
}

resource "aws_route_table_association" "asociacion_subred_publica_2" {
  subnet_id      = aws_subnet.subred_publica_2.id
  route_table_id = aws_route_table.tabla_rutas.id
}


resource "aws_security_group" "grupo_securidad" {


  name        = "instancia_grupo_seguridad"
  description = "Security group for EC2 instance"

  vpc_id = aws_vpc.red_vpc.id

  ingress {
    from_port   = 0
    to_port     = 65535
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "Instancia EC2_1" {
  ami           = "ami-04b70fa74e45c3917"
  instance_type = "t2.micro"
  subnet_id     = aws_subnet.subred_publica_1.id

  vpc_security_group_ids = [
    aws_security_group.grupo_securidad.id
  ]
  tags = {
    Name = "Instancia EC2"
  }
}


resource "aws_instance" "Instancia EC2_2" {
  ami           = "ami-04b70fa74e45c3917"
  instance_type = "t2.micro"
  subnet_id     = aws_subnet.subred_publica_2.id

  vpc_security_group_ids = [
    aws_security_group.grupo_securidad.id
  ]
  tags = {
    Name = "Instancia EC2"
  }
}


