module tests

go 1.16

require (
	github.com/containerd/containerd v1.5.2 // indirect
	github.com/influxdata/influxdb-observability/common v0.1.1
	github.com/influxdata/line-protocol/v2 v2.0.0-20210520103755-6551a972d603
	github.com/influxdata/telegraf v1.18.3
	github.com/open-telemetry/opentelemetry-collector-contrib/exporter/influxdbexporter v0.0.0-20210607140028-439ff5f266ab
	github.com/open-telemetry/opentelemetry-collector-contrib/receiver/influxdbreceiver v0.0.0-20210607140028-439ff5f266ab
	github.com/stretchr/testify v1.7.0
	go.opentelemetry.io/collector v0.30.0
	go.opentelemetry.io/collector/model v0.30.0
	go.uber.org/zap v1.18.1
	google.golang.org/grpc v1.39.0
)

replace (
	github.com/influxdata/influxdb-observability/common => ../common
	github.com/influxdata/influxdb-observability/influx2otel => ../influx2otel
	github.com/influxdata/influxdb-observability/otel2influx => ../otel2influx
	github.com/influxdata/telegraf => ../../telegraf
	github.com/open-telemetry/opentelemetry-collector-contrib/exporter/influxdbexporter => ../../opentelemetry-collector-contrib/exporter/influxdbexporter
	github.com/open-telemetry/opentelemetry-collector-contrib/receiver/influxdbreceiver => ../../opentelemetry-collector-contrib/receiver/influxdbreceiver
	go.opentelemetry.io/collector => ../../opentelemetry-collector
	go.opentelemetry.io/collector/model => ../../opentelemetry-collector/model
)
