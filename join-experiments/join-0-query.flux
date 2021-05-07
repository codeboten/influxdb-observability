import "csv"

a = csv.from(file: "source.csv")
  |> range(start: 2021-05-06T00:00:00Z, stop: 2021-05-07T00:00:00Z)
  |> filter(fn: (r) => r["_measurement"] == "mem")
  |> filter(fn: (r) => r["_field"] == "used_percent")
  |> group(columns: ["host"])
  |> aggregateWindow(every: 15m, fn: max, createEmpty: false)

b = csv.from(file: "source.csv")
  |> range(start: 2021-05-06T00:00:00Z, stop: 2021-05-07T00:00:00Z)
  |> filter(fn: (r) => r["_measurement"] == "cpu")
  |> filter(fn: (r) => r["_field"] == "usage_user")
  |> filter(fn: (r) => r["cpu"] == "cpu-total")
  |> group(columns: ["host"])
  |> aggregateWindow(every: 15m, fn: max, createEmpty: false)

join(method: "inner", on: ["_time", "host"], tables: {t0: a, t1: b})
  |> map(fn: (r) => ({
    _time:  r._time,
    _value: r._value_t0 / r._value_t1,
    _field: "ratio",
    host:   r.host,
  }))
