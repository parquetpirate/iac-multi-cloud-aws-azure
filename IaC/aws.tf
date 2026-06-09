# ── VPC ──────────────────────────────────────────────────────────────────────

resource "aws_vpc" "aws_my_vpc" {
  cidr_block = "10.0.0.0/16"

  tags = {
    Name = "${var.name}_vpc"
  }
}

# ── Public subnets ───────────────────────────────────────────────────────────

resource "aws_subnet" "aws_public_subnet_1" {
  vpc_id            = aws_vpc.aws_my_vpc.id
  cidr_block        = var.aws_public_subnet_cidr_1
  availability_zone = var.aws_az_1

  tags = {
    Name = "${var.name}_public_subnet_1"
  }
}

resource "aws_subnet" "aws_public_subnet_2" {
  vpc_id            = aws_vpc.aws_my_vpc.id
  cidr_block        = var.aws_public_subnet_cidr_2
  availability_zone = var.aws_az_2

  tags = {
    Name = "${var.name}_public_subnet_2"
  }
}

# ── Internet Gateway ─────────────────────────────────────────────────────────

resource "aws_internet_gateway" "aws_ig" {
  vpc_id = aws_vpc.aws_my_vpc.id

  tags = {
    Name = "${var.name}_ig"
  }
}

# ── Route table (public subnets → Internet Gateway) ──────────────────────────

resource "aws_route_table" "aws_pub_rt" {
  vpc_id = aws_vpc.aws_my_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.aws_ig.id
  }

  tags = {
    Name = "${var.name}_pub_rt"
  }
}

resource "aws_route_table_association" "aws_pub_sub_assoc_1" {
  subnet_id      = aws_subnet.aws_public_subnet_1.id
  route_table_id = aws_route_table.aws_pub_rt.id
}

resource "aws_route_table_association" "aws_pub_sub_assoc_2" {
  subnet_id      = aws_subnet.aws_public_subnet_2.id
  route_table_id = aws_route_table.aws_pub_rt.id
}

# ── Private subnets (no direct internet access) ──────────────────────────────

resource "aws_subnet" "aws_private_subnet_1" {
  vpc_id            = aws_vpc.aws_my_vpc.id
  cidr_block        = var.aws_private_subnet_cidr_1
  availability_zone = var.aws_az_1

  tags = {
    Name = "${var.name}_private_subnet_1"
  }
}

resource "aws_subnet" "aws_private_subnet_2" {
  vpc_id            = aws_vpc.aws_my_vpc.id
  cidr_block        = var.aws_private_subnet_2
  availability_zone = var.aws_az_2

  tags = {
    Name = "${var.name}_private_subnet_2"
  }
}

# ── Application Load Balancer ────────────────────────────────────────────────

resource "aws_lb" "aws_alb" {
  name               = "alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.aws_lb_sg.id]
  subnets = [
    aws_subnet.aws_public_subnet_1.id,
    aws_subnet.aws_public_subnet_2.id
  ]

  tags = {
    Environment = "production"
  }
}

resource "aws_lb_target_group" "aws_app_tg" {
  name     = "AppTargetGroup"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.aws_my_vpc.id
}

resource "aws_lb_listener" "aws_lb_listener" {
  load_balancer_arn = aws_lb.aws_alb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.aws_app_tg.arn
  }
}

# ── Security groups ──────────────────────────────────────────────────────────

resource "aws_security_group" "aws_bastion_sg" {
  name        = "BastionHostSG"
  description = "Allow SSH inbound"
  vpc_id      = aws_vpc.aws_my_vpc.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "aws_lb_sg" {
  name        = "LoadBalancerSG"
  description = "Allow HTTP inbound"
  vpc_id      = aws_vpc.aws_my_vpc.id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# ── EC2 application server (private subnet) ──────────────────────────────────

resource "aws_instance" "app-server" {
  ami           = "ami-0b9ecff325b5aa3d4"
  instance_type = "t3.micro"
  subnet_id     = aws_subnet.aws_private_subnet_1.id

  vpc_security_group_ids = [
    aws_security_group.aws_bastion_sg.id,
    aws_security_group.aws_lb_sg.id
  ]

  tags = {
    Name = "AppServerInstance"
  }
}
