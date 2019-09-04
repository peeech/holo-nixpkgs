
import argparse
import json
import requests
import retry
import subprocess
import os
import sys
import logging

KEYFILE = '/var/lib/holochain-conductor/holoportos-key'

log = logging.getLogger('holoportos-initialize')

def holochain_keygen(path):
    try:
        keygen = subprocess.run(['hc', 'keygen', '-np', path, '-q'], capture_output=True)
        keygen.check_returncode()
    except Exception as exc:
        log.error(f"Failed to create Agent key, w/ stdout {keygen.stdout}")
        raise
    return keygen \
        .stdout \
        .split(b'\n')[0] \
        .decode('utf-8')

HOLO_INIT_KEY = "wbfGXvzmLk83bUmR"

def zato_request(endpoint, payload):
    return requests.post('http://proxy.holohost.net/zato' + endpoint,
            headers={'Holo-Init': HOLO_INIT_KEY},
            json=payload).json()

def zato_setup_dns(public_key):
    return zato_request('/holo-init-cloudflare-dns-create', {'pubkey': public_key})

def zato_setup_zerotier(zerotier_address):
    return zato_request('/holo-zt-auth', {'member_id': zerotier_address})

def zato_setup_zerotier_address():
    return zato_setup_zerotier(zerotier_address())

def zato_setup_proxy(public_key, ipv4):
    return zato_request('/holo-init-proxy-service-create', {
        'name': public_key + '.holohost.net',
        'protocol': 'http',
        'host': ipv4,
        'port': 48080
    })

def zato_setup_proxy_route(public_key, proxy_id):
    return zato_request('/holo-init-proxy-route-create', {
        'name': public_key + '.holohost.net',
        'protocols': ['http', 'https'],
        'hosts': ['*.' + public_key.lower() + '.holohost.net'],
        'service': proxy_id
    })

def zerotier_run(args):
    process = subprocess.run(['zerotier-cli', '-j'] + args, capture_output=True)
    return json.loads(process.stdout)

def zerotier_info():
    return zerotier_run(['info'])

def zerotier_address():
    return zerotier_info()['address']

@retry.retry(IndexError, tries=10, delay=2, backoff=2)
def zerotier_ipv4():
    return zato_setup_zerotier_address()['config']['ipAssignments'][0]

def main(private_key_path):
    log.info(f"Creating HoloPortOS Agent Public/Private key to {private_key_path}[.pub]")
    ipv4 = zerotier_ipv4()
    try:
        public_key = holochain_keygen(private_key_path)
    except Exception as exc:
        log.error(f"Couldn't create key: {exc}")
        raise
    with open(private_key_path + '.pub', 'w') as f:
        print(public_key, file=f)

    try:
        dns = zato_setup_dns(public_key)
    except Exception as exc:
        log.error(f"Couldn't set up DNS for Agent ID {public_key}: {exc}")
        raise
    log.debug(f"Agent ID {public_key} DNS: {dns}")
    try:
        proxy = zato_setup_proxy(public_key, ipv4)
    except Exception as exc:
        log.error(f"Couldn't set up proxy for Agent ID {public_key} w/ IP Address {ipv4}: {exc}")
        raise
    log.debug(f"Agent ID {public_key} proxy: {proxy}")
    try:
        route = zato_setup_proxy_route(public_key, proxy['id'])
    except Exception as exc:
        log.error(f"Couldn't set up proxy route for Agent ID {public_key} w/ proxy result {proxy}: {exc}")
        raise
    log.debug(f"Agent ID {public_key} route: {route}")
    log.info(f"Proxy configured for HoloPortOS at CNAME {route['name']}")

if __name__ == "__main__":
    ap = argparse.ArgumentParser(
        description = "Initialize HoloPortOS Agent keys and Holo services",
        epilog = "" )
    ap.add_argument( '-v', '--verbose', action="count",
                     default=0, 
                     help="Display logging information." )
    ap.add_argument( 'keyfile', nargs="?", default=KEYFILE,
                     help="The HoloPortOS Agent private key file name")
    args = ap.parse_args(sys.argv[1:])
    
    levelmap = {
        0: "WARNING",
        1: "INFO",
        2: "DEBUG",
    }
    logging.basicConfig(
        level	= os.environ.get(
            'LOGLEVEL', (levelmap[args.verbose]
                         if args.verbose in levelmap
                         else 'DEBUG')),
        datefmt	= '%Y-%m-%d %H:%M:%S',
        format	= '%(asctime)s.%(msecs).03d %(threadName)10.10s %(name)-8.8s %(levelname)-8.8s %(funcName)-10.10s %(message)s'
    )
    try:
        main(args.keyfile)
    except Exception as exc:
        log.error(f"Failed to initialize HoloPortOS: {exc}")
        raise
