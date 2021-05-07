import "csv"

a = csv.from(file: "source.csv")
  |> range(start: 2021-05-06T00:00:00Z, stop: 2021-05-07T00:00:00Z)
  |> filter(fn: (r) => r["_measurement"] == "mem")
  |> filter(fn: (r) => r["_field"] == "used_percent")
  |> group(columns: ["host"])
  |> aggregateWindow(every: 15m, fn: max, createEmpty: false)

b = csv.from(file: "source.csv")
  |> range(start: 1970-01-01T00:00:00Z, stop: 2000-01-01T00:00:00Z)
  |> filter(fn: (r) => r["_measurement"] == "host_address")
  |> group(columns: ["host"])

join(method: "inner", on: ["host"], tables: {t0: a, t1: b})
  |> map(fn: (r) => ({
    _time:   r._time_t0,
    _value:  r._value,
    _field:  r._field,
    host:    r.host,
    address: r.address,
  }))
