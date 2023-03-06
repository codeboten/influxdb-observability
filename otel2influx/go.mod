module github.com/influxdata/influxdb-observability/otel2influx

go 1.16

require (
	github.com/influxdata/influxdb-observability/common v0.2.7
	github.com/stretchr/testify v1.7.1
	go.opentelemetry.io/collector/model v0.50.0
)

replace github.com/influxdata/influxdb-observability/common => ../common
