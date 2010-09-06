use strict;
use warnings;
use Test::More tests => 10;
use Plack::App::MicroTemplate;
use Plack::Test;

test_psgi
  app    => Plack::App::MicroTemplate->new( include_path => ['t/tmpl/'] ),
  client => sub {
    my $cb = shift;
    {
        my $req =
        HTTP::Request->new( GET => 'http://localhost/?name=taro' );
        my $res = $cb->($req);
        is $res->code(), 200;
        is $res->content, "Hello, taro.\n";
    }
    {
        my $req =
        HTTP::Request->new( GET => 'http://localhost/index?name=taro' );
        my $res = $cb->($req);
        is $res->code(), 200;
        is $res->content, "Hello, taro.\n";
    }
    {
        my $req =
        HTTP::Request->new( GET => 'http://localhost/index.mt?name=taro' );
        my $res = $cb->($req);
        is $res->code(), 200;
        is $res->content, "Hello, taro.\n";
    }
    {
        my $req =
        HTTP::Request->new( GET => 'http://localhost/foo.mt' );
        my $res = $cb->($req);
        is $res->code(), 200;
        is $res->content, "foo\n";
    }
    {
        my $req =
        HTTP::Request->new( GET => 'http://localhost/foo' );
        my $res = $cb->($req);
        is $res->code(), 200;
        is $res->content, "foo\n";
    }
  };

