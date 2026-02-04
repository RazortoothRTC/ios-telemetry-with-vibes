# Overview

A quick and dirty vibed repo to generate telemetry to a server, and also UDP so one can easily watch activity in realtime and search/slice/dice this data.

## Build

sudo docker compose up


## Verification

Send in data either by curl: curl -X POST http://localhost:9000   -H "Content-Type: application/json"   -d '{"message":"hello","counter":1,"timestamp":123}'

Or UDP echo "123,42,hello world" | nc -u -w0 localhost 9001

Or in iOS app: just build it and run it because 🐲🦀🍕

Example of Looking at data in Grafana:


<img width="1976" height="1520" alt="image" src="https://github.com/user-attachments/assets/aa1a8f2d-0a43-40c1-81c1-3cf1a63c2e26" />
