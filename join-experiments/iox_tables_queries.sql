-- In IOx, the source.csv will be replaced with many tables, each represents a distinct value in _measurement. For example, we will have tables "mem", "cpu", "host_address".

CREATE TABLE mem (
    _start TIMESTAMP,
    _stop TIMESTAMP,
    _time TIMESTAMP,
    _value float,
    _field VARCHAR, 
    host VARCHAR);

CREATE TABLE cpu (
    _start TIMESTAMP,
    _stop TIMESTAMP,
    _time TIMESTAMP,
    _value float,
    _field VARCHAR, 
    host VARCHAR);


SELECT T1.host, T1.time, T1.value/T2.value as ratio
FROM
    -- TIME_BUCKET function is not available in DataFusion yet
    (SELECT  host, TIME_BUCKET("15 minutes", _time) as time, max(_value) as value
    FROM    mem
    WHERE   _field = "used_percent" AND
            _time BETWEEN 2021-05-06T00:00:00Z AND 2021-05-07T00:00:00Z)
    GROUP BY host) AS T1
JOIN
    (SELECT  host, TIME_BUCKET("15 minutes", _time) as time, max(_value) as value
    FROM    cpu
    WHERE   _field = "usage_user" AND
            _time BETWEEN 2021-05-06T00:00:00Z AND 2021-05-07T00:00:00Z)
    GROUP BY host) AS T2
ON host, time;

-- TIME_BUCKET doc: https://docs.timescale.com/api/latest/analytics/time_bucket/
-- If you can figuring a sophiticated math expression that do the job of TIME_BUCKET, please help.


------------------------------
--- From join-0-query.flux

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
  |> filter(fn: (r) => r["cpu"] == "cpu-total")       -- Need to ask Jacob what this means
  |> group(columns: ["host"])
  |> aggregateWindow(every: 15m, fn: max, createEmpty: false)

join(method: "inner", on: ["_time", "host"], tables: {t0: a, t1: b})
  |> map(fn: (r) => ({
    _time:  r._time,
    _value: r._value_t0 / r._value_t1,
    _field: "ratio",
    host:   r.host,
  }))
