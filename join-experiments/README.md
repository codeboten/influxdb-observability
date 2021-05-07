# Join Experiments

## 0: Math Across Measurements

```console
$ flux execute @join-0-query.flux
Result: _result
Table: keys: [host]
           host:string           _field:string                      _time:time                  _value:float
----------------------  ----------------------  ------------------------------  ----------------------------
          Orient.local                   ratio  2021-05-06T20:45:00.000000000Z             8.394017326377785
          Orient.local                   ratio  2021-05-06T21:00:00.000000000Z             8.371453745608502
          Orient.local                   ratio  2021-05-06T21:15:00.000000000Z             8.281004135693527
          Orient.local                   ratio  2021-05-06T21:30:00.000000000Z             8.241279788903558
          Orient.local                   ratio  2021-05-06T21:45:00.000000000Z             8.151742881080438
          Orient.local                   ratio  2021-05-06T22:00:00.000000000Z             8.378929569012412
          Orient.local                   ratio  2021-05-06T22:15:00.000000000Z              8.12409622842869
          Orient.local                   ratio  2021-05-06T22:30:00.000000000Z             8.234415119835546
          Orient.local                   ratio  2021-05-06T22:45:00.000000000Z              7.85400214644481
          Orient.local                   ratio  2021-05-06T23:00:00.000000000Z             8.238329629926007
          Orient.local                   ratio  2021-05-06T23:15:00.000000000Z             4.329113294756181
          Orient.local                   ratio  2021-05-06T23:30:00.000000000Z            3.5062438979980377
          Orient.local                   ratio  2021-05-06T23:45:00.000000000Z             6.880645811172634
Table: keys: [host]
           host:string           _field:string                      _time:time                  _value:float
----------------------  ----------------------  ------------------------------  ----------------------------
               tortuga                   ratio  2021-05-06T20:45:00.000000000Z            11.590849659135456
               tortuga                   ratio  2021-05-06T21:00:00.000000000Z            0.3047380480497355
               tortuga                   ratio  2021-05-06T21:15:00.000000000Z            12.506491343351165
               tortuga                   ratio  2021-05-06T21:30:00.000000000Z            14.095222234865217
               tortuga                   ratio  2021-05-06T21:45:00.000000000Z            13.116780141855875
               tortuga                   ratio  2021-05-06T22:00:00.000000000Z              8.34118156239857
               tortuga                   ratio  2021-05-06T22:15:00.000000000Z             16.71257654317815
               tortuga                   ratio  2021-05-06T22:30:00.000000000Z           0.08245493964653217
               tortuga                   ratio  2021-05-06T22:45:00.000000000Z            0.0810102726039963
               tortuga                   ratio  2021-05-06T23:00:00.000000000Z           0.10262594737267154
               tortuga                   ratio  2021-05-06T23:15:00.000000000Z           0.05865793382460148
               tortuga                   ratio  2021-05-06T23:30:00.000000000Z           0.13288367566851245
               tortuga                   ratio  2021-05-06T23:45:00.000000000Z            0.1517681504416651
```

## 1: Dimension Table

