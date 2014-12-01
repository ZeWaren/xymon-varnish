xymon-varnish
=============
xymon-varnish is a perl script that you can use to monitor a varnish installation and graph its counters into your BB/Hobbit/Xymon server.

![A xymon page featuring some varnish counters](https://raw.github.com/ZeWaren/xymon-varnish/master/example_graphs/xymon_page.png "A xymon page featuring some varnish counters")

How it works
------------

`xymon_varnish.pl` connects to your varnish server to get the needed data by issuing this command:

+ `/usr/local/bin/varnishstat -1`

The values are then posted into the host's trends data channel.

Some HTML code is also posted as a status, in order to be able to see the graphs alone on one page (ugly but works). If you only want the graphs to appear in the trends page, you can remove the line that send the status and then set the `TRENDS` variable in `xymonserver.cfg`.

Installation
------------
+ Copy `xymon_varnish.pl` somewhere executable by your xymon client (typically `$HOBBITCLIENTHOME/ext` or `$XYMONCLIENTHOME/ext`). Set the permissions accordingly.
 
+ Edit the script to provide the path to the varnishstat executable (which might not be in /usr/local/bin on your system).
```
my $data = `/usr/local/bin/varnishstat -j`;
my $data_full = `/usr/local/bin/varnishstat -1`;
```

+ Makes xymon execute the script periodically.
In `hobbitlaunch.cfg` (Hobbit)
```
[varnishd]
    ENVFILE $HOBBITCLIENTHOME/etc/hobbitclient.cfg
    CMD $HOBBITCLIENTHOME/ext/varnishd.pl
    LOGFILE $HOBBITCLIENTHOME/logs/hobbit-varnishd.log
    INTERVAL 3m
```
or in `clientlaunch.cfg` (Xymon)
```
[varnishd]
    ENVFILE $XYMONCLIENTHOME/etc/xymonclient.cfg
    CMD $XYMONCLIENTHOME/ext/varnishd.pl
    LOGFILE $XYMONCLIENTLOGS/xymon-varnishd.log
    INTERVAL 3m
```

+ Append or include the provided file to `graphs.cfg`.

+ Restart xymon-client.

Sample graphs:
--------------

![Varnish Connections](https://raw.github.com/ZeWaren/xymon-varnish/master/example_graphs/varnish_connections.png "Varnish Connections")

![Varnish Requests](https://raw.github.com/ZeWaren/xymon-varnish/master/example_graphs/varnish_requests.png "Varnish Requests")

![Varnish Cache](https://raw.github.com/ZeWaren/xymon-varnish/master/example_graphs/varnish_cache.png "Varnish Cache")

![Varnish Backend Connections](https://raw.github.com/ZeWaren/xymon-varnish/master/example_graphs/varnish_backend_connections.png "Varnish Backend Connections")

Credits:
--------

xymon-varnish was written in February 2014 by: ZeWaren / Erwan Martin <<public@fzwte.net>>.

It is licensed under the MIT License.
