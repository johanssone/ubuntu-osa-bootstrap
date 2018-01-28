# -*- mode: ruby -*-
# vi: set ft=ruby :
VAGRANTFILE_API_VERSION = "2"

require 'fileutils'

CONFIG = File.join(File.dirname(__FILE__), "config.rb")

$instances = Array.new
$inventory = ""

if File.exist?(CONFIG)
  require CONFIG
end

$num_instances = $num_deployment_hosts + $num_controllers + $num_minions

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  ## Generic settings ##
  # TODO Fix real keys
  config.ssh.insert_key = false
  config.vm.box = "ubuntu/#{$image_version}"
  config.vm.box_check_update = "#{$box_check_update}"
  config.nfs.functional = false

  ## Virtualbox provider settings ##
  config.vm.provider :virtualbox do |vb|
    # TODO Support for guest additions?
    vb.check_guest_additions = false
    vb.functional_vboxsf = false
  end

  (1..$num_instances).each do |i|
    role = ""
    num = i
    if num <= $num_deployment_hosts
      role = "deploy"
    else
      num = (i - $num_deployment_hosts)
      if num <= $num_controllers
        role = "controller"
      else
        num = (i - $num_deployment_hosts - $num_controllers)
        if num <= $num_minions
          role = "compute"
        end
      end
    end
    # Save instance info for later
    $instances[i] = {
      "name" => "#{$instance_name_prefix}-#{role}-#{num}",
      "hostname" => "#{role}-#{num}.#{$instance_name_prefix}.den",
      "role" => role,
      "num" => num,
      "ip" => "#{$ip_range}#{i + $ip_start}"
    }

    config.vm.define vm_name = $instances[i]["name"] do |config|
      config.vm.hostname = $instances[i]['hostname']
      config.vm.provider :virtualbox do |vb|
        if $role == "deploy"
          vb.memory = $memory_deployment
          vb.cpus = $cpu_deployment
        elsif $role == "controller"
          vb.memory = $memory_controllers
          vb.cpus = $cpu_controllers
        else
          vb.memory = $memory_minions
          vb.cpus = $cpu_minions
        end
        # Use faster paravirtualized networking
        vb.customize ["modifyvm", :id, "--nictype1", "virtio"]
        vb.customize ["modifyvm", :id, "--nictype2", "virtio"]
      end
      config.vm.network :private_network, ip: $instances[i]['ip']

      # Gather hosts into inventory pool
      if $instances[i]['num'] == 1
        $inventory.concat "\n[#{$instances[i]['role']}]\n"
      end
      $inventory.concat "#{$instances[i]['ip']}\n"

      # Debug printout for each VM
      config.vm.provision "shell", privileged: false, inline: <<-EOF
        echo "#{$instances[i]['name']} Booted"
        echo "Info: #{$instances[i]}"
        echo "#{i} #{$num_instances}"
      EOF

      if $instances[i]['role'] == "deploy" then
        config.vm.provision "shell", path: "bootstrap/install-ansible.sh"
      end

      # Run ansible tasks after last host is created
      if i == $num_instances
        # Write local ansible inventory
        File.open($ansible_inventory ,'w') do |f|
          $inventory.concat "\n[vagrant:children]\ndeploy\ncontroller\ncompute\n\n[deploy:children]\ndeploy\n\n[controller:children]\ncontroller\n\n[compute:children]\ncompute\n"
          f.write $inventory
        end
      end
    end
  end
end
