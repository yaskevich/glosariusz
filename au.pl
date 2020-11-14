#!/usr/bin/env perl
use Mojolicious::Lite;
use Mojolicious::Plugin::Authentication;
use Data::Dumper;

 

plugin 'authentication', {                 
    autoload_user => 0,
    load_user => sub {
        my ($app, $uid) = @_;

        return {
            'username' => 'a',
            'password' => 'b',
            'name' => 'Coop'
            } if($uid eq 'userid');
        return undef;
    },
    validate_user => sub {
        my ($app, $username, $password, $extradata) = @_;
        return 'userid' if($username eq 'a' && $password eq 'b');
        return undef;
    },
};                                         

helper stash_var => sub {                
    my $self = shift;
    # return Dumper($self->stash);
    return '';
};                                        

# get '/' => sub {                        
    # my $self = shift;
    # my ($title, $url) = ("Home page, directed to the login", '/login');
    # $self->render(titol => $title, stash => $self->stash_var, url => $url );
# } => 'basica';                            

get '/login' => sub { shift->render('login') };

# post '/entrada' => sub {                
any '/' => sub {                
    my $self = shift;
	# say Dumper ($self->req->params);
    my ($u, $p) = ($self->req->param('u'), $self->req->param('p'));
	say $self->is_user_authenticated ? "is in" : "is out";
	
	# say Dumper ($self->authenticate($u, $p));
	unless ($self->is_user_authenticated) {
	
		if ($self->authenticate($u, $p)) {
		
		
        my ($title, $url) = ("Welcome user ".$self->current_user->{'name'}.", you are in. Let's see if we can go to another page", '/entrada/auth');
        $self->render(titol => $title, stash => $self->stash_var, url => $url);
		$self->render('basica');
    } else {
		# my ($title, $url) = ("You do not have access to this page", '/');
		my ($title, $url) = ("You do not have access, pls  login", '/login');
		$self->render(titol => $title, stash => $self->stash_var, url => $url );
		$self->render('login');
	}
    } else {
	    my ($title, $url) = ("Already in, ".$self->current_user->{'name'}, '/entrada/auth');
		
        $self->render(titol => $title, stash => $self->stash_var, url => $url);
		$self->render('basica');
	}

};


get '/entrada/auth' => (authenticated => 1) => sub {
    my $self = shift;
    my ($title, $url) = ("Congratulations, you are authenticated!", "/entrada/still_in");
    $self->render(titol => $title, stash => $self->stash_var, url => $url);
} => 'basica';

get '/entrada/still_in' => (authenticated => 1) => sub {
    my $self = shift;
    my ($title, $url) = ("Still in! Logging out and back to previous page to get 'page not found'!", "/entrada/auth");
    $self->logout;
    $self->render(titol => $title, stash => $self->stash_var, url => $url);
} => 'basica';

app->start;

__DATA__

@@basica.html.ep
%= t h1 => $titol
%= $stash;
<p>Go to <%= link_to $url => $url %> web address.<p>

@@login.html.ep
%= t h1 => 'Dostęp jest ograniczony'
%= t h1 => $titol
%= t h2 => 'Wpisz imię użytkownika oraz hasło'
%= form_for '/' => (method => 'post') => begin
<form method="post" action="/">
    imię: <%= text_field 'u' %>
    hasło: <%= text_field 'p' %>
    %= submit_button 'wejść' 
%= end