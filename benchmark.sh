#!/bin/bash

hostname=${1-"reqres.in"}
post_api_file=${2-"postAPI.csv"}
get_api_file=${3-"getAPI.csv"}
count=${4-5}
out_file_name="benchmark-results.csv"
[ "$5" == "-v" ] && VERBOSE=1

output() {
	[ "$VERBOSE" == 1 ] && echo $2 "$1"
}

usage() {
	echo "Usage: $0 <hostname> <post api file> <get api file> <number of requests to do per URL> [-v]"  >&2
}

die() {
	echo "$1" >&2
	[ "$2" != "" ] && exit $2
	exit 1
}

[ ! -r "$post_api_file" ] && die "ERROR: File '$post_api_file' does not exist or is not readable."
[ ! -r "$get_api_file" ] && die "ERROR: File '$get_api_file' does not exist or is not readable."

main () {

        print_header
        while IFS=, read -r api body; do
            for (( j = 1 ; j <= $count; j++ )) 
            do
                make_post_request $hostname $api $body;
             done
        done < $post_api_file

        while IFS=, read -r api body; do
            for (( j = 1 ; j <= $count; j++ )) 
            do 
                make_get_request $hostname $api
            done
        done < $get_api_file
}

print_header () {
  headers="method,code,time_total,time_connect,time_appconnect,time_starttransfer,url_effective"
  output $headers
  if [ ! -f "$out_file_name" ]; then
    echo $headers >> $out_file_name
  fi

  
}

make_post_request() {
  local hostname=$1
  local api=$2
  local data=${3-"{}"}
  res=$(curl \
    -s -X POST \
    --write-out "POST,%{http_code},%{time_total},%{time_connect},%{time_appconnect},%{time_starttransfer},%{url_effective}\n" \
    --silent \
    -H 'Content-Type: application/json' \
    --output /dev/null \
    --data ${data} \
    https://${hostname}${api})

    output $res
    echo $res >> $out_file_name
}

make_get_request() {
  local hostname=$1
  local api=$2
  res=$(curl \
    -s -X GET \
    --write-out "GET,%{http_code},%{time_total},%{time_connect},%{time_appconnect},%{time_starttransfer},%{url_effective}\n" \
    --silent \
    -H 'Content-Type: application/json' \
    --output /dev/null \
    https://${hostname}${api})

    output $res
    echo $res >> ${out_file_name}
}

main "$@"