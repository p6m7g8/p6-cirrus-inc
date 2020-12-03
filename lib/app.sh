######################################################################
#<
#
# Function: p6_cirrus_inc_instance_create(name, ami_id, [instance_type=t3a.nano], [user_data=], [subnet_type=infra])
#
#  Args:
#	name -
#	ami_id -
#	OPTIONAL instance_type - [t3a.nano]
#	OPTIONAL user_data - []
#	OPTIONAL subnet_type - [infra]
#
#>
######################################################################
p6_cirrus_inc_instance_create() {
    local name="$1"
    local ami_id="$2"
    local instance_type="${3:-t3a.nano}"
    local user_data="${4:-}"
    local subnet_type="${5:-infra}"

    [ -z "$ami_id" ] && ami_id=$(p6_cirrus_inc_amis_freebsd12_latest)
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
# Function: p6_cirrius_inc_sg_myself_allow(sg_name, [port=443])
#
#  Args:
#	sg_name -
#	OPTIONAL port - [443]
#
#>
######################################################################
p6_cirrius_inc_sg_myself_allow() {
    local sg_name="$1"
    local port="${2:-443}"

    local myip=$(dig +short myip.opendns.com @resolver1.opendns.com)

    local sg_id=$(p6_cirrus_inc_sg_id_from_group_name "$sg_name")
    p6_aws_ec2_security_group_ingress_authorize --group-id $sg_id --protocol tcp --port $port --cidr $myip/32
}

######################################################################
#<
#
# Function: p6_cirrus_inc_instance_ubuntu18_create()
#
#>
######################################################################
p6_cirrus_inc_instance_ubuntu18_create() {

    p6_cirrus_inc_instance_create "ubuntu18"
}

######################################################################
#<
#
# Function: p6_cirrus_inc_instance_rhel8_create()
#
#>
######################################################################
p6_cirrus_inc_instance_rhel8_create() {

    p6_cirrus_inc_instance_create "rhel-8"
}

######################################################################
#<
#
# Function: p6_cirrus_inc_instance_amazon_create()
#
#>
######################################################################
p6_cirrus_inc_instance_amazon_create() {

    p6_cirrus_inc_instance_create "amazon2"
}

######################################################################
#<
#
# Function: p6_cirrus_inc_cleanup()
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
# Function: str sg_bastion_ssh_id = p6_cirrus_inc_sg_bastion_ssh_create([vpc_id=$AWS_VPC])
#
#  Args:
#	OPTIONAL vpc_id - [$AWS_VPC]
#
#  Returns:
#	str - sg_bastion_ssh_id
#
#>
######################################################################
p6_cirrus_inc_sg_bastion_ssh_create() {
    local vpc_id=${1:-$AWS_VPC}

    local sg_bastion_ssh_id=$(p6_aws_ec2_security_group_create "'Allows SSH TPC(22) Inbound From Anywhere'" "bastion-ssh" --vpc-id $vpc_id --output text)

    p6_aws_ec2_tags_create "$sg_bastion_ssh_id" "Key=Name,Value=bastion-ssh"

    p6_return_str "$sg_bastion_ssh_id"
}

######################################################################
#<
#
# Function: str sg_instance_ssh_id = p6_cirrus_inc_sg_instance_ssh_create([vpc_id=$AWS_VPC])
#
#  Args:
#	OPTIONAL vpc_id - [$AWS_VPC]
#
#  Returns:
#	str - sg_instance_ssh_id
#
#>
######################################################################
p6_cirrus_inc_sg_instance_ssh_create() {
    local vpc_id=${1:-$AWS_VPC}

    local sg_instance_ssh_id=$(p6_aws_ec2_security_group_create "'Allows SSH TPC(22) Inbound From Bastion Only'" "vpc-ssh" --vpc-id $vpc_id --output text)

    p6_aws_ec2_tags_create "$sg_instance_ssh_id" "Key=Name,Value=vpc-ssh"

    p6_return_str "$sg_instance_ssh_id"
}

######################################################################
#<
#
# Function: str sg_outbound_id = p6_cirrus_inc_sg_outbound_ssh_create([vpc_id=$AWS_VPC])
#
#  Args:
#	OPTIONAL vpc_id - [$AWS_VPC]
#
#  Returns:
#	str - sg_outbound_id
#
#>
######################################################################
p6_cirrus_inc_sg_outbound_ssh_create() {
    local vpc_id=${1:-$AWS_VPC}

    local sg_outbound_id=$(p6_aws_ec2_security_group_create "'Allows All TCP Outbound to ALL'" "outbound" --vpc-id $vpc_id --output text)

    p6_aws_ec2_tags_create "$sg_outbound" "Key=Name,Value=outbound"

    p6_return_str "$sg_outbound_id"
}

######################################################################
#<
#
# Function: p6_cirrus_inc_sg_link_outbound_world_world()
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
# Function: p6_cirrus_inc_sg_link_bastion_world_ssh()
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
# Function: p6_cirrus_inc_sg_link_bastion_vpc_ssh()
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
# Function: p6_cirrus_inc_instance_bastion_create()
#
#>
######################################################################
p6_cirrus_inc_instance_bastion_create() {

    p6_cirrus_inc_instance_create "bastion"
}

######################################################################
#<
#
# Function: p6_cirrus_inc_instance_irc_create()
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
# Function: p6_cirrus_inc_instance_jenkins_create()
#
#>
######################################################################
p6_cirrus_inc_instance_jenkins_create() {

    local ami_id=$(p6_cirrus_inc_amis_freebsd12_latest)
    p6_cirrus_inc_instance_create "jenkins" "$ami_id" "m4.large"
}

######################################################################
#<
#
# Function: str key_id = p6_aws_kms_svc_key_make(account_id, key_description, key_alias)
#
#  Args:
#	account_id -
#	key_description -
#	key_alias -
#
#  Returns:
#	str - key_id
#
#>
######################################################################
p6_aws_kms_svc_key_make() {
    local account_id="$1"
    local key_description="$2"
    local key_alias="$3"

    local key_admin_principals="arn:aws:iam::${account_id}:role/SSO/SSO_Admin"
    local key_user_principals="arn:aws:iam::${account_id}:role/SSO/SSO_Admin"

    local key_policy=$(p6_aws_util_template_process "iam/kms" "ACCOUNT_ID=$account_id" "KEY_ADMIN_PRINCIPALS=$key_admin_principals" "KEY_USER_PRINCIPALS=$key_user_principals")

    local key_id=$(p6_aws_cmd kms create-key "$key_description" "$key_policy")
    p6_aws_cmd kms alias-key "$key_alias" "$key_id"

    p6_return_str "$key_id"
}