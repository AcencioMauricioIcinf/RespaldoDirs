Dim dt
dt=now
'output format: yyyymmdd
wscript.echo ((year(dt)*100 + month(dt))*100 + day(dt))