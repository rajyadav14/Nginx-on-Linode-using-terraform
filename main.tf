terraform {
  required_providers {
    linode = {
        source = "linode/linode"
    }
  }
}

provider "linode" {
  token = var.token_linode
}

resource "linode_instance" "webserver1" {
    label = "web_server-${count.index}"
    image = "linode/ubuntu18.04"
    region = var.region
    type = var.instance_type
    root_pass = var.root_password
    count = var.node_count
    
    
    tags = ["demo"]
    private_ip = true

    connection {
      type = "ssh"
      user = "root"
      password = var.root_password
      host = self.ip_address
    }

    provisioner "file" {
        source = "setup_script.sh"
        destination = "/tmp/setup_script.sh"
    }

    provisioner "remote-exec" {
        inline = [ 
            "chmod +x /tmp/setup_script.sh",
            "/tmp/setup_script.sh",
         ]
    }

}

#nodebalancers

resource "linode_nodebalancer" "mynodebalancer" {
    label = "mynodebalancer"
    region = var.region
    client_conn_throttle = 20
    tags = ["demo"]
}

resource "linode_nodebalancer_config" "lb-config" {
  nodebalancer_id = linode_nodebalancer.mynodebalancer.id
  port = 80
  protocol = "http"
    check = "http"
    check_path = "/"
    check_attempts = 3
    check_timeout = 3
    check_interval = 5
    stickiness = "http_cookie"
    algorithm = "roundrobin"
}

resource "linode_nodebalancer_node" "webnode" {
    count = var.node_count
    nodebalancer_id = linode_nodebalancer.mynodebalancer.id
    config_id = linode_nodebalancer_config.lb-config.id
    address = "${element(linode_instance.webserver1.*.private_ip_address, count.index)}:8080"
    label = "nb-backnode-${count.index}"
    weight = 100
}
