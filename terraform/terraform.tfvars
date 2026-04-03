vpc_name = "demo-todo-app"

instance_tenancy = "default"

enable_dns_hostnames = true

enable_dns_support = true

cidr_block = "192.168.0.0/16"

azs = ["ap-southeast-1a", "ap-southeast-1b"]

vpc_priv_subnets = ["192.168.1.0/24", "192.168.2.0/24"]

priv_name = "demo-todo-priv-subnet"

vpc_pub_subnets = ["192.168.5.0/24", "192.168.6.0/24"]

pub_name = "demo-todo-pub-subnet"

rtb_cidr = "0.0.0.0/0"

rtb_name = "demo-todo"

instance_type = "c7i-flex.large"

ami = "ami-014533a88507df1ae"

instance_count = 2

allow_ssh = [
  "49.228.15.122/32",
  "184.22.43.185/32",
  "184.22.108.220/32",
  "184.22.110.248/32"
]

key_pair_name = "uat-bastion-host"

key_name = "microk8s-key"

public_key_path = "~/.ssh/microk8s.pub"

rds_priv = "demo-rds-subnet"

db_name = "uatdb"

rds_name = "demo-todo-rds"

engine = "postgres"

engine_version = "16.11"

db_class = "db.t4g.micro"

user = "dbadmin"

db_password = "DBadmin123"

encrypt = true

storage_type = "gp3"

storage = "20"

multi = false

skip = true

final = false

apply = true

max = "50"

rds_sg = "demo-todo-rds-sg"