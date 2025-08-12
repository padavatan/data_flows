# data_flows
Optimising big data flows

## Data prep for transfer

1. Compress data files in parallel: To do this, you need to find, load and run pigz fro compression

```bash
module avail 2>&1 | grep -i pigz # find
module load chpc/compmech/pigz/2.8                    # load
tar -cvf - post_05/ccam_8_{196101..197212}.nc | pigz -p 16 > ACCESS_8km_saws_post05_1961-1972.tar.gz # compress
```

## Establish IRODS connection
log into dtn node to initilaise IRODS service on chpc via cli
```bash
irods
```
