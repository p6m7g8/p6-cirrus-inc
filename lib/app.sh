######################################################################
#<
#
# Function:
#      = p6_cirrus_inc_instance_create(name, ami_id, instance_type, user_data, subnet_type)
#
# Arg(s):
#    name - 
#    ami_id - 
#    instance_type - 
#    user_data - 
#    subnet_type - 
#
#
#>
######################################################################
p6_cirrus_inc_instance_create() {
    local name="$1"
    local ami_id="$2"
    local instance_type="${3:-t3a.nano}"
    local user_data="${4:-}"
    local subnet_type="${5:-infra}"

    [ -z "$ami_id" ]    && ami_id=$(p6_cirrus_inc_amis_freebsd12_latest)
    [ -n "$user_data" ] && user_data="--user-data=$user_data"

    local key_name=$(p6_cirrus_inc_key_pair_make "$USER")

    local sg_id
    local subnet_id
    case $name in
	bastion)
	    sg_id=$(p6_cirrus_inc_sg_id_from_group_name "bastion-ssh")
	    subnet_id=$(p6_cirrus_inc_subnet_bastion_get)
	    ;;
	*)
	    sg_id=$(p6_cirrus_inc_sg_id_from_group_name "vpc-ssh")
	    subnet_id=$(p6_cirrus_inc_subnet_${subnet_type}_get)
	    ;;
    esac

    local sg_outbound_id=$(p6_cirrus_inc_sg_id_from_group_name "outbound")

    p6_aws_ec2_instances_run \
	--output json \
	--key-name $key_name \
	--image-id $ami_id \
	--instance-type $instance_type \
	--security-group-ids $sg_id $sg_outbound_id \
	--subnet-id $subnet_id \
	$user_data \
	--tag-specifications "'ResourceType=instance,Tags=[{Key=Name,Value=$name}]'"
}

######################################################################
#<
#
# Function:
#      = p6_cirrus_inc_instance_ubuntu18_create()
#
#
#
#>
######################################################################
p6_cirrus_inc_instance_ubuntu18_create() {

    p6_cirrus_inc_instance_create "ubuntu18"
}

######################################################################
#<
#
# Function:
#      = p6_cirrus_inc_instance_rhel8_create()
#
#
#
#>
######################################################################
p6_cirrus_inc_instance_rhel8_create() {

    p6_cirrus_inc_instance_create "rhel-8"
}

######################################################################
#<
#
# Function:
#      = p6_cirrus_inc_instance_amazon_create()
#
#
#
#>
######################################################################
p6_cirrus_inc_instance_amazon_create() {

    p6_cirrus_inc_instance_create "amazon2"
}

######################################################################
#<
#
# Function:
#      = p6_cirrus_inc_cleanup()
#
#
#
#>
######################################################################
p6_cirrus_inc_cleanup() {

    true
    ## terminate instances
    ## delete sgs
}

######################################################################
#<
#
# Function:
#     str = p6_cirrus_inc_sg_bastion_ssh_create(vpc_id)
#
# Arg(s):
#    vpc_id - 
#
# Return(s):
#     - 
#
#>
######################################################################
p6_cirrus_inc_sg_bastion_ssh_create() {
    local vpc_id=${1:-$AWS_VPC}

    local sg_bastion_ssh_id=$(p6_aws_ec2_security_group_create "'Allows SSH TPC(22) Inbound From Anywhere'" "bastion-ssh" --vpc-id $vpc_id --output text)

    p6_aws_ec2_tags_create "$sg_bastion_ssh_id" "Key=Name,Value=bastion-ssh"

    p6_return $sg_bastion_ssh_id
}

######################################################################
#<
#
# Function:
#     str = p6_cirrus_inc_sg_instance_ssh_create(vpc_id)
#
# Arg(s):
#    vpc_id - 
#
# Return(s):
#     - 
#
#>
######################################################################
p6_cirrus_inc_sg_instance_ssh_create() {
    local vpc_id=${1:-$AWS_VPC}

    local sg_instance_ssh_id=$(p6_aws_ec2_security_group_create "'Allows SSH TPC(22) Inbound From Bastion Only'" "vpc-ssh" --vpc-id $vpc_id --output text)

    p6_aws_ec2_tags_create "$sg_instance_ssh_id" "Key=Name,Value=vpc-ssh"

    p6_return $sg_instance_ssh_id
}

