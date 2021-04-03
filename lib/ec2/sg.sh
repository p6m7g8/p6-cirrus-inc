######################################################################
#<
#
# Function: p6_cirrus_sg_myself_allow(sg_name, [port=443])
#
#  Args:
#	sg_name -
#	OPTIONAL port - [443]
#
#  Depends:	 p6_aws
#>
######################################################################
p6_cirrus_sg_myself_allow() {
    local sg_name="$1"
    local port="${2:-443}"

    local myip=$(dig +short myip.opendns.com @resolver1.opendns.com)

    local sg_id=$(p6_cirrus_sg_id_from_group_name "$sg_name")
    p6_aws_ec2_security_group_ingress_authorize --group-id $sg_id --protocol tcp --port $port --cidr $myip/32
}

######################################################################
#<
#
# Function: p6_cirrus_ec2_sg_delete(group_name)
#
#  Args:
#	group_name -
#
#  Depends:	 p6_aws
#>
######################################################################
p6_cirrus_ec2_sg_delete() {
    local group_name="$1"

    local sg_id
    sg_id=$(p6_cirrus_ec2_sg_id_from_group_name "$group_name")

    p6_aws_cli_cmd ec2 delete-security-group --group-id "$sg_id"
}

######################################################################
#<
#
# Function: str sg_id = p6_cirrus_ec2_sg_create(desc, tag_name, [vpc_id=$AWS_VPC_ID])
#
#  Args:
#	desc -
#	tag_name -
#	OPTIONAL vpc_id - [$AWS_VPC_ID]
#
#  Returns:
#	str - sg_id
#
#  Depends:	 p6_aws
#  Environment:	 AWS_VPC_ID
#>
######################################################################
p6_cirrus_ec2_sg_create() {
    local desc="$1"
    local tag_name="$2"
    local vpc_id=${3:-$AWS_VPC_ID}

    local group_name=$tag_name
    local sg_id
    sg_id=$(p6_aws_cli_cmd ec2 create-security-group "'$desc'" "'$group_name'" --vpc-id "$vpc_id" --output text)

    p6_aws_cli_cmd ec2 create-tags "$sg_id" "'Key=Name,Value=$tag_name'"

    p6_return_str "$sg_id"
}

######################################################################
#<
#
# Function: str sg_bastion_ssh_id = p6_cirrus_sg_bastion_ssh_create([vpc_id=$AWS_VPC_ID])
#
#  Args:
#	OPTIONAL vpc_id - [$AWS_VPC_ID]
#
#  Returns:
#	str - sg_bastion_ssh_id
#
#  Depends:	 p6_aws
#  Environment:	 AWS_VPC_ID SSH
#>
######################################################################
p6_cirrus_sg_bastion_ssh_create() {
    local vpc_id=${1:-$AWS_VPC_ID}

    local sg_bastion_ssh_id=$(p6_aws_ec2_security_group_create "'Allows SSH TPC(22) Inbound From Anywhere'" "bastion-ssh" --vpc-id $vpc_id --output text)

    p6_aws_ec2_tags_create "$sg_bastion_ssh_id" "Key=Name,Value=bastion-ssh"

    p6_return_str "$sg_bastion_ssh_id"
}

######################################################################
#<
#
# Function: str sg_instance_ssh_id = p6_cirrus_sg_instance_ssh_create([vpc_id=$AWS_VPC_ID])
#
#  Args:
#	OPTIONAL vpc_id - [$AWS_VPC_ID]
#
#  Returns:
#	str - sg_instance_ssh_id
#
#  Depends:	 p6_aws
#  Environment:	 AWS_VPC_ID SSH
#>
######################################################################
p6_cirrus_sg_instance_ssh_create() {
    local vpc_id=${1:-$AWS_VPC_ID}

    local sg_instance_ssh_id=$(p6_aws_ec2_security_group_create "'Allows SSH TPC(22) Inbound From Bastion Only'" "vpc-ssh" --vpc-id $vpc_id --output text)

    p6_aws_ec2_tags_create "$sg_instance_ssh_id" "Key=Name,Value=vpc-ssh"

    p6_return_str "$sg_instance_ssh_id"
}

######################################################################
#<
#
# Function: str sg_outbound_id = p6_cirrus_sg_outbound_ssh_create([vpc_id=$AWS_VPC_ID])
#
#  Args:
#	OPTIONAL vpc_id - [$AWS_VPC_ID]
#
#  Returns:
#	str - sg_outbound_id
#
#  Depends:	 p6_aws
#  Environment:	 AWS_VPC_ID TCP
#>
######################################################################
p6_cirrus_sg_outbound_ssh_create() {
    local vpc_id=${1:-$AWS_VPC_ID}

    local sg_outbound_id=$(p6_aws_ec2_security_group_create "'Allows All TCP Outbound to ALL'" "outbound" --vpc-id $vpc_id --output text)

    p6_aws_ec2_tags_create "$sg_outbound" "Key=Name,Value=outbound"

    p6_return_str "$sg_outbound_id"
}

######################################################################
#<
#
# Function: p6_cirrus_sg_link_outbound_world_world()
#
#  Depends:	 p6_aws
#>
######################################################################
p6_cirrus_sg_link_outbound_world_world() {

    local sg_outbound_id=$(p6_cirrus_sg_id_from_group_name "outbound")

    p6_aws_ec2_security_group_egress_authorize $sg_outbound_id --protocol tcp --port 0 --cidr 0.0.0.0/0
}

######################################################################
#<
#
# Function: p6_cirrus_sg_link_bastion_world_ssh()
#
#  Depends:	 p6_aws
#>
######################################################################
p6_cirrus_sg_link_bastion_world_ssh() {

    local sg_bastion_ssh_id=$(p6_cirrus_sg_id_from_group_name "bastion-ssh")
    p6_aws_ec2_security_group_ingress_authorize --group-id $sg_bastion_ssh_id --protocol tcp --port 22 --cidr 0.0.0.0/0
}

## Links: a_b_proto
######################################################################
#<
#
# Function: p6_cirrus_sg_link_bastion_vpc_ssh()
#
#  Depends:	 p6_aws
#>
######################################################################
p6_cirrus_sg_link_bastion_vpc_ssh() {

    local sg_bastion_ssh_id=$(p6_cirrus_sg_id_from_group_name "bastion-ssh")
    local sg_instance_ssh_id=$(p6_cirrus_sg_id_from_group_name "vpc-ssh")

    # bastion->vpc
    p6_aws_ec2_security_group_egress_authorize $sg_instance_ssh_id --protocol tcp --port 22 --source-group $sg_bastion_ssh_id

    # bastion<-vpc
    p6_aws_ec2_security_group_ingress_authorize --group-id $sg_bastion_ssh_id --protocol tcp --port 22 --source-group $sg_instance_ssh_id

    # vpc->bastion
    p6_aws_ec2_security_group_egress_authorize $sg_bastion_ssh_id --protocol tcp --port 22 --source-group $sg_instance_ssh_id
}
