# API Benchmark Test

This script can be used to do performance benchmark testing for the rest api's.

### Dependecy Installation
```sh
$ apt install curl
```

### Usage
```
benchmark.sh <hostname> <post api file> <get api file> <number of requests to do per URL> [-v]
```

## Output

After successfull run script will generate benchmark-results.csv with below columns

```
method              Http method GET/POST.

code                The  numerical  response  code that was found 
                    in the last retrieved HTTP(S) or FTP(s) transfer.
                    
time_total          The total time, in seconds, that the full operation last.

time_connect        The time, in seconds, it took from the start until 
                    the TCP connect to the remote host (or proxy) was 
                    completed.
                    
time_appconnect     The time, in seconds, it took from the start until 
                    the SSL/SSH/etc connect/handshake to the remote host 
                    was completed.

time_starttransfer  The time, in seconds, it took from the start until the
                    first byte was just about to be transferred.
```