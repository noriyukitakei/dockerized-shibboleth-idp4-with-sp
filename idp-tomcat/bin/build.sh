#!/bin/bash
 
set EXP Installation Directory: [/opt/shibboleth-idp]
expect -c "
spawn /opt/shibboleth-idp/bin/build.sh
expect $EXP
send \"\n\"
expect "
