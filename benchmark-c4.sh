#!/bin/bash -x

INSTANCE_TYPE_SERVER=m5.24xlarge

# $1 = client instance type
function create {
  aws cloudformation create-stack --stack-name ec2-network-benchmark-${1//./-} --parameters ParameterKey=ParentVPCStack,ParameterValue=ec2-network-benchmark-vpc ParameterKey=ParentGlobalStack,ParameterValue=ec2-network-benchmark-global ParameterKey=InstanceTypeClient,ParameterValue=$1 ParameterKey=InstanceTypeServer,ParameterValue=$INSTANCE_TYPE_SERVER --template-body file://benchmark.yaml
}

# $1 = client instance type
function wait_create_complete {
  aws cloudformation wait stack-create-complete --stack-name ec2-network-benchmark-${1//./-}
}

# $1 = client instance type
function delete {
  aws cloudformation delete-stack --stack-name ec2-network-benchmark-${1//./-} 
}

# $1 = client instance type
function wait_delete_complete {
  aws cloudformation wait stack-delete-complete --stack-name ec2-network-benchmark-${1//./-}
}

create c4.large
create c4.xlarge
create c4.2xlarge
create c4.4xlarge
create c4.8xlarge

wait_create_complete c4.large
wait_create_complete c4.xlarge
wait_create_complete c4.2xlarge
wait_create_complete c4.4xlarge
wait_create_complete c4.8xlarge

delete c4.large
delete c4.xlarge
delete c4.2xlarge
delete c4.4xlarge
delete c4.8xlarge

wait_delete_complete c4.large
wait_delete_complete c4.xlarge
wait_delete_complete c4.2xlarge
wait_delete_complete c4.4xlarge
wait_delete_complete c4.8xlarge

