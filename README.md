# Web output for BPQ MQTT Monitoring

This project is a simple wrapper around the [BPQ](https://www.cantab.net/users/john.wiseman/Documents/BPQ32.html) MQTT output that displays it on a infinite-scrolling web page. In Black and Green, because `~~aesthetics~~`.

It is intended to work without internet access and host all the required files locally.

This project is part of a wider project to wrap BPQ into modern accessible UIs and interfaces. See [bpq-compose](https://github.com/packethacking/bpq-compose).

# Prerequisites

You will need a MQTT server configured for authentication and with the web socket outputs enabled.

It will need two users. One with write access for BPQ and another with read output for BPQ

mosquitto.conf:
```
per_listener_settings true
listener 1883
password_file /etc/mosquitto/passwd
allow_anonymous false
listener 9001
protocol websockets
password_file /etc/mosquitto/webpasswd
acl_file /etc/mosquitto/webaclfile
allow_anonymous false
```

Required ACL file to restrict bpqmonweb to read only:
```
user bpqmonweb
topic read PACKETNODE/ax25/trace/bpqformat/#
```

## BPQ Configuration

The MQTT configuration for BPQ is fairly simple.
Add the following to the BPQ configuration file (usually `/etc/bpq32.cfg`)

```
MQTT=1
MQTT_HOST=localhost
MQTT_PORT=1883
MQTT_USER=<write access user>
MQTT_PASS=<write access password>
```

This will output each transmitted and recieved packet in two forms:
1. Raw binary data for the AX.25 frame
2. Decoded AX.25 frame - similar to the output of QtTermTCP monitor mode

The structure is intended to allow usage of a single MQTT server by multiple BPQ instances, so is grouped by the CALLSIGN of the BPQ instance then by sent/recieved.

### Binary

This is output to
`PACKETNODE/kiss/<CALLSIGN>/rcvd` or `PACKETNODE/kiss/<CALLSIGN>/sent`.

### Decoded

This is output to `PACKETNODE/ax25/trace/bpqformat/<CALLSIGN>/rcvd` or `PACKETNODE/ac25/trace/bpqformat/<CALLSIGN>/sent`.

## Deploying bpqmonweb

There are two approaches for deploying this service. A Docker image is provided with the correct nginx configuration for convenience or it can be run via nginx or another web host natively.

### Docker Deployment

```bash
docker run -d -p 8081:80 ghcr.io/packethacking/bpqmonweb:main
```

This expects the MQTT server to be running on the same machine on port 9001.

http://localhost:8081 should load the interface.

### Native Deployment

See [Sample Nginx Config](./nginx/nginx.conf) for an example for how to configure this.

## Security

The user details for the MQTT websocket connection are publicy visible in the JS source. Exercise extreme caution about exposing this to the public internet and ensure that the ACL for the user does not allow any unexpected interaction.        
