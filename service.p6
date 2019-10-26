use Cro::HTTP::Log::File;
use Cro::HTTP::Server;
use Routes;
use Redis;

my $*R = Redis.new(%*ENV<HEYITSME_REDIS_URL> || "127.0.0.1:6379");

my Cro::Service $http = Cro::HTTP::Server.new(
    http => <1.1 2>,
    host => %*ENV<HEYITSME_HOST> ||
        die("Missing HEYITSME_HOST in environment"),
    port => %*ENV<HEYITSME_PORT> ||
        die("Missing HEYITSME_PORT in environment"),
    tls => %(
        private-key-file => %*ENV<HEYITSME_TLS_KEY> ||
            %?RESOURCES<fake-tls/server-key.pem> || "resources/fake-tls/server-key.pem",
        certificate-file => %*ENV<HEYITSME_TLS_CERT> ||
            %?RESOURCES<fake-tls/server-crt.pem> || "resources/fake-tls/server-crt.pem",
    ),
    application => routes(),
    after => [
        Cro::HTTP::Log::File.new(logs => $*OUT, errors => $*ERR)
    ]
);
$http.start;
say "Listening at https://%*ENV<HEYITSME_HOST>:%*ENV<HEYITSME_PORT>";
react {
    whenever signal(SIGINT) {
        say "Shutting down...";
        $http.stop;
        done;
    }
}
