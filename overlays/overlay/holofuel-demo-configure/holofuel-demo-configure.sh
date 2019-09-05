#!/usr/bin/env bash

# HOLOFUEL_APP_UI_PATH is an environment variable that contains the target UI directory

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

KEY=/var/lib/holochain-conductor/holoportos-key

if ! PUBKEY=$( cat ${KEY}.pub ); then
  echo "HoloFuel Demo runng holoportos-initialize (eg. generate agent key) first."
  systemctl stop holochain-conductor.service # stop, for memory and b/c it requires key to run
  holoportos-initialize -v ${KEY} || ( echo "HoloFuel Demo failed to initialize Agent key"; exit 1 )
  systemctl start holochain-conductor.service
  PUBKEY=$( cat ${KEY}.pub )
fi
echo "Host Agent ID:        ${PUBKEY}"

# OK, we're root, and we've got an Agent ID key.  Lets wait 'til holochain-conductor is up
echo -n "Holochain Conductor:  "
if ! systemctl is-active holochain-conductor.service; then
    echo "HoloFuel Demo configuration need holochain-conductor.service to be active."
    exit 1
fi

# But, we have to wait 'til Envoy connects.  The service runs, but we need to see "All connections
# established!", indicating that it has begun communicating with the Holochain conductor (just since
# the last boot)
echo -n "Awaiting holo-envoy..."
while ! journalctl -u holo-envoy.service -b | grep "All connections established!"; do
    sleep 5
    echo -n .
done
echo "Running"

# Envoy is up and running.  Let's Get Ready to Rumble!

echo -n "Register as Provider and Host... "
if holo provider register ${EMAIL} \
  && holo host   register ${EMAIL}; then
    echo "Successfully registered"
else
    echo "Failed to register"
    exit 1
fi

echo -n "The 'holofuel' hApp... "
if ! holo happ create holofuel ${HOLOFUEL_DNA_FILE} ${HOLOFUEL_DNA_HASH}; then
    echo "Failed to create holoful hApp"
    exit 1
fi
echo "Created Successfully; List of hApps:"
holo happ list

# TODO: Get hApp hash from holo happ create
HOLOFUEL_HAPPSTORE_HASH=QmT9sisxtTXKGinCjcxp5nd1JhnbZDPru4sYJYXNSpM8U4
HOLOFUEL_HAPPPROVI_HASH=QmYF8vySWg1UEmDP2zLHBbCg5VZgMe1KcmDAgTiFNmmspJ

echo -n "Provider registering..."
if ! holo provider register-app ${HOLOFUEL_HAPPSTORE_HASH} ${HOLOFUEL_DEMO_SITE}; then
    echo "Failed to provision holoful hApp"
    exit 1
fi
echo "Successfully provisioning 'holofuel' hApp"

echo -n "Enabling Hosting...    "
if ! holo host enable ${HOLOFUEL_HAPPPROVI_HASH}; then
    echo "Failed to enable Hosting of the holoful hApp"
    exit 1
fi
echo "Successful"

# TODO: install holo-envoy as a non-root user, w/ home dir...
HOLOENVOY_HOME=/var/lib/holo-envoy
HOLOENVOY_DNA_DIR=${HOLOENVOY_HOME}/.holochain/holo/dnas
HOLOENVOY_UIS_DIR=${HOLOENVOY_HOME}/.holochain/holo/ui-store

mkdir -p ${HOLOENVOY_DNA_DIR}
mkdir -p ${HOLOENVOY_UIS_DIR}
ln -fs   ${HOLOENVOY_HOME}/.holochain /root/ # /root/.holochain -> /var/lib/holo-envoy/.holochain

echo -n "Installing the hApp... "
if ! holo admin install ${HOLOFUEL_HAPPSTORE_HASH} --directory ${HOLOENVOY_DNA_DIR}; then
    echo "Failed to install holoful hApp "
    exit 1
fi
echo "Successfully installed 'holofuel'; Available DNAs: "
holo admin dna

echo -n "Create ServiceLogger..."
if ! holo admin init QmT9sisxtTXKGinCjcxp5nd1JhnbZDPru4sYJYXNSpM8U4 --service-logger servicelogger; then
    echo "Failed to init holoful hApp "
    exit 1
fi
echo "Successfully created for 'holofuel' hApp...; Available instances: "
holo admin instance

echo "Done; Available interfaces: "
holo admin interface

# Finally, link the HoloFuel UI (provided by an environment variable) from the envoy UI dir,
# at the hApp provider's hash
ln -fs ${HOLOFUEL_APP_UI_PATH} ${HOLOENVOY_UIS_DIR}/${HOLOFUEL_HAPPPROVI_HASH}

echo "HoloFuel UI activated: http://${HOLOFUEL_HAPPPROVI_HASH}.${PUBKEY}.holohost.net"
