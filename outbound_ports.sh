# !/bin/bash

host="portquiz.net"
port_start=0
port_end=0
port_regex='^(6553[0-5]|655[0-2][0-9]|65[0-4][0-9]{2}|6[0-4][0-9]{3}|[1-5][0-9]{4}|[[1-9][0-9]{1,3}|[0-9])$'
port_range_regex='-p'
port_all_regex='-pa'

if [[ ( $# = 1 ) && ( $1 =~ $port_all_regex )  ]]
then
    let port_start=1
    let port_end=65535
    echo "Matches all ports regex"
elif [[ ( $# = 2 ) && ( $1 =~ $port_range_regex ) && ( $2 =~ $port_regex ) ]]
then
    let port_start=$2
    let port_end=$2
    echo "Matches single port"
elif [[ ( $# = 3 ) && ( $1 =~ $port_range_regex ) && ( $2 =~ $port_regex ) && ( $3 =~ $port_regex ) ]]
then
    if [[ $3 -gt $2 ]]
    then
        let port_start=$2
        let port_end=$3
    else
        let port_start=$3
        let port_end=$2
    fi
else
    usage
fi

echo "Scanning ports [$port_start-$port_end] on host: $host"

while [[ $port_start -le $port_end ]]
do
    # positive only
    #(nc -w 1 -z $host "$port_start" &> /dev/null && echo "> port: $port_start [success]") &
    # negative only
    #(nc -w 1 -z $host "$port_start" &> /dev/null &&  echo >/dev/null || echo "> port: $port_start [failed]") &

    # both
    (nc -w 1 -z $host "$port_start" &> /dev/null &&  echo "> port: $port_start [success]" || echo "> port: $port_start [failed]") &
    let port_start+=1
    wait
done

function usage
{
    echo "Outbound_ports 0.0.0 (http::/adventurous.pl)"
    echo "Usage: outbound_ports [Options]"
    echo "PORT RANGES:"
    echo "      -p [range_begin or port] [range_end]: scan specific port or port ranges"
    echo "          e.g. -p 21 ; -p 1 21"
    echo "      -pa : scan all ports"
}
