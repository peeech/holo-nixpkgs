import wormhole

WORMHOLE_ACK = wormhole.util.dict_to_bytes({"answer": {"message_ack": "ok"}})
WORMHOLE_APPID = 'lothar.com/wormhole/text-or-file-xfer'
WORMHOLE_RELAY_URL = 'ws://relay.magic-wormhole.io:4000/v1'

REVERSE_SEND_INSTRUCTIONS = \
    """HPOS state was not found. On the other computer, download hpos-state.json
at <https://quickstart.holo.host>, install Magic Wormhole, and run:

wormhole send --code {} --text - < hpos-state.json
"""