```console
$ flux execute @join-1-query.flux
Result: _result
Table: keys: [host]
           host:string           _field:string                      _time:time                  _value:float          address:string
----------------------  ----------------------  ------------------------------  ----------------------------  ----------------------
          Orient.local            used_percent  2021-05-06T20:45:00.000000000Z             57.95043706893921                10.0.2.2
          Orient.local            used_percent  2021-05-06T21:00:00.000000000Z              56.3433051109314                10.0.2.2
          Orient.local            used_percent  2021-05-06T21:15:00.000000000Z             56.53780698776245                10.0.2.2
          Orient.local            used_percent  2021-05-06T21:30:00.000000000Z             56.52806758880615                10.0.2.2
          Orient.local            used_percent  2021-05-06T21:45:00.000000000Z             56.50320053100586                10.0.2.2
          Orient.local            used_percent  2021-05-06T22:00:00.000000000Z             57.17728137969971                10.0.2.2
          Orient.local            used_percent  2021-05-06T22:15:00.000000000Z            57.043254375457764                10.0.2.2
          Orient.local            used_percent  2021-05-06T22:30:00.000000000Z             56.89706802368164                10.0.2.2
          Orient.local            used_percent  2021-05-06T22:45:00.000000000Z            57.528066635131836                10.0.2.2
          Orient.local            used_percent  2021-05-06T23:00:00.000000000Z             58.41168165206909                10.0.2.2
          Orient.local            used_percent  2021-05-06T23:15:00.000000000Z             58.48459005355835                10.0.2.2
          Orient.local            used_percent  2021-05-06T23:30:00.000000000Z             58.49558115005493                10.0.2.2
          Orient.local            used_percent  2021-05-06T23:45:00.000000000Z             58.46102237701416                10.0.2.2
Table: keys: [host]
           host:string           _field:string                      _time:time                  _value:float          address:string
----------------------  ----------------------  ------------------------------  ----------------------------  ----------------------
               tortuga            used_percent  2021-05-06T20:45:00.000000000Z            1.7390622144460535                10.0.2.1
               tortuga            used_percent  2021-05-06T21:00:00.000000000Z             11.94656990627581                10.0.2.1
               tortuga            used_percent  2021-05-06T21:15:00.000000000Z              1.71942763127078                10.0.2.1
               tortuga            used_percent  2021-05-06T21:30:00.000000000Z             1.717801528585065                10.0.2.1
               tortuga            used_percent  2021-05-06T21:45:00.000000000Z            1.7221155547400773                10.0.2.1
               tortuga            used_percent  2021-05-06T22:00:00.000000000Z             1.720798896968435                10.0.2.1
               tortuga            used_percent  2021-05-06T22:15:00.000000000Z            1.7237537925204616                10.0.2.1
               tortuga            used_percent  2021-05-06T22:30:00.000000000Z             7.948129023238949                10.0.2.1
               tortuga            used_percent  2021-05-06T22:45:00.000000000Z            3.8013487429619484                10.0.2.1
               tortuga            used_percent  2021-05-06T23:00:00.000000000Z             5.402750443477035                10.0.2.1
               tortuga            used_percent  2021-05-06T23:15:00.000000000Z            4.8402524002610505                10.0.2.1
               tortuga            used_percent  2021-05-06T23:30:00.000000000Z             2.982314798432437                10.0.2.1
               tortuga            used_percent  2021-05-06T23:45:00.000000000Z            4.1656078796567515                10.0.2.1
```

## 2: Time-shift

```console
$ flux execute @join-2-query.flux
Result: _result
Table: keys: [host]
           host:string           _field:string     _measurement:string                      _time:time                  _value:float         projected_value:float
----------------------  ----------------------  ----------------------  ------------------------------  ----------------------------  ----------------------------
          Orient.local            used_percent                     mem  2021-05-06T21:45:00.000000000Z             56.50320053100586             57.95043706893921
          Orient.local            used_percent                     mem  2021-05-06T22:00:00.000000000Z             57.17728137969971              56.3433051109314
          Orient.local            used_percent                     mem  2021-05-06T22:15:00.000000000Z            57.043254375457764             56.53780698776245
          Orient.local            used_percent                     mem  2021-05-06T22:30:00.000000000Z             56.89706802368164             56.52806758880615
          Orient.local            used_percent                     mem  2021-05-06T22:45:00.000000000Z            57.528066635131836             56.50320053100586
          Orient.local            used_percent                     mem  2021-05-06T23:00:00.000000000Z             58.41168165206909             57.17728137969971
          Orient.local            used_percent                     mem  2021-05-06T23:15:00.000000000Z             58.48459005355835            57.043254375457764
          Orient.local            used_percent                     mem  2021-05-06T23:30:00.000000000Z             58.49558115005493             56.89706802368164
          Orient.local            used_percent                     mem  2021-05-06T23:45:00.000000000Z             58.46102237701416            57.528066635131836
Table: keys: [host]
           host:string           _field:string     _measurement:string                      _time:time                  _value:float         projected_value:float
----------------------  ----------------------  ----------------------  ------------------------------  ----------------------------  ----------------------------
               tortuga            used_percent                     mem  2021-05-06T21:45:00.000000000Z            1.7221155547400773            1.7390622144460535
               tortuga            used_percent                     mem  2021-05-06T22:00:00.000000000Z             1.720798896968435             11.94656990627581
               tortuga            used_percent                     mem  2021-05-06T22:15:00.000000000Z            1.7237537925204616              1.71942763127078
               tortuga            used_percent                     mem  2021-05-06T22:30:00.000000000Z             7.948129023238949             1.717801528585065
               tortuga            used_percent                     mem  2021-05-06T22:45:00.000000000Z            3.8013487429619484            1.7221155547400773
               tortuga            used_percent                     mem  2021-05-06T23:00:00.000000000Z             5.402750443477035             1.720798896968435
               tortuga            used_percent                     mem  2021-05-06T23:15:00.000000000Z            4.8402524002610505            1.7237537925204616
               tortuga            used_percent                     mem  2021-05-06T23:30:00.000000000Z             2.982314798432437             7.948129023238949
               tortuga            used_percent                     mem  2021-05-06T23:45:00.000000000Z            4.1656078796567515            3.8013487429619484
```

## Annotation Overlay

TODO

