#!/usr/bin/env bash
#
# Copyright 2015-2017 - gatblau.org
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#    http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#
# Performs initialisation of the linux environment including the installation
# of Ansible for the provisioning of the various required tools.
# This script is executed by packer using a shell provisioner.
#
# builds a zip file with all binary artefacts to be provisioned to europa.
#

# downloads binary artefacts from internet
sh fetch.sh

