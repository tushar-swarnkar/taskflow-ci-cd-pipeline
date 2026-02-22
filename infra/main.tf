resource "aws_key_pair" "taskflow_key" {
  public_key = file("taskflow-key.pub")
  key_name   = "${var.app_name}-key"
}

resource "aws_vpc" "taskflow_vpc" {
  cidr_block = "10.0.0.0/16"
  tags = {
    Name = "${var.app_name}-vpc"
  }
}

resource "aws_subnet" "taskflow_subnet" {
  vpc_id                  = aws_vpc.taskflow_vpc.id
  cidr_block              = "10.0.1.0/24"
  availability_zone       = var.az
  map_public_ip_on_launch = true

  depends_on = [aws_vpc.taskflow_vpc]

  tags = {
    Name = "${var.app_name}-public-subnet"
  }
}

resource "aws_internet_gateway" "taskflow_ig" {
  vpc_id = aws_vpc.taskflow_vpc.id
  tags = {
    Name = "${var.app_name}-igw"
  }
}

resource "aws_route_table" "taskflow_rt" {
  vpc_id = aws_vpc.taskflow_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.taskflow_ig.id
  }

  tags = {
    Name = "${var.app_name}-public-rt"
  }
}

resource "aws_route_table_association" "taskflow_rt_association" {
  subnet_id      = aws_subnet.taskflow_subnet.id
  route_table_id = aws_route_table.taskflow_rt.id
}

resource "aws_security_group" "taskflow_sg" {
  name   = "${var.app_name}-sg"
  vpc_id = aws_vpc.taskflow_vpc.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "ssh open"
  }
  ingress {
    from_port   = 9000
    to_port     = 9000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "http open"
  }
  ingress {
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "jenkins"
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.app_name}-sg"
  }
}

resource "aws_instance" "taskflow_ec2" {
  depends_on = [
    aws_key_pair.taskflow_key,
    aws_vpc.taskflow_vpc,
    aws_subnet.taskflow_subnet,
    aws_security_group.taskflow_sg,
  ]

  key_name      = aws_key_pair.taskflow_key.key_name
  instance_type = var.ec2_instance_type
  ami           = var.ec2_ami_id

  vpc_security_group_ids = [aws_security_group.taskflow_sg.id]
  availability_zone      = var.az
  subnet_id              = aws_subnet.taskflow_subnet.id

  user_data = file("${path.module}/installations.sh")

  tags = {
    Name = "${var.app_name}-ec2"
  }
}
