#!/bin/bash
## Pre-reqs
# - Ansible > 2.0
# - Botocore
# - Boto3
# - python 2. 7

# Get path of ansible-playbook



ansible_code_dir="../../../ansible/"

# For Dynamic inventory
export AWS_REGION=eu-west-1
echo $AWS_REGION
# **** Only for localhost***
# **** ALL VM level configuration is done via ansible pull *****#

ansible-playbook -i $ansible_code_dir/hosts/ec2.py $ansible_code_dir/kafka-ecs-create.yml --extra-vars \
"env=development
region=eu-west-1
log_group_name=/aws/ecs/development
repository_credentials_arn=arn:aws:secretsmanager:eu-west-1:445635878120:secret:jfrog-container-registry-GPxfJk
ecs_role_arn=arn:aws:iam::445635878120:role/ecsTaskExecutionRole
kafka_sg_id=sg-09805348000013bbc
private_subnet_0=subnet-03517fa49d9c62bc1
private_subnet_1=subnet-00b92bd4da32652df
private_subnet_2=subnet-0fbdad730c927946a
kafka_internal_elb_dns=internal-KAFKA-INTERNAL-development-83589529.eu-west-1.elb.amazonaws.com
CHANGELOG_REPLICATION_FACTOR=3
kafka_port=29092
kafka_port_1=9020
zookeeper_port=2181
zookeeper_port_1=8181
zookeeper_port_2=2888
zookeeper_port_3=3888
kafka_target_group_arn=arn:aws:elasticloadbalancing:eu-west-1:445635878120:targetgroup/dev-kafka/f2cd0c39f36f5f30
kafka_target_group_arn_1=arn:aws:elasticloadbalancing:eu-west-1:445635878120:targetgroup/dev-kafka-1/e3495df77c21186f
zookeeper_target_group_arn=arn:aws:elasticloadbalancing:eu-west-1:445635878120:targetgroup/dev-zookeeper/85b9d0b99109cb33
zookeeper_target_group_arn_1=arn:aws:elasticloadbalancing:eu-west-1:445635878120:targetgroup/dev-zookeeper-1/17451f26e820684b
zookeeper_target_group_arn_2=arn:aws:elasticloadbalancing:eu-west-1:445635878120:targetgroup/dev-zookeeper-2/d266b511cfdcdba4
zookeeper_target_group_arn_3=arn:aws:elasticloadbalancing:eu-west-1:445635878120:targetgroup/dev-zookeeper-3/e88bbb6f0012d4b9
"

