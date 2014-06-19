#!/usr/bin/env bash
# -*- coding: utf-8 -*-

ORANGE="#cb4b16"
THRESHOLD="80"

VOLUME_STR=$(amixer get Master | grep 'Mono:' -A 1 | cut -d ' ' -f 7)

# Extract number.
VALUE=$(sed "s/[^0-9]//g" <<< ${VOLUME_STR})
                 
MUTED=$(amixer get Master | grep 'Mono:' -A 1 | cut -d ' ' -f 8)
if [ ${MUTED} == "[off]" ]; then
    echo "<fc=${ORANGE}>--% </fc>"
else
    if (( ${VALUE} > ${THRESHOLD} )); then
        echo "<fc=${ORANGE}>"${VALUE}"% </fc>"
    else
        # Extra whitespace fixes `%` symbol corruption
        echo ${VALUE}"% "
    fi
fi