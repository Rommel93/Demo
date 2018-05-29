provider "aws" {}

#Dev Server
resource "aws_instance" "Dev" {
        ami = "ami-6871a115"
        instance_type = "t2.micro"
        	key_name			= "Linux"

#Installing httpd
user_data = <<-EOF
                #!/bin/bash
                sudo yum install -y httpd
                sudo service httpd restart
                sudo touch /var/www/html/index.html
                sudo chmod 766 /var/www/html/index.html

                sudo echo '
                <html>
                <head>
                <title>Welcome to Export Program!</title>
                </head>
                <body>
                <h1>Success! The apache is working on '$HOSTNAME '</h1>
                </body>
                </html>
                ' > /var/www/html/index.html
            EOF


 tags {
		Name = "Dev"
 }
}
#Testing server
resource "aws_instance" "testing" {
        ami = "ami-6871a115"
        instance_type = "t2.micro"
        	key_name			= "Linux"


#Installing httpd
user_data = <<-EOF
                #!/bin/bash
                sudo yum install -y httpd
                  sudo service httpd restart
                sudo touch /var/www/html/index.html
                sudo chmod 766 /var/www/html/index.html

                sudo echo '
                <html>
                <head>
                <title>Welcome to Export Program!</title>
                </head>
                <body>
                <h1>Success! The apache is working on '$HOSTNAME '</h1>
                </body>
                </html>
                ' > /var/www/html/index.html
            EOF


 tags {
		Name = "Testing"
 }
}
#Prod server
resource "aws_instance" "prod" {
        ami = "ami-6871a115"
        instance_type = "t2.micro"
        key_name			= "Linux"

#Installing httpd
user_data = <<-EOF
                #!/bin/bash
                sudo yum install -y httpd
                  sudo service httpd restart
                sudo touch /var/www/html/index.html
                sudo chmod 766 /var/www/html/index.html

                sudo echo '
                <html>
                <head>
                <title>Welcome to Export Program!</title>
                </head>
                <body>
                <h1>Success! The apache is working on '$HOSTNAME '</h1>
                </body>
                </html>
                ' > /var/www/html/index.html
            EOF



 tags {
		Name = "Prod"
 }
}

#Launch Configuration
resource "aws_launch_configuration" "web_launch_conf" {
	name          = "web_config"
  image_id      = "ami-6871a115"
  instance_type = "t2.micro"
	key_name			= "Linux"

	user_data = <<-EOF
									#!/bin/bash
                  sudo yum install -y httpd
									sudo touch /var/www/html/index.html
									sudo chmod 766 /var/www/html/index.html

									sudo echo '
									<html>
									<head>
									<title>Welcome to Export Program!</title>
									</head>
									<body>
									<h1>Success! The apache is working on '$HOSTNAME '</h1>
									</body>
									</html>
									' > /var/www/html/index.html
							EOF



	}

#Auto Scaling Group
	resource "aws_autoscaling_group" "webserver_asg" {
  name                 = "terraform-asg-example"
	max_size                  = 2
	min_size                  = 0
	health_check_grace_period = 300
	health_check_type         = "EC2"
	desired_capacity          = 0
  launch_configuration      = "${aws_launch_configuration.web_launch_conf.name}"
	load_balancers						= ["${aws_elb.webserver.name}"]
	availability_zones				= ["us-east-1a"]


}

#Load Balancer
resource "aws_elb" "webserver" {
	name               	= "ELBexport"
  security_groups 		= ["${aws_security_group.webserver_group.id}"]
	availability_zones				= ["us-east-1a"]

	listener {
    instance_port     = "80"
    instance_protocol = "HTTP"
    lb_port           = "80"
    lb_protocol       = "HTTP"
  }

  health_check {
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 3
    target              = "HTTP:80/"
    interval            = 30
  }

  instances                   = ["${aws_instance.prod.id}","${aws_instance.Dev.id}","${aws_instance.testing.id}"]

 tags {
		Name = "Elb-Export"
	}

}

#Security Groups
#Webserver Security Group
resource "aws_security_group" "webserver_group" {

name        = "webserversg"
description = "Allow Ports 80 and 22"

ingress {
		 from_port = 80
		 to_port = 80
		 protocol = "tcp"
		 cidr_blocks = ["0.0.0.0/0"]
}

ingress {
		 from_port = 22
		 to_port = 22
		 protocol = "tcp"
		 cidr_blocks = ["0.0.0.0/0"]
}

tags {
		Name = "WebserverSG-Export"
	}
}

#App Server Security Group
resource "aws_security_group" "appserver_group" {

name        = "appserversg"
description = "Allow Ports 9043 and 22"


ingress {
		 from_port = 9043
		 to_port = 9043
		 protocol = "tcp"
		 cidr_blocks = ["0.0.0.0/0"]
}

ingress {
		 from_port = 22
		 to_port = 22
		 protocol = "tcp"
		 cidr_blocks = ["0.0.0.0/0"]
}

tags {
		Name = "AppserverSG-Export"
	}
}
