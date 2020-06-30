use Cro::HTTP::Auth;
use Cro::HTTP::Auth::Basic;
use Cro::HTTP::Session::Persistent;

unit module Session;

class Session does Cro::HTTP::Auth {
    has $.email;

    method is-logged-in(--> Bool) { defined $!email; }
    method current-user() { $!email }
}
subset LoggedInSession of Session where *.is-logged-in;


# https://github.com/croservices/cro-http/blob/master/lib/Cro/HTTP/Auth/Basic.pm6#L14
class SessionAuth does Cro::HTTP::Auth::Basic[Session, 'email'] {
    method authenticate(Str $email, Str $pass --> Bool) {
        # TODO
        $email eq 'equalizedigitaldev@gmail.com' && $pass eq 'cookiecookiecookie'
    }
}

class SessionStore does Cro::HTTP::Session::Persistent[SessionAuth] {
    # This will be called whenever we need to load session state, and the
    # session ID will be passed. Return `fail` if it is not possible
    # (e.g. no such session is found).
    method load(Str $session-id --> Session) {
        !!! 'Load session $session-id, place data into a new MySession instance'
    }

    # This method is optional, and will be called when a new session starts.
    # It by default does nothing, but may be convenient for databases with a
    # INSERT/UPDATE distinction (in which case this would be the initial
    # INSERT, and the save method would be an UPDATE). In other databases,
    # this distinction may not exist. This method may return an instance of
    # the session object; if it does not, one will be created automatically
    # (by calling `.new`).
    method create(Str $session-id) {
    }

    # This will be called whenever we need to save session state.
    method save(Str $session-id, Session $session --> Nil) {
        !!! 'Save session $session under $session-id, probably with a timestamp'
    }

    # Clear old sessions
    method clear(--> Nil) {
        !!! 'Clear sessions older than the maximum age to retain them'
    }
}