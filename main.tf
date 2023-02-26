# Указываем провайдер Yandex

terraform {
  required_providers {
    yandex = {
      source = "yandex-cloud/yandex"
    }
  }
  required_version = ">= 0.61.0"
}

# обязательные данные для подключения к провайдеру яндекса, к облаку

provider "yandex" {
  token     = "AQA2847ejfskfklklCS5PYbyw" # для запроса AUTH-Token использовать ссылку: https://oauth.yandex.ru/authorize?response_type=token&client_id=1a6990aa636648e9b2ef855fa7bec2fb      
  cloud_id  = "b1g18csfweiui33ef33k"                    # Скопировать с главной страницы облака
  folder_id = "b1gvbt0wkjelkjwei5e9"                    # Скопировать с станницы Folder, моя страница по умолчанию Default
  zone      = "ru-central1-a"                           # Указать зону по умолчанию
}

# Создаём сеть для нашего Docker swarm

resource "yandex_vpc_network" "network" {
  name = "swarm-network"
}

resource "yandex_vpc_subnet" "subnet" {
  name           = "subnet1"
  zone           = "ru-central1-a"
  network_id     = yandex_vpc_network.network.id
  v4_cidr_blocks = ["192.168.10.0/24"]
}

# создаём node для кластер Docker swarm - 1- Leader 2- Worker

module "swarm_cluster" {
  source        = "./modules/instance"
  vpc_subnet_id = yandex_vpc_subnet.subnet.id
  managers      = 1
  workers       = 2
}
