#!/usr/bin/env bash

CONTAINERS=$(docker ps | grep -v "CONTAINER\|registry" | awk '{print $1}')
OLDER_THAN=${1:-2}
NOW=$(date --date='now' +"%s")
LOG_FILE="/var/log/docker-jc"

for EACH_CONTAINER in ${CONTAINERS}; do
    CREATION_DATE=$(docker inspect --format='{{.Created}}' "${EACH_CONTAINER}")
    CREATED_SINCE=$(date --date="${CREATION_DATE}" +"%s")
    CONTAINER_LIFE_TIME=$((NOW - CREATED_SINCE))
    if [[ ${CONTAINER_LIFE_TIME} -gt $((60*60*${OLDER_THAN})) ]]; then
        docker rm "${EACH_CONTAINER}"
        echo "$(date): ${EACH_CONTAINER} removed." >> ${LOG_FILE}
    fi
done

exit 0
