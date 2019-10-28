use Cro::HTTP::Router;
use XYZ::Claims;

sub routes($r) is export {
    my $c = Claimer.new(r => $r);
    route {
        get -> {
            static 'static', 'index.html';
        }
        post -> {
            content 'application/json', '{"error": "you can\'t claim the root path!"}';
        }
        get -> *@p {
            my $p = @p.first;
            if $c.claimed($p) {
                content 'text/plain', 'claimed';
            } else {
                content 'text/plain', "secret code: {$c.new-claim($p)}\n";
            }
        }
        post -> *@p, :%params {
            my $p = @p.first;
            if %params<secret> {
                if $c.lay-claim($p, %params<secret>, %params) {
                    redirect :see-other, "/$p";
                }
            } else {
                content 'application/json', '{"error": "you need to provide a secret"}';
            }
        }
    }
}
