use Cro::HTTP::Router;
use Routers::Auth;

sub routes() is export {
    route {
        get -> {
            content 'text/html', "<h1> heyitsme </h1>";
        }
        include auth => Routers::Auth::routes;
    }
}
