package Plack::App::MicroTemplate;
use strict;
use warnings;
use parent qw( Plack::Component );
use 5.00800;
our $VERSION = '0.01';

use Plack::Util::Accessor qw/mt content_type/;

use Plack::Request;
use Text::MicroTemplate::File;

sub new {
    my $class = shift;
    my %args = @_ == 1 ? %{$_[0]} : @_;
    my $content_type = delete $args{content_type} || 'text/html; charset=utf-8';
    my $mt = Text::MicroTemplate::File->new(%args);
    bless {
        content_type => $content_type,
        mt           => $mt,
    }, $class;
}

sub call {
    my ($self, $env) = @_;
    my $req = $self->make_request($env);
    my $path = $self->find_template($env);
    my $out = $self->mt->render_file($path, $req);

    return [
        200,
        [
            'Content-Type'   => $self->content_type,
            'Content-Length' => length($out)
        ],
        [$out]
    ];
}

sub find_template {
    my ($self, $env) = @_;

        my $path = $env->{PATH_INFO};
           $path .= 'index.mt' if $path =~ m{/$};
           $path =~ s{^/}{};
    return $path if $self->_exists($path);
           $path .= '.mt';
           $path;
}

sub _exists {
    my ($self, $fname) = @_;
    for my $dir (@{$self->mt->include_path}) {
        return 1 if -f "$dir/$fname";
    }
    return 0;
}

# this is public method. you can override this method to use your own request class.
sub make_request {
    my ($self, $env) = @_;
    Plack::Request->new($env);
}

1;
__END__

=encoding utf8

=head1 NAME

Plack::App::MicroTemplate -

=head1 SYNOPSIS

  use Plack::App::MicroTemplate;

=head1 DESCRIPTION

Plack::App::MicroTemplate is

=head1 AUTHOR

Tokuhiro Matsuno E<lt>tokuhirom AAJKLFJEF GMAIL COME<gt>

=head1 SEE ALSO

=head1 LICENSE

Copyright (C) Tokuhiro Matsuno

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut
