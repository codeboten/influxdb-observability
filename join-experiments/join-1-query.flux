import "csv"

a = csv.from(file: "source-flux-mem.csv")
  |> range(start: 2021-05-09T20:00:00Z, stop: 2021-05-09T20:59:59.999999999Z)
  |> group(columns: ["host"])
  |> aggregateWindow(every: 15m, fn: max, column: "used_percent", createEmpty: false)

b = csv.from(file: "source-flux-addr.csv")
  |> range(start: 1970-01-01T00:00:00Z, stop: 2000-01-01T00:00:00Z)
  |> group(columns: ["host"])

join(method: "inner", on: ["host"], tables: {t0: a, t1: b})
  |> map(fn: (r) => ({
    _time:        r._time_t0,
    host:         r.host,
    address:      r.address,
    used_percent: r.used_percent,
  }))
