# Подключемся через Terraform к Leader node для утановки сервисов.

resource "null_resource" "docker-swarm-manager" {
  count = var.managers
  depends_on = [yandex_compute_instance.vm-manager]
  connection {
    user        = var.ssh_credentials.user
    private_key = file(var.ssh_credentials.private_key)                                                # используем ssh ключ, должен быть безпарольный 
    host        = yandex_compute_instance.vm-manager[count.index].network_interface.0.nat_ip_address
  }

# Переносим docker-compose файл в Leader node
  provisioner "file" {
    source      = "/home/odmin/project/terraform/docker-compose/docker-compose-v3.yml"
    destination = "/home/ubuntu/docker-compose.yml"
  }

# Устанавливаем Docker-compose, активируем Docker swarm
  provisioner "remote-exec" {
    inline = [
      "curl -fsSL https://get.docker.com | sh",
      "sudo usermod -aG docker $USER",
      "sudo apt install -y docker-compose",
      "sudo docker swarm init",
      "sleep 10",
      "echo COMPLETED"
    ]
  }
}

# Подключаем Worker node к кластеру docker swarm
resource "null_resource" "docker-swarm-manager-join" {
  count = var.managers
  depends_on = [yandex_compute_instance.vm-manager, null_resource.docker-swarm-manager]
  connection {
    user        = var.ssh_credentials.user
    private_key = file(var.ssh_credentials.private_key)                                              # используем ssh ключ, должен быть безпарольный
    host        = yandex_compute_instance.vm-manager[count.index].network_interface.0.nat_ip_address
  }

# Создаём скрипт с командой добавления worker node к кластеру docker swarm
  provisioner "local-exec" {
    command = "TOKEN=$(ssh -i ${var.ssh_credentials.private_key} -o StrictHostKeyChecking=no ${var.ssh_credentials.user}@${yandex_compute_instance.vm-manager[count.index].network_interface.0.nat_ip_address} docker swarm join-token -q worker); echo \"#!/usr/bin/env bash\nsudo docker swarm join --token $TOKEN ${yandex_compute_instance.vm-manager[count.index].network_interface.0.nat_ip_address}:2377\nexit 0\" >| join.sh"
  }
}

# Заходим на worker node для  присоединения кластеру docker swarm
resource "null_resource" "docker-swarm-worker" {
  count = var.workers
  depends_on = [yandex_compute_instance.vm-worker, null_resource.docker-swarm-manager-join]
  connection {
    user        = var.ssh_credentials.user
    private_key = file(var.ssh_credentials.private_key)                                              # используем ssh ключ, должен быть безпарольный
    host        = yandex_compute_instance.vm-worker[count.index].network_interface.0.nat_ip_address
  }

# Копируем скрипт в worker node
  provisioner "file" {
    source      = "join.sh"
    destination = "/home/ubuntu/join.sh"
  }

# даём права на скрипт для запуска и запускаем его
  provisioner "remote-exec" {
    inline = [
      "curl -fsSL https://get.docker.com | sh",
      "sudo usermod -aG docker $USER",
      "chmod +x /home/ubuntu/join.sh",
      "~/join.sh"
    ]
  }
}

# деплоим Docker-compse file в stack Docker swarm 
resource "null_resource" "docker-swarm-manager-start" {
  depends_on = [yandex_compute_instance.vm-manager, null_resource.docker-swarm-manager-join]
  connection {
    user        = var.ssh_credentials.user
    private_key = file(var.ssh_credentials.private_key)
    host        = yandex_compute_instance.vm-manager[0].network_interface.0.nat_ip_address
  }

  provisioner "remote-exec" {
    inline = [
        "docker stack deploy --compose-file /home/ubuntu/docker-compose.yml sockshop-swarm"
    ]
  }

# удаляем скрипт для присоединения worker node
  provisioner "local-exec" {
    command = "rm join.sh"
  }
}

