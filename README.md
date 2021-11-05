Influxdb setup:
* modify influxdb setup parameters in [env.env](./influxdb/env.env)
  * token, org, bucket are reused in telegraf configuration and in the grafana provisioning
    * in long term all systems should get individual tokens   


Start all services:
```
docker-compose up
```

Publish Messages:

```
docker compose exec mqtt mosquitto_pub -h localhost -m '{"n": 19}' -t "hello/there"
```

[Optional] List records in DB:
```
docker compose exec influxdb influx -database telegraf --execute 'select * from mqtt_consumer'
```

[Access Grafana](http://localhost:3000/d/ZZpjsHv7z)
* username: `admin`
* password: `admin`
