#!/usr/bin/env bash

EMAIL=example@example.com
HOLOFUEL_DNA_FILE=https://holo-host.github.io/holofuel/releases/download/0.9.7-alpha1/holofuel.dna.json 
HOLOFUEL_DNA_HASH=QmcqAKFLP6WrjWghWVzrgnoa72EWu211C7Fu2F1FwRMU1k

HOLOFUEL_DEMO_SITE=holofuel-demo.holohost.net

HOLOCHAIN_DNA_DIR=/var/lib/holo-envoy/.holochain/holo/dnas

set -euo pipefail
shopt -s extglob nullglob

PATH=@path@:$PATH

if [ "$(whoami)" != "root" ]; then
  echo "HoloFuel Demo configuration requires root."
  exit 1
fi

PUBKEY=$( cat /var/lib/holochain-conductor/holoportos-key.pub )
if (( $? )); then
  echo "HoloFuel Demo configuration needs you to run holoportos-initialize (eg. generate agent key) first."
  exit 1
fi
echo "Host Agent ID: ${PUBKEY}"

# OK, we're root, and we've got an Agent ID key.  Lets wait 'til holochain-conductor is up
echo -n "The systemd holochain-conductor.service: "
systemctl is-active holochain-conductor.service
if (( $? )); then 
    echo "HoloFuel Demo configuration need holochain-conductor.service to be active."
    exit 1
fi

# But, we have to wait 'til Envoy connects.  The service runs, but we need to see "All connections
# established!", indicating that it has begun communicating with the Holochain conductor (just since
# the last boot)
echo -n "Awaiting holo-envoy ."
while ! journalctl -u holo-envoy.service -b | grep "All connections established!"; do
    sleep 5
    echo -n .
done
echo "Host Envoy:   Running"

# Envoy is up and running.  Let's Get Ready to Rumble!

echo -n "Register as Provider and Host... "
if holo provider register ${EMAIL}
  && holo host   register ${EMAIL}; then
    echo "Successfully registered"
else
    echo "Failed to register"
    exit 1
fi

echo -n "Creating 'holofuel' hApp... "
if ! holo happ create holofuel ${HOLOFUEL_DNA_FILE} ${HOLOFUEL_DNA_HASH}; then
    echo "Failed to create holoful hApp"
    exit 1
fi
echo "Successful; List of hApps:"
holo happ list

# TODO: Get hApp hash from holo happ create
HOLOFUEL_HAPPSTORE_HASH=QmT9sisxtTXKGinCjcxp5nd1JhnbZDPru4sYJYXNSpM8U4
HOLOFUEL_HAPPPROVI_HASH=QmYF8vySWg1UEmDP2zLHBbCg5VZgMe1KcmDAgTiFNmmspJ

echo -n "Registering to provide 'holofuel' hApp... "
if ! holo provider register-app ${HOLOFUEL_HAPPSTORE_HASH} ${HOLOFUEL_DEMO_SITE}
    echo "Failed to provision holoful hApp"
    exit 1
fi
echo "Successful"

echo -n "Enable Hosting of the 'holofuel' hApp... "
if ! holo host enable ${HOLOFUEL_HAPPPROVI_HASH}
    echo "Failed to enable Hosting of the holoful hApp"
    exit 1
fi
echo "Successful"

mkdir -p ${HOLOCHAIN_DNS_DIR}

echo -n "Installing the 'holofuel' hApp... "
if ! holo admin install ${HOLOFUEL_HAPPSTORE_HASH} --directory ${HOLOCHAIN_DNS_DIR}; then
    echo "Failed to install holoful hApp "
    exit 1
fi
echo "Successful; Available DNAs: "
holo admin dna

echo -n "Create ServiceLogger for 'holofuel' hApp... "
if ! holo admin init QmT9sisxtTXKGinCjcxp5nd1JhnbZDPru4sYJYXNSpM8U4 --service-logger servicelogger; then
    echo "Failed to init holoful hApp "
    exit 1
fi
echo "Successful; Available instances: "
holo admin instance

echo "Done; Available interfaces: "
holo admin interface
    

