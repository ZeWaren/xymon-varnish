#!/usr/local/bin/perl

use warnings;
use strict;
use JSON;

use constant XYMON_WWW_ROOT => 'https://mon.example.org';
sub get_graph_html {
        my ($host, $service) = @_;
        '<table summary="'.$service.' Graph"><tr><td><A HREF="'.XYMON_WWW_ROOT.'/xymon-cgi/showgraph.sh?host='.$host.'&amp;service='.$service.'&amp;graph_width=576&amp;graph_height=120&amp;first=1&amp;count=1&amp;disp='.$host.'&amp;action=menu"><IMG BORDER=0 SRC="'.XYMON_WWW_ROOT.'/xymon-cgi/showgraph.sh?host='.$host.'&amp;service='.$service.'&amp;graph_width=576&amp;graph_height=120&amp;first=1&amp;count=1&amp;disp='.$host.'&amp;graph=hourly&amp;action=view" ALT="xymongraph '.$service.'"></A></td><td align="left" valign="top"><a href="'.XYMON_WWW_ROOT.'/xymon-cgi/showgraph.sh?host='.$host.'&amp;service='.$service.'&amp;graph_width=576&amp;graph_height=120&amp;first=1&amp;count=1&amp;disp='.$host.'&amp;graph_start=1350474056&amp;graph_end=1350646856&amp;graph=custom&amp;action=selzoom"><img src="'.XYMON_WWW_ROOT.'/xymon/gifs/zoom.gif" border=0 alt="Zoom graph" style=\'padding: 3px\'></a></td></tr></table>';
}

my $data = `/usr/local/bin/varnishstat -j`;
my $data_full = `/usr/local/bin/varnishstat -1`;
$data = decode_json($data);

my $trends = "
[varnish_backend_connections.rrd]
DS:conn:COUNTER:600:0:U ".$data->{'backend_conn'}->{'value'}."
DS:unhealthy:COUNTER:600:0:U ".$data->{'backend_unhealthy'}->{'value'}."
DS:busy:COUNTER:600:0:U ".$data->{'backend_busy'}->{'value'}."
DS:fail:COUNTER:600:0:U ".$data->{'backend_fail'}->{'value'}."
DS:reuse:COUNTER:600:0:U ".$data->{'backend_reuse'}->{'value'}."
DS:toolate:COUNTER:600:0:U ".$data->{'backend_toolate'}->{'value'}."
DS:retry:COUNTER:600:0:U ".$data->{'backend_retry'}->{'value'}."
DS:recycle:COUNTER:600:0:U ".$data->{'backend_recycle'}->{'value'}."

[varnish_connections.rrd]
DS:conn:COUNTER:600:0:U ".$data->{'client_conn'}->{'value'}."
DS:drop:COUNTER:600:0:U ".$data->{'client_drop'}->{'value'}."

[varnish_requests.rrd]
DS:req:COUNTER:600:0:U ".$data->{'client_req'}->{'value'}."
DS:backend_req:COUNTER:600:0:U ".$data->{'backend_req'}->{'value'}."

[varnish_cache.rrd]
DS:hit:COUNTER:600:0:U ".$data->{'cache_hit'}->{'value'}."
DS:hitpass:COUNTER:600:0:U ".$data->{'cache_hitpass'}->{'value'}."
DS:miss:COUNTER:600:0:U ".$data->{'cache_miss'}->{'value'}."
";

my $host = $ENV{MACHINEDOTS};
my $report_date = `/bin/date`;
my $color = 'clear';
my $service = 'varnishd';

my $sdata = "
<h2>Status</h2>
".$data_full."

<h2>Counters</h2>
".get_graph_html($host, 'varnish_connections')."
".get_graph_html($host, 'varnish_requests')."
".get_graph_html($host, 'varnish_cache')."
".get_graph_html($host, 'varnish_backend_connections')."

";

system( ("$ENV{BB}", "$ENV{BBDISP}", "status $host.$service $color $report_date$sdata\n") );
system( "$ENV{BB} $ENV{BBDISP} 'data $host.trends $trends'\n");