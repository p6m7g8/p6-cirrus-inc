######################################################################
#<
#
# Function: p6_cirrus_instance_create(name, ami_id, [instance_type=t3a.nano], [user_data=], [subnet_type=infra])
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
p6_cirrus_instance_create() {
    local name="$1"
    local ami_id="$2"
    local instance_type="${3:-t3a.nano}"
    local user_data="${4:-}"
    local subnet_type="${5:-infra}"

    [ -z "$ami_id" ] && ami_id=$(p6_cirrus_amis_freebsd12_latest)
    [ -n "$user_data" ] && user_data="--user-data=$user_data"

    local key_name=$(p6_cirrus_key_pair_make "$USER")

    local sg_id
    local subnet_id
    case $name in
    bastion)
        sg_id=$(p6_cirrus_sg_id_from_group_name "bastion-ssh")
        subnet_id=$(p6_cirrus_subnet_bastion_get)
        ;;
    *)
        sg_id=$(p6_cirrus_sg_id_from_group_name "vpc-ssh")
        subnet_id=$(p6_cirrus_subnet_${subnet_type}_get)
        ;;
    esac

    local sg_outbound_id=$(p6_cirrus_sg_id_from_group_name "outbound")

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
# Function: p6_cirrus_instance_ubuntu18_create()
#
#>
######################################################################
p6_cirrus_instance_ubuntu18_create() {

    p6_cirrus_instance_create "ubuntu18"
}

######################################################################
#<
#
# Function: p6_cirrus_instance_rhel8_create()
#
#>
######################################################################
p6_cirrus_instance_rhel8_create() {

    p6_cirrus_instance_create "rhel-8"
}

######################################################################
#<
#
# Function: p6_cirrus_instance_amazon_create()
#
#>
######################################################################
p6_cirrus_instance_amazon_create() {

    p6_cirrus_instance_create "amazon2"
}

######################################################################
#<
#
# Function: p6_cirrus_instance_bastion_create()
#
#>
######################################################################
p6_cirrus_instance_bastion_create() {

    p6_cirrus_instance_create "bastion"
}

######################################################################
#<
#
# Function: p6_cirrus_instance_irc_create()
#
#>
######################################################################
p6_cirrus_instance_irc_create() {

    local ami_id=$(p6_cirrus_amis_freebsd12_latest)
    p6_cirrus_instance_create "irc" "$ami_id" "t2.micro"
}

######################################################################
#<
#
# Function: p6_cirrus_instance_jenkins_create()
#
#>
######################################################################
p6_cirrus_instance_jenkins_create() {

    local ami_id=$(p6_cirrus_amis_freebsd12_latest)
    p6_cirrus_instance_create "jenkins" "$ami_id" "m4.large"
}
