import "csv"

a = csv.from(file: "source-flux-mem.csv")
  |> range(start: 2021-05-09T20:00:00Z, stop: 2021-05-09T20:59:59.999999999Z)
  |> group(columns: ["host"])
  |> aggregateWindow(every: 15m, fn: max, column: "used_percent", createEmpty: false)

b = csv.from(file: "source-flux-cpu.csv")
  |> range(start: 2021-05-09T20:00:00Z, stop: 2021-05-09T20:59:59.999999999Z)
  |> group(columns: ["host"])
  |> aggregateWindow(every: 15m, fn: max, column: "usage_user", createEmpty: false)

join(method: "inner", on: ["_time", "host"], tables: {t0: a, t1: b})
  |> map(fn: (r) => ({
    _time: r._time,
    host:  r.host,
    ratio: r.used_percent / r.usage_user,
  }))
