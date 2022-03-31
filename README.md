# Ddos

To start ddos:

  * Build a container `docker-compose build`
  * Make shure that url-s in "docker-compose.yml" you want to ddos, otherwise replace it(URLS). You also have possibility to ddos multiple urls by spliting them with comas "https://www.gosuslugi.ru/,https://fishki.net/".
  * You can change threads("docker-compose.yml" THREADS) depends on your mashine configuration.
  * If you had some proxies, you can use them in "docker-compose.yml" PROXYS with this pattern "host:post,host:port".
  * Run container `docker-compose up`

Enjoy.

