#!/bin/bash

sed -i -e s/validUntil=\"[^\"\]*\"/validUntil=\"2030-01-01T00:00:00\.999Z\"/ /opt/shibboleth-idp/metadata/idp-metadata.xml
