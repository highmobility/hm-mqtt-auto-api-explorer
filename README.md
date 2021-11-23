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


##Dashboards

###Summary

*Daily total distance driven* - shows distance daily difference. The first day of the data is set to zero and next day is compared to the previews day. Due that distance will be counted on next day after the day they were added.   