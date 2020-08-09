#!/bin/bash

function config_parser()
{
    set +x
    domain=$1
    needed_key=$2
    find_domain='false'
    cat job.conf | while read line
    do
        if [[ $line == \[$domain\]* ]]
        then
            find_domain='true'
        fi
        if [[ $line == \[* || $line == \#*  || $line == '' ]]
        then
            continue
        fi

        key=`echo $line | awk 'sub("=", "==")' | awk -F== '{print $1}'`
        val=`echo $line | awk 'sub("=", "==")' | awk -F== '{print $2}'`
        # val=`echo $line | awk -F= '{s="";for(i=2;i<=NF;i++)s=s""(i==NF?$i:$i"="); print s}'`
        key=$(trim "$key")
        val=$(trim "$val")
        if [[ $find_domain == true && $needed_key == $key ]]
        then 
            echo $val
            break
        fi
    done
    set -x
}

function trim()
{
    trimmed=$1
    trimmed=${trimmed%% }
    trimmed=${trimmed## }
    echo $trimmed
}
