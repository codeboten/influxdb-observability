module github.com/influxdata/influxdb-observability/otel2influx

go 1.16

require (
	github.com/influxdata/influxdb-observability/common v0.1.1
	github.com/stretchr/testify v1.7.0
	go.opentelemetry.io/collector/model v0.30.0
)

replace (
	github.com/influxdata/influxdb-observability/common => ../common
	go.opentelemetry.io/collector/model => ../../opentelemetry-collector/model
)
