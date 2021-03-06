#!/usr/bin/perl
use IO::Socket;
use strict;

my $sock = new IO::Socket::INET (
    LocalHost => '',
    LocalPort => '9337',
    Proto => 'tcp',
    Listen => 3,
    Reuse => 1
);
die "Could not create socket: $!\n" unless $sock;

while (my $client = $sock->accept()) {
    print "Accepting Requests on Parent\n";
    my $pid = fork();
    if($pid == 0){
        my $request = <$client>;
        print "<Forked Request on Child\n";
        print "\t$request";
        print $client "File stored", "\n";
        print $client "Test", "\n";
        if($request =~ /^([^\|]+)\|([^\|]+)\|([^\|]+)(?:\|([^\|]+))\n$/){
            my $username = $1;
            my $password = $2;
            my $type = $3;
            my $lines = $4;
            print "\tIncoming file from $username\n";
            open(my $handle, ">", "upload/$username") or die "Can't open: $!";
            while(defined(<$client>)){
                print $handle $_;
            }
            print "\tFile stored\n";
        }
        print ">End Request\n";
        exit(0);
    }
    else{
        
    }
}

close($sock);
