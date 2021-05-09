# Join Experiments

Files `source-flux-cpu.csv` and `source-flux-mem.csv` were created by collecting telegraf metrics in Cloud 2, using these queries:
```flux
from(bucket: "workstations")
  |> range(start: 2021-05-09T20:00:00Z, stop: 2021-05-09T20:59:59.999999999Z)
  |> filter(fn: (r) => r["_measurement"] == "cpu")
  |> filter(fn: (r) => r["cpu"] == "cpu-total")
  |> filter(fn: (r) => r["_field"] == "usage_user")
  |> pivot(rowKey: ["_time"], columnKey: ["_field"], valueColumn: "_value")
  |> group()
  |> keep(columns: ["_time", "_measurement", "host", "usage_user"])
  |> sort(columns: ["_time"])
```

```flux
from(bucket: "workstations")
  |> range(start: 2021-05-09T20:00:00Z, stop: 2021-05-09T20:59:59.999999999Z)
  |> filter(fn: (r) => r["_measurement"] == "mem")
  |> filter(fn: (r) => r["_field"] == "used_percent")
  |> pivot(rowKey: ["_time"], columnKey: ["_field"], valueColumn: "_value")
  |> group()
  |> keep(columns: ["_time", "_measurement", "host", "used_percent"])
  |> sort(columns: ["_time"])
```

Files `source-iox-cpu.csv` and `source-iox-mem.csv` were created by collecting telegraf metrics in IOx, using these queries:
```sql
SELECT time, host, usage_user
FROM cpu
WHERE
  cpu = 'cpu-total'
  AND
  usage_user IS NOT NULL
  AND
  time BETWEEN timestamp '2021-05-09T20:00:00Z' AND timestamp '2021-05-09T20:59:59.999999999Z'
ORDER BY time ASC
```

```sql
SELECT time, host, used_percent
FROM mem
WHERE
  time BETWEEN timestamp '2021-05-09T20:00:00Z' AND timestamp '2021-05-09T20:59:59.999999999Z'
ORDER BY time ASC
```

IOx/SQL schema assumed to be:
```sql
CREATE TABLE mem (
    time         TIMESTAMP,
    host         VARCHAR,
    used_percent FLOAT);

CREATE TABLE cpu (
    time       TIMESTAMP,
    host       VARCHAR,
    usage_user FLOAT);

CREATE TABLE host_address (
    host    VARCHAR,
    address VARCHAR);
```

## 0: Math Across Measurements

### TSM/Flux

(query in `join-0-query.flux`)

```console
$ flux execute @join-0-query.flux
Result: _result
Table: keys: [host]
           host:string                      _time:time                   ratio:float  
----------------------  ------------------------------  ----------------------------  
          Orient.local  2021-05-09T20:15:00.000000000Z             5.494019654799265  
          Orient.local  2021-05-09T20:30:00.000000000Z            5.9601936294803775  
          Orient.local  2021-05-09T20:45:00.000000000Z             7.160120423384796  
          Orient.local  2021-05-09T20:59:59.999999999Z             7.345712415493132  
Table: keys: [host]
           host:string                      _time:time                   ratio:float  
----------------------  ------------------------------  ----------------------------  
               tortuga  2021-05-09T20:15:00.000000000Z            3.4246697123810237  
               tortuga  2021-05-09T20:30:00.000000000Z            13.215366835810805  
               tortuga  2021-05-09T20:45:00.000000000Z             9.414764778954357  
               tortuga  2021-05-09T20:59:59.999999999Z             11.53822837788286
```

### IOx/SQL
```sql
SELECT mem.time AS time, mem.host AS host, mem.used_percent / cpu.usage_user AS ratio
FROM

(
    SELECT host, TIME_BUCKET("15 minutes", time) AS time, MAX(used_percent) AS used_percent
    FROM mem
    WHERE time BETWEEN '2021-05-09T20:00:00Z' AND '2021-05-09T20:59:59.999999999Z'
    GROUP BY host
) AS mem

JOIN

(
    SELECT host, TIME_BUCKET("15 minutes", time) AS time, MAX(usage_user) AS usage_user
    FROM cpu
    WHERE time BETWEEN '2021-05-09T20:00:00Z' AND '2021-05-09T20:59:59.999999999Z'
    GROUP BY host
) AS cpu

ON time, host;
```

```csv
time,host,ratio
2021-05-09T20:00:00.000000000Z,Orient.local,5.494019654799265
2021-05-09T20:15:00.000000000Z,Orient.local,5.9601936294803775
2021-05-09T20:30:00.000000000Z,Orient.local,7.160120423384796
2021-05-09T20:45:00.000000000Z,Orient.local,7.345712415493132
2021-05-09T20:00:00.000000000Z,tortuga,3.4246697123810237
2021-05-09T20:15:00.000000000Z,tortuga,13.215366835810805
2021-05-09T20:30:00.000000000Z,tortuga,9.414764778954357
2021-05-09T20:45:00.000000000Z,tortuga,11.53822837788286
```

## 1: Dimension Table

### TSM/Flux

(query in `join-1-query.flux`)

```console
$ flux execute @join-1-query.flux
Result: _result
Table: keys: [host]
           host:string                      _time:time          address:string            used_percent:float  
----------------------  ------------------------------  ----------------------  ----------------------------  
          Orient.local  2021-05-09T20:15:00.000000000Z                10.0.2.2             50.92167854309082  
          Orient.local  2021-05-09T20:30:00.000000000Z                10.0.2.2             51.76624059677124  
          Orient.local  2021-05-09T20:45:00.000000000Z                10.0.2.2             54.20064926147461  
          Orient.local  2021-05-09T20:59:59.999999999Z                10.0.2.2             55.39344549179077  
Table: keys: [host]
           host:string                      _time:time          address:string            used_percent:float  
----------------------  ------------------------------  ----------------------  ----------------------------  
               tortuga  2021-05-09T20:15:00.000000000Z                10.0.2.1            2.2699786737846277  
               tortuga  2021-05-09T20:30:00.000000000Z                10.0.2.1            2.2718171406270593  
               tortuga  2021-05-09T20:45:00.000000000Z                10.0.2.1            2.2660651057537096  
               tortuga  2021-05-09T20:59:59.999999999Z                10.0.2.1             2.380577926602579
```

### IOx/SQL

```sql
SELECT mem.time AS time, mem.host AS host, host_address.address AS address, mem.used_percent AS used_percent
FROM

(
    SELECT host, TIME_BUCKET("15 minutes", time) AS time, MAX(used_percent) AS used_percent
    FROM mem
    WHERE time BETWEEN '2021-05-09T20:00:00Z' AND '2021-05-09T20:59:59.999999999Z'
    GROUP BY host
) AS mem

JOIN host_address

ON host;
```

```csv
time,host,address,used_percent
2021-05-09T20:00:00.000000000Z,Orient.local,10.0.2.2,5.494019654799265
2021-05-09T20:15:00.000000000Z,Orient.local,10.0.2.2,5.9601936294803775
2021-05-09T20:30:00.000000000Z,Orient.local,10.0.2.2,7.160120423384796
2021-05-09T20:45:00.000000000Z,Orient.local,10.0.2.2,7.345712415493132
2021-05-09T20:00:00.000000000Z,tortuga,10.0.2.1,3.4246697123810237
2021-05-09T20:15:00.000000000Z,tortuga,10.0.2.1,13.215366835810805
2021-05-09T20:30:00.000000000Z,tortuga,10.0.2.1,9.414764778954357
2021-05-09T20:45:00.000000000Z,tortuga,10.0.2.1,11.53822837788286
```

## 2: Time-shift

### TSM/Flux

(query in `join-2-query.flux`)

```console
$ flux execute @join-2-query.flux
Result: _result
Table: keys: [host]
           host:string                      _time:time  projected_used_percent:float            used_percent:float  
----------------------  ------------------------------  ----------------------------  ----------------------------  
          Orient.local  2021-05-09T20:20:00.000000000Z             49.23217296600342             51.36157274246216  
          Orient.local  2021-05-09T20:30:00.000000000Z             51.36157274246216             51.76624059677124  
          Orient.local  2021-05-09T20:40:00.000000000Z             51.76624059677124             54.20064926147461  
          Orient.local  2021-05-09T20:50:00.000000000Z             54.20064926147461             53.91353368759155  
Table: keys: [host]
           host:string                      _time:time  projected_used_percent:float            used_percent:float  
----------------------  ------------------------------  ----------------------------  ----------------------------  
               tortuga  2021-05-09T20:20:00.000000000Z             2.256357030018098            2.2718171406270593  
               tortuga  2021-05-09T20:30:00.000000000Z            2.2718171406270593             2.254967561678439  
               tortuga  2021-05-09T20:40:00.000000000Z             2.254967561678439            2.2660651057537096  
               tortuga  2021-05-09T20:50:00.000000000Z            2.2660651057537096            2.3352108751806004  
```

### IOx/SQL

```sql
SELECT mem.time AS time, mem.host AS host, mem.used_percent AS used_percent, projected.used_percent AS projected_used_percent, 
FROM

(
    SELECT host, TIME_BUCKET("10 minutes", time) AS time, MAX(used_percent) AS used_percent
    FROM mem
    WHERE time BETWEEN '2021-05-09T20:00:00Z' AND '2021-05-09T20:59:59.999999999Z'
    GROUP BY host
) AS mem

JOIN

(
    SELECT host, TIME_BUCKET("10 minutes", time) + INTERVAL '10' minute AS time, MAX(used_percent) AS used_percent
    FROM mem
    WHERE time BETWEEN '2021-05-09T20:00:00Z' AND '2021-05-09T20:59:59.999999999Z'
    GROUP BY host
) AS projected

ON time, host;
```

```csv
time,host,used_percent,projected_used_percent
2021-05-09T20:20:00.000000000Z,Orient.local,51.36157274246216,49.23217296600342
2021-05-09T20:30:00.000000000Z,Orient.local,51.76624059677124,51.36157274246216
2021-05-09T20:40:00.000000000Z,Orient.local,54.20064926147461,51.76624059677124
2021-05-09T20:50:00.000000000Z,Orient.local,53.91353368759155,54.20064926147461
2021-05-09T20:20:00.000000000Z,tortuga,2.2718171406270593,2.256357030018098
2021-05-09T20:30:00.000000000Z,tortuga,2.254967561678439,2.2718171406270593
2021-05-09T20:40:00.000000000Z,tortuga,2.2660651057537096,2.254967561678439
2021-05-09T20:50:00.000000000Z,tortuga,2.3352108751806004,2.2660651057537096
```

## Annotation Overlay

TODO

