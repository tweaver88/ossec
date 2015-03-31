#!/bin/bash

OSSECDIR="/var/ossec"
OSSECSERVER="192.168.0.1"

OSSECSERVERIP=$(dig ${OSSECSERVER} | awk '/ANSWER/{getline; print}' | tr '\n' ' ' | awk '{ print $5 }')
INSTANCE_ID=$(curl http://169.254.169.254/latest/meta-data/instance-id)

echo SERVERIP = ${OSSECSERVERIP}

if [ ! -f ${OSSECDIR}/etc/client.keys ]; then
        ${OSSECDIR}/bin/agent-auth -m $OSSECSERVERIP -A $INSTANCE_ID
fi

sed -i "s/<server-ip>.*<\/server-ip>/<server-ip>${OSSECSERVERIP}<\/server-ip>/" ../etc/ossec.conf

/etc/init.d/ossec restart

exit 0