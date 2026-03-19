resource "local_file" "ansible_inventory" {
  filename = "${path.module}/../ansible/inventory.ini"

  content = <<EOT
[masters]
master ansible_host=${aws_instance.master_node_ec2.private_ip}

[workers]
worker1 ansible_host=${aws_instance.workers[0].private_ip}
worker2 ansible_host=${aws_instance.workers[1].private_ip}

[all:vars]
ansible_user=ubuntu
ansible_ssh_private_key_file=~/.ssh/microk8s

ansible_ssh_common_args='-o StrictHostKeyChecking=no -o ProxyCommand="ssh -i ~/.ssh/microk8s -W %h:%p -q ubuntu@${aws_instance.bastion_host.public_ip}"'
EOT
}