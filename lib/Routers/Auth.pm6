use Cro::HTTP::Router;

unit module Routers::Auth;

our sub routes() {
    route {
        get -> 'login' { ... }
        post -> 'login' { ... }
        get -> 'signup' { ... }
        post -> 'signup' { ... }
    }
}