# data_flows
optimising big data flows
## Data prep for transfer
###
- module avail 2>&1 | grep pigz

  
- tar -cvf - post_05/ccam_8_{196101..197212}.nc | pigz -p 16 > ACCESS_8km_saws_post05_1961-1972.tar.gz

### output:chpc/compmech/pigz/2.8

## IRODS connection
log into dtn node to initilaise IRODS service on chpc via cli
```bash
irods
```
