use Cro::HTTP::Router;
use XYZ::Claims;

sub routes($r) is export {
    my $c = Claimer.new(r => $r);
    route {
        get -> {
            static 'static', 'index.html';
        }
        get -> 'hello' {
            content 'text/html', '<i>hello</i>';
        }
        get -> $p {
            if $c.claimed($p) {
                content 'text/plain', 'claimed';
            } else {
                content 'text/plain', $c.new-claim($p);
            }
        }
    }
}
