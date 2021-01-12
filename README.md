This terraform exercise was assigned to Suzette Williams by Keet Health 
to fulfill the requirements of the "Site Reliability Engineer" interview process

Keet Health | Terraform Exercise
===

Please reproduce the following:

- Write a module in terraform, that will

    - use the AWS provider
    - provision an EC2 instance
    - install Docker
    - run the nginx Docker image
    - output the internal IP

- Then use that module in another terraform script

- Create a readme file

- In the readme file, comment on if you were to iterate on this, what would you add? Why? 

- Save to a github repo and send the link to the code for review

Response
===
I have used terraform as an Infrastructure as code (IaC) tool to provision my infrasctructure on AWS. Provisioned infrastructure inlude:
1. VPC resources: Internet Gateway, Custom Route Table, Subnet, Security Groups, Network interface with an assigned elastic IP
2. An Ubuntu server with Docker installed
3. A Docker container with nginx container hosted by the ubuntu server

Steps taken:
1. Define Provider


