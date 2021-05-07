import "csv"

a = csv.from(file: "source.csv")
  |> range(start: 2021-05-06T00:00:00Z, stop: 2021-05-07T00:00:00Z)
  |> filter(fn: (r) => r["_measurement"] == "mem")
  |> filter(fn: (r) => r["_field"] == "used_percent")
  |> group(columns: ["host"])
  |> aggregateWindow(every: 15m, fn: max, createEmpty: false)

b = a
  |> timeShift(duration: 1h)

join(method: "inner", on: ["_time", "_field", "_measurement", "host"], tables: {t0: a, t1: b})
  |> map(fn: (r) => ({
    _time:           r._time,
    _value:          r._value_t0,
    projected_value: r._value_t1,
    _field:          r._field,
    host:            r.host,
    _measurement:    r._measurement,
  }))
