# p6-cirrus

## Table of Contents


### p6-cirrus
- [p6-cirrus](#p6-cirrus)
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
[![Gitpod ready-to-code](https://img.shields.io/badge/Gitpod-ready--to--code-blue?logo=gitpod)](https://gitpod.io/#https://github.com/p6m7g8/p6-cirrus)
[![Mergify](https://img.shields.io/endpoint.svg?url=https://gh.mergify.io/badges/p6m7g8/p6-cirrus/&style=flat)](https://mergify.io)
[![codecov](https://codecov.io/gh/p6m7g8/p6-cirrus/branch/master/graph/badge.svg?token=14Yj1fZbew)](https://codecov.io/gh/p6m7g8/p6-cirrus)
[![Known Vulnerabilities](https://snyk.io/test/github/p6m7g8/p6-cirrus/badge.svg?targetFile=package.json)](https://snyk.io/test/github/p6m7g8/p6-cirrus?targetFile=package.json)
[![Gihub repo dependents](https://badgen.net/github/dependents-repo/p6m7g8/p6-cirrus)](https://github.com/p6m7g8/p6-cirrus/network/dependents?dependent_type=REPOSITORY)
[![Gihub package dependents](https://badgen.net/github/dependents-pkg/p6m7g8/p6-cirrus)](https://github.com/p6m7g8/p6-cirrus/network/dependents?dependent_type=PACKAGE)

## Summary

## Contributing

- [How to Contribute](CONTRIBUTING.md)

## Code of Conduct

- [Code of Conduct](https://github.com/p6m7g8/.github/blob/master/CODE_OF_CONDUCT.md)

## Changes

- [Change Log](CHANGELOG.md)

## Usage

### p6-cirrus:

#### p6-cirrus/init.zsh:

- p6df::modules::p6cirrus::deps()
- p6df::modules::p6cirrus::init()


### ../p6-cirrus/lib:

#### ../p6-cirrus/lib/instance.sh:

- p6_cirrus_instance_amazon_create()
- p6_cirrus_instance_bastion_create()
- p6_cirrus_instance_create(name, ami_id, [instance_type=t3a.nano], [user_data=], [subnet_type=infra])
- p6_cirrus_instance_irc_create()
- p6_cirrus_instance_jenkins_create()
- p6_cirrus_instance_rhel8_create()
- p6_cirrus_instance_ubuntu18_create()

#### ../p6-cirrus/lib/kms.sh:

- str key_id = p6_cirrus_kms_key_make(account_id, key_description, key_alias)

#### ../p6-cirrus/lib/sg.sh:

- p6_cirrus_sg_link_bastion_vpc_ssh()
- p6_cirrus_sg_link_bastion_world_ssh()
- p6_cirrus_sg_link_outbound_world_world()
- p6_cirrus_sg_myself_allow(sg_name, [port=443])
- str sg_bastion_ssh_id = p6_cirrus_sg_bastion_ssh_create([vpc_id=$AWS_VPC])
- str sg_instance_ssh_id = p6_cirrus_sg_instance_ssh_create([vpc_id=$AWS_VPC])
- str sg_outbound_id = p6_cirrus_sg_outbound_ssh_create([vpc_id=$AWS_VPC])

#### ../p6-cirrus/lib/util.sh:

- p6_cirrus_cleanup()



## Hier
```text
.
├── instance.sh
├── kms.sh
├── sg.sh
└── util.sh

0 directories, 4 files
```
## Author

Philip M . Gollucci <pgollucci@p6m7g8.com>
