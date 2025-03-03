provider "aws" {

    region = "us-east-1"

}

resource "aws_instance" "JenkinsServer" {

    ami                 = "ami-04b4f1a9cf54c11d0"
    instance_type       = "t2.medium"
    key_name            = "keypair2025"
    user_data           = file("scripts/controller.sh") 

    tags = {
        Name = "jenkins_server"
        ansibleHost = "controller"
    }
  
}

resource "aws_instance" "Webserver" {

    ami                 = "ami-04b4f1a9cf54c11d0"
    instance_type       = "t2.micro"
    key_name            = "keypair2025"
    user_data           = file("scripts/node1.sh") 

    tags = {
        Name = "nginx_server"
        ansibleHost = "node01"
    }
  
}

resource "aws_instance" "tomcat" {

    ami                 = "ami-04b4f1a9cf54c11d0"
    instance_type       = "t2.micro"
    key_name            = "keypair2025"
    user_data           = file("scripts/node2.sh") 

    tags = {
        Name = "tomcat_server"
        ansibleHost = "node02"
    }
  
}

resource "aws_instance" "mongodb" {

    ami                 = "ami-04b4f1a9cf54c11d0"
    instance_type       = "t2.micro"
    key_name            = "keypair2025"
    user_data           = file("scripts/node3.sh") 

    tags = {
        Name = "mongod_server"
        ansibleHost = "node03"
    }
  
}

