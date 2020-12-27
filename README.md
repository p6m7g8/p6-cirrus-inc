# p6-cirrus-inc

## Table of Contents


### p6-cirrus-inc
- [p6-cirrus-inc](#p6-cirrus-inc)
  - [Badges](#badges)
  - [Distributions](#distributions)
  - [Summary](#summary)
  - [Contributing](#contributing)
  - [Code of Conduct](#code-of-conduct)
  - [Changes](#changes)
    - [Usage](#usage)
  - [Author](#author)

### Badges

[![License](https://img.shields.io/badge/License-Apache%202.0-yellowgreen.svg)](https://opensource.org/licenses/Apache-2.0)
[![Gitpod ready-to-code](https://img.shields.io/badge/Gitpod-ready--to--code-blue?logo=gitpod)](https://gitpod.io/#https://github.com/p6m7g8/p6-cirrus-inc)
[![Mergify](https://img.shields.io/endpoint.svg?url=https://gh.mergify.io/badges/p6m7g8/p6-cirrus-inc/&style=flat)](https://mergify.io)
[![codecov](https://codecov.io/gh/p6m7g8/p6-cirrus-inc/branch/master/graph/badge.svg?token=14Yj1fZbew)](https://codecov.io/gh/p6m7g8/p6-cirrus-inc)
[![Known Vulnerabilities](https://snyk.io/test/github/p6m7g8/p6-cirrus-inc/badge.svg?targetFile=package.json)](https://snyk.io/test/github/p6m7g8/p6-cirrus-inc?targetFile=package.json)
[![Gihub repo dependents](https://badgen.net/github/dependents-repo/p6m7g8/p6-cirrus-inc)](https://github.com/p6m7g8/p6-cirrus-inc/network/dependents?dependent_type=REPOSITORY)
[![Gihub package dependents](https://badgen.net/github/dependents-pkg/p6m7g8/p6-cirrus-inc)](https://github.com/p6m7g8/p6-cirrus-inc/network/dependents?dependent_type=PACKAGE)

## Summary

## Contributing

- [How to Contribute](CONTRIBUTING.md)

## Code of Conduct

- [Code of Conduct](https://github.com/p6m7g8/.github/blob/master/CODE_OF_CONDUCT.md)

## Changes

- [Change Log](CHANGELOG.md)

### Usage

#### init.zsh:

- p6df::modules::p6-cirrus-inc::deps()
- p6df::modules::p6-cirrus-inc::init()

#### app.sh:

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


## Author

Philip M . Gollucci <pgollucci@p6m7g8.com>
