
## Setup
Make sure you have installed Docker Engine / Docker Desktop: https://docs.docker.com/get-docker/

### Credentials
At the moment all access credentials are coming from InfluxDB environment variables configuration
* modify influxdb setup parameters in [env.env](./influxdb/env.env)
  * token, org, bucket are reused in telegraf configuration and in the grafana provisioning
  
#### InfluxDB
Login: [Access InfluxDB](http://localhost:8086)
* username: [DOCKER_INFLUXDB_INIT_USERNAME](./influxdb/env.env)
* password: [DOCKER_INFLUXDB_INIT_PASSWORD](./influxdb/env.env)


#### Grafana 
Login: [Access Grafana](http://localhost:3000/d/p/fleet-dashboard?orgId=1)
* username: `admin`
* password: `admin`

### Docker Compose Deploy
Start all services:
```
docker compose up
```
### Modify Telegraf topic filter:
Telegraf topic filter set to: ```live/# ```. This will match all topics that start with ```live/```
You can modify Telegraf filter here: [telegraf.conf](./telegraf/telegraf.conf)
```
  topics = [
    "live/#"
  ]
```
to
```
  topics = [
    "live/#",
    "test/hello"
  ]
```
to subscribe also ```test/hello``` topic events

### Enabling Telegraf MQTT Auto API broker TLS communication
* Download MQTT Auto API broker client certificates ( instructions here https://docs.high-mobility.com/guides/getting-started/mqtt/ )
* Extract certificates into [./tls/](./tls) directory
  * this directory is mounted to Telegraf and also to mqtt container
  * You should have following files:
    * <client-id>-ca_certificates.pem
    * <client-id>-certificate.pem.crt
    * <client-id>-private.pem.key
* In the Telegraf mqtt_consumer plugin configuration do following changes:
```
[[inputs.mqtt_consumer]]
  # TLS Configuration
  
  tls_ca = "/etc/telegraf/mqtt/<client-id>-ca_certificates.pem"
  tls_cert = "/etc/telegraf/mqtt/<client-id>-certificate.pem.crt"
  tls_key = "/etc/telegraf/mqtt/<client-id>-private.pem.key"
  
  ## Use TLS but skip chain & host verification
  # insecure_skip_verify = false

  persistent_session = true
  client_id = "<client-id>" # Do not forget to define your clientId
  servers = ["ssl://mqtt.high-mobility.com:8883"]
  ...
```
 
### Publish Messages:

```
docker compose exec mqtt mosquitto_pub -h localhost -m '{"n": 19}' -t "live/there"
```

Publish Messages with script ( [generate.sh](./data-generator/generate.sh) ):

```
docker compose exec mqtt sh generate.sh
```




##Dashboards
Following dashboards are provided with the repository
### Fleet Overview
#### General
Panels:
 * Cars Connected 
 * Actions Required
 * Services Today
 * Services This Week

#### Actions Required
 Table panel that presents following events:
 * Crash incidents
 * Service overdue
 * Theft Alarm

#### Car Overview
 Map panel where cars are shown on world map. As additional information car location outer temperature is displayed.

#### Health Status 
Panels:
 * Overall - problematic cars count with overall % of total cout of cars 
 * Cars with warning lights
 * Cars with trouble codes

#### Car Services 
Panels:
 * Today
 * Services
 * Inspection
 * Oil Changes
 
### Summary

*Daily total distance driven* - shows distance daily difference. The first day of the data is set to zero and next day is compared to the previews day. Due that distance will be counted on next day after the day they were added.   