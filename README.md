### HA Kafka cluster on ECS
---  


###### -- Kafka cluster which includes HA zookeeper
###### --  processing nodes
###### -- EFS volumes mounted and used by both Kafka & Zookeeper
###### -- Scalable - Easy horizontal scaling for Kafka nodes


#### This repository
- Terraform modules and code to deploy a highly available Kafka cluster in ECS
- Terraform modules and code to deploy a highly available Services cluster in ECS
- Ansible Integration to demonstrate concepts for deploying services info processing services
- A python utility that manages deployement on ECS rather than relying on Ansible's ECS module.
- Also demonstrate deploy and destroy time provisioners in Terraform
- Orchestration of ECS tasks using ansible where statefulsets are not available. 
- Demonstrate use of Cloudwatch-logs. A log group and stream is setup for log forwarding and aws logging driver is used.
- Demonstrate cloud-init with Terraform
- Deployment of EFS for Kafka/Zookeeper




#### Pre-requisites
- AWS account.
- Terraform > 0.9.5
- Ansible >= 2.3
- Python 2.7
- Boto, Botocore



### Deployment
---
#### What is deployed?
1. VPC - Three private subnets and three public subnets
2. One ECS Cluster for Kafka
3. One ECS Cluster for Services
4. A bastion node.
5. AWS Log group and log stream
6. EFS Volumes of 30G attached to each Kafka node using cloud-init
7. Route53 for private hosted zone
8. Load balancers and target groups for services

#### Deployment procedure
1. Ensure pre-requisites are met
2. Decide a region where this needs to be deployed
3. This guides a cluster in a region with 3 AZs. You can reduce the number in terraform.tfvars file
4. Create a key pair in AWS 
5. Install AWS CLI tools and create a credentials file with a subsection according to the instructions : https://docs.aws.amazon.com/cli/latest/userguide/cli-config-files.html

#### Plan and setup
```shell
AWS_PROFILE=xxx terraform plan
# If successful then
AWS_PROFILE=xxx terraform apply
## Terraform will generate a plan that is (hopefully) identical to the planning phase. If it looks good, type yes to apply.
```

### Updates

#### Adding a new service
To add a new service, the new service must first be added to the following three files. Add corresponding sections of your new service following the format used by previous services.
```
ansible/site-ecs-create.yml
ansible/site-ecs-delete.yml
ansible/site-ecs-update.yml
```
Similarly, add a new service file in the format `ansible/playbooks/new-service.yml`. Previous service files are a good starting template for this.

Next, add a role for your new service in the `ansible/playbooks/roles` folder. A good way to do this is to copy the folder from a similar service in the `roles` directory and change the appropriate values. Selecting a folder from a similar service is especially important when it comes to duplicating inbound traffic. If your new service requires inbound traffic, use a folder another that does as well, preferably one that performs the same types of tasks as your new service. This will be a pattern when creating additional components below.

Cheat sheet for creating a new folder in the `ansible/playbooks/roles` directory:
```
1. Copy the folder from a similar service.
2. Change the names and environment variables in `ansible/playbooks/roles/new-service/defaults/client.yml`
3. Substitute the copied service name for your new service in `ansible/playbooks/roles/new-service/tasks/main.yml`
4. Change the following file name in the role to `ansible/playbooks/roles/new-service/templates/new-service.yml`
```

##### If your service requires inbound traffic
If your service requires inbound traffic, we must make changes in several locations to provide the proper infrastructure. Follow previously established conventions for all steps in this section.

First, add a data source port in `terraform/environments/your-environment/terraform.tfvars`.

Next, add a port variable in `terraform/environments/your-environment/variables.tf`.


###### This adds load balancing infrastructure

Add a port variable in the `ecs-site-cluster` module of `terraform/environments/your-environment/main.tf`.

Next, add another port variable in `terraform/modules/ecs-site-cluster/variables.tf`.

Add a new ALB target group and listener to the `terraform/modules/ecs-site-cluster/variables.tf` file.

Add the target group arn as an output in `terraform/modules/ecs-site-cluster/outputs.tf`.

###### This adds connectivity between the ECS containers and load balancing infrastructure

Add a port variable in the `ansible-ecs-site` module of `terraform/environments/your-environment/main.tf`.

Next, add another port variable in `terraform/modules/ansible-ecs-site/variable.tf`.

Add this same port variable to the `ansible_ecs_deploy`, ansible_ecs_update`, and `ansible_ecs_destroy` modules of `terraform/modules/ansible-ecs-site/main.tf`.

Add this same port variable to the `ansible_ecs_deploy.sh`, ansible_ecs_update.sh`, and `ansible_ecs_destroy.sh` files in the `terraform/modules/ansible-ecs-site/templates` folder.

#####

To finish adding your new service, simply run terraform in the manner detailed above.

#### Common Issues

If your new service is not functioning correctly, the fist place to look is in the ECS console. Make sure the newest container definition is running for your task. If the newest container definition is used, check the ECS logs to see if it may be stopping and starting. For further information, you can check the container logs in cloudwatch for any application-related problems.

Sometimes services just need to be restarted when there are issues. When this is necessary, get into the ECS console and find the running task inside your service definition. Stop the task - make sure you do not stop the service.

When kafka issues arise such as loss of sync, perform the same procedure used with services. Get into the ECS console and find the running task inside the problematic kafka service definition. Stop the task - make sure you do not stop the service.

##### Note
- Cost: This is beyond the scope of Free-tier.
- Environment: The environment keyword is used to pickup a defined ansible role. If you change or add new environments, ensure that corresponding Yaml file exists in Ansible role
- Private hosted zone takes the form of 
```shell
kafka.{{environment}-internal.com
```
For information on Ecs utility : https://github.com/faizan82/ecs-orchestrate
