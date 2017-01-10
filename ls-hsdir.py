#!/usr/bin/env python

import sys
import datetime

from stem.control import Controller

now = datetime.datetime.utcnow()

def print_hsdir(controller, name):
    x = controller.get_hidden_service_descriptor(name)
    age = now - x.published
    print "v=%d age=%d pub(%s) %s" % (
        x.version,
        age.total_seconds(),
        x.published,
        name
    )

with Controller.from_port(port = 9051) as controller:
    controller.authenticate()
    for name in sys.argv[1:]:
        if name.endswith('.onion'):
            name = name[0:-6]
        print_hsdir(controller, name)
