###############################
#     Instance Settings       #
###############################

# IP range
$ip_range='192.168.51.'
# IP start from
$ip_start=50

# Number of deployment hosts
$num_deployment_hosts = 1 # TODO Really have this configurable?
# Memory & CPU settings for controller(s)
$memory_deployment = 2048
$cpu_deployment = 2

# Number of controllers
$num_controllers = 1
# Memory & CPU settings for controller(s)
$memory_controllers = 2048
$cpu_controllers = 2

# Number of computes
$num_minions = 1
# Memory & CPU settings for compute(s)
$memory_minions = 2048
$cpu_minions = 2

# TODO Add dedicated network node for full test?

# Prefix instances for multi cluster support
$instance_name_prefix = "dev"
###############################
#        Box Settings         #
###############################
# Check for box updates on vagrant up?
$box_update_check = false
# Ubuntu version to use
$image_version = "xenial64"

###############################
#        Config Settings      #
###############################

$ansible_playbook = "ansible/osa_bootstrap.yml"
$ansible_inventory = "ansible/inventory/vagrant"
