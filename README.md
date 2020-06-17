### init.zsh:
- p6df::modules::p6-cirrus-inc::deps()
- p6df::modules::p6-cirrus-inc::init()
- p6df::modules::p6-cirrus-inc::version()

### app.sh:
- p6_cirrius_inc_sg_myself_allow(sg_name, [port=443])
- p6_cirrus_inc_cleanup()
- p6_cirrus_inc_instance_amazon_create()
- p6_cirrus_inc_instance_bastion_create()
- p6_cirrus_inc_instance_create(name, ami_id, [instance_type=t3a.nano], [user_data=], [subnet_type=infra])
- p6_cirrus_inc_instance_irc_create()
- p6_cirrus_inc_instance_jenkins_create()
- p6_cirrus_inc_instance_rhel8_create()
- p6_cirrus_inc_instance_ubuntu18_create()
- p6_cirrus_inc_sg_link_bastion_vpc_ssh()
- p6_cirrus_inc_sg_link_bastion_world_ssh()
- p6_cirrus_inc_sg_link_outbound_world_world()
- str key_id = p6_aws_kms_svc_key_make(account_id, key_description, key_alias)
- str sg_bastion_ssh_id = p6_cirrus_inc_sg_bastion_ssh_create([vpc_id=$AWS_VPC])
- str sg_instance_ssh_id = p6_cirrus_inc_sg_instance_ssh_create([vpc_id=$AWS_VPC])
- str sg_outbound_id = p6_cirrus_inc_sg_outbound_ssh_create([vpc_id=$AWS_VPC])

