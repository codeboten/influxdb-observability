import "csv"

a = csv.from(file: "source-flux-mem.csv")
  |> range(start: 2021-05-09T20:00:00Z, stop: 2021-05-09T20:59:59.999999999Z)
  |> group(columns: ["host"])
  |> aggregateWindow(every: 10m, fn: max, column: "used_percent", createEmpty: false)

b = a
  |> timeShift(duration: 10m)

join(method: "inner", on: ["_time", "_measurement", "host"], tables: {t0: a, t1: b})
  |> map(fn: (r) => ({
    _time:                  r._time,
    host:                   r.host,
    used_percent:           r.used_percent_t0,
    projected_used_percent: r.used_percent_t1,
  }))