######################################################################
#<
#
# Function:
#     str = p6_cirrus_inc_sg_outbound_ssh_create(vpc_id)
#
# Arg(s):
#    vpc_id - 
#
# Return(s):
#     - 
#
#>
######################################################################
p6_cirrus_inc_sg_outbound_ssh_create() {
    local vpc_id=${1:-$AWS_VPC}

    local sg_outbound_id=$(p6_aws_ec2_security_group_create "'Allows All TCP Outbound to ALL'" "outbound" --vpc-id $vpc_id --output text)

    p6_aws_ec2_tags_create "$sg_outbound" "Key=Name,Value=outbound"

    p6_return $sg_outbound_id
}

######################################################################
#<
#
# Function:
#      = p6_cirrus_inc_sg_link_outbound_world_world()
#
#
#
#>
######################################################################
p6_cirrus_inc_sg_link_outbound_world_world() {

    local sg_outbound_id=$(p6_cirrus_inc_sg_id_from_group_name "outbound")

    p6_aws_ec2_security_group_egress_authorize $sg_outbound_id --protocol tcp --port 0 --cidr 0.0.0.0/0
}

######################################################################
#<
#
# Function:
#      = p6_cirrus_inc_sg_link_bastion_world_ssh()
#
#
#
#>
######################################################################
p6_cirrus_inc_sg_link_bastion_world_ssh() {

    local sg_bastion_ssh_id=$(p6_cirrus_inc_sg_id_from_group_name "bastion-ssh")
    p6_aws_ec2_security_group_ingress_authorize --group-id $sg_bastion_ssh_id --protocol tcp --port 22 --cidr 0.0.0.0/0
}

## Links: a_b_proto
######################################################################
#<
#
# Function:
#      = p6_cirrus_inc_sg_link_bastion_vpc_ssh()
#
#
#
#>
######################################################################
p6_cirrus_inc_sg_link_bastion_vpc_ssh() {

    local sg_bastion_ssh_id=$(p6_cirrus_inc_sg_id_from_group_name "bastion-ssh")
    local sg_instance_ssh_id=$(p6_cirrus_inc_sg_id_from_group_name "vpc-ssh")

    # bastion->vpc
    p6_aws_ec2_security_group_egress_authorize $sg_instance_ssh_id --protocol tcp --port 22 --source-group $sg_bastion_ssh_id

    # bastion<-vpc
    p6_aws_ec2_security_group_ingress_authorize --group-id $sg_bastion_ssh_id --protocol tcp --port 22 --source-group $sg_instance_ssh_id

    # vpc->bastion
    p6_aws_ec2_security_group_egress_authorize $sg_bastion_ssh_id --protocol tcp --port 22 --source-group $sg_instance_ssh_id
}

######################################################################
#<
#
# Function:
#      = p6_cirrus_inc_instance_bastion_create()
#
#
#
#>
######################################################################
p6_cirrus_inc_instance_bastion_create() {

    p6_cirrus_inc_instance_create "bastion"
}

######################################################################
#<
#
# Function:
#      = p6_cirrus_inc_instance_irc_create()
#
#
#
#>
######################################################################
p6_cirrus_inc_instance_irc_create() {

    local ami_id=$(p6_cirrus_inc_amis_freebsd12_latest)
    p6_cirrus_inc_instance_create "irc" "$ami_id" "t2.micro"
}

######################################################################
#<
#
# Function:
#      = p6_cirrus_inc_instance_jenkins_create()
#
#
#
#>
######################################################################
p6_cirrus_inc_instance_jenkins_create() {

    local ami_id=$(p6_cirrus_inc_amis_freebsd12_latest)
    p6_cirrus_inc_instance_create "jenkins" "$ami_id" "m4.large"
}