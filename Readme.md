<h2>Описание: </h2><br><br>

Мы продолжаем развивать наш интернет-магазин по продаже носков. В этом задании мы посмотрим, как Docker Swarm работает в облаке. <br>
Для этого мы создадим несколько серверов в Yandex.Cloud, установим туда Docker, объединим эти инстансы в кластер и задеплоим туда наш интернет-магазин <br>
по продаже носков.<br><br>

После успешной инсталляции необходимо зайти по выделенному IP и убедиться, что наш проект доступен извне через браузер.<br><br>

Для выполнения задания нужно использовать конфигурацию для Docker Compose из предыдущего задания. Некоторые директивы нужно модифицировать таким образом,<br>
чтобы сервисы запустились без ошибок в новом swarm-кластере.<br><br>

Все инструкции по выполнению этого задания выполнены с помощью Terraform. Если у вас возникают сложности с выполнением, вы можете посмотреть решение. 
Можно выполнять задание любым удобным способом.<br><br>
<h2>Задание: </h2>
<br>
1. Подготовить аккаунт в Yandex.Cloud. <br>
2. Создать три инстанса в Yandex.Cloud: <br>
 *  Объединить их в сеть.<br>
 *  Добавить внешний IP для доступа к проекту через браузер.<br>
3. Создать Docker Swarm кластер с одной управляющей нодой и двумя worker-нодами. <br>
4. Задеплоить в swarm-кластер исправленный файл docker-compose.yml. <br>
5. Проверить в браузере, что проект работает. <br>
6. Масштабировать frontend-сервис до двух реплик. <br>
7. Для проверки задания необходимо отправить:<br>
 *  Описание — каким образом и какие команды использовались для решения задания.<br>
<b> Ответ: <br>
Все инструкции для выполнения этого задания были выполнены с помощью Terraform <br>
Нужные файлы конфигурации были взяты из: https://github.com/kksudo/microservices-demo/tree/user-contribs/deploy/docker-swarm/infra/yandex <br>
Также данные инструкции были адаптированны согласно текущего задания. <br><br></b>
 *  Скриншот страницы в браузере (главной страницы проекта, работающего в Yandex.Cloud).<br>
<b> Ответ: <br>
/screenshots/docker-swarm-ya-cloud.JPG  <br>
/screenshots/sock-shop.JPG               <br><br></b>
 *  Вывод команды docker service ls. <br>
<b> Ответ: <br> 
root@manager-0:/home/ubuntu# docker service ls   <br>
<code>
ID         NAME      MODE         REPLICAS   IMAGE                                PORTS <br>
c04wy18hfqns   sockshop-swarm_carts          replicated   2/2        weaveworksdemos/carts:0.4.8                 <br>
tvslvhmd7xa6   sockshop-swarm_carts-db       replicated   2/2        mongo:3.4                                   <br>
ty97h34foijg   sockshop-swarm_catalogue      replicated   2/2        weaveworksdemos/catalogue:0.3.5             <br>
4c646e6dlji6   sockshop-swarm_catalogue-db   replicated   2/2        weaveworksdemos/catalogue-db:0.3.0          <br>
n9ko5lqiiri5   sockshop-swarm_edge-router    replicated   2/2        weaveworksdemos/edge-router:0.1.1    *:80->80/tcp, *:8080->8080/tcp <br>
o09xqs3vc0cb   sockshop-swarm_front-end      replicated   2/2        weaveworksdemos/front-end:0.3.12             <br>
yle36b0zbzzn   sockshop-swarm_orders         replicated   2/2        weaveworksdemos/orders:0.4.7                 <br>
qz8tqbv4o561   sockshop-swarm_orders-db      replicated   2/2        mongo:3.4                                     <br>
09v9db6l0uq6   sockshop-swarm_payment        replicated   2/2        weaveworksdemos/payment:0.4.3                 <br>
2umtxwduu614   sockshop-swarm_queue-master   replicated   2/2        weaveworksdemos/queue-master:0.3.1            <br>
zyj0i6dlvj6c   sockshop-swarm_rabbitmq       replicated   2/2        rabbitmq:3.6.8                                <br>
ln79yalhi76f   sockshop-swarm_shipping       replicated   2/2        weaveworksdemos/shipping:0.4.8                </code><br><br></b>
 *  Вывод команды docker node ls. <br>
<b> Ответ: <br>
  <code>
root@manager-0:/home/ubuntu# docker node ls  <br>
ID                            HOSTNAME    STATUS    AVAILABILITY   MANAGER STATUS   ENGINE VERSION <br>
ijmhl6g4eyi35rg6dhji31m9b *   manager-0   Ready     Active         Leader           23.0.1          <br>
082zphsmb90benlzls8od1mli     worker-0    Ready     Active                          23.0.1          <br>
xqd5qpknw3arx6k6anlm4mox4     worker-1    Ready     Active                          23.0.1          </code><br><br></b>

8. Погасить проект. <br> 
