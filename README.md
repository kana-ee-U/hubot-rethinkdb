Hubot Rethinkdb Adapter
----------------------

Description
===========
This is an adapter for Hubot that lets you communicate with Hubot via Rethinkdb.



Installation and Setup
======================

### Requirements


### Installation


Usage
=====
Run Hubot with the following command:

    $HUBOT_PATH/bin/hubot -a rethinkdb

Prior to this you may want to use an env var to set another host than localhost.

Two ways :
``` bash
# Set only the rethink db server host
export RETHINKDB_HOST=(your host IP address)  
```
or
``` bash
# Set an entire rethinkdbdash config file
export RETHINKDBDASH_CONFIG_FILE=(Path to a valid rethinkdbdash config file)
```
see https://github.com/neumino/rethinkdbdash for more information

License
=======
Licensed under the LGPL v3 License. See LICENSE for more info.
