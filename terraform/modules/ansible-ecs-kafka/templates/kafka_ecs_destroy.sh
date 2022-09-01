#!/bin/bash
## Pre-reqs
# - Ansible > 2.0
# - Botocore
# - Boto3
# - python 2. 7

# Get path of ansible-playbook



ansible_code_dir="../../../ansible/"

# For Dynamic inventory
export AWS_REGION=${region}
echo $AWS_REGION
# **** Only for localhost***
# **** ALL VM level configuration is done via ansible pull *****#

ansible-playbook -i $ansible_code_dir/hosts/ec2.py $ansible_code_dir/kafka-ecs-delete.yml --extra-vars \
"env=${env}
region=${region}
log_group_name=${log_group_name}
repository_credentials_arn=${repository_credentials_arn}
ecs_role_arn=${ecs_role_arn}
kafka_sg_id=${kafka_sg_id}
private_subnet_0=${private_subnet_0}
private_subnet_1=${private_subnet_1}
private_subnet_2=${private_subnet_2}
kafka_internal_elb_dns=${kafka_internal_elb_dns}
CHANGELOG_REPLICATION_FACTOR=${CHANGELOG_REPLICATION_FACTOR}
kafka_port=${kafka_port}
kafka_port_1=${kafka_port_1}
zookeeper_port=${zookeeper_port}
zookeeper_port_1=${zookeeper_port_1}
zookeeper_port_2=${zookeeper_port_2}
zookeeper_port_3=${zookeeper_port_3}
kafka_target_group_arn=${kafka_target_group_arn}
kafka_target_group_arn_1=${kafka_target_group_arn_1}
zookeeper_target_group_arn=${zookeeper_target_group_arn}
zookeeper_target_group_arn_1=${zookeeper_target_group_arn_1}
zookeeper_target_group_arn_2=${zookeeper_target_group_arn_2}
zookeeper_target_group_arn_3=${zookeeper_target_group_arn_3}
"
