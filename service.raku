use Config;
our $*C = Config.new();
our $*DB = $*C.DB;

use Cro::HTTP::Log::File;
use Cro::HTTP::Server;
use Routes;
use Session::Session;

my Cro::Service $http = Cro::HTTP::Server.new(
    # http => <1.1 2>,
    http => <1.1>,
    host => $*C.HOST || %*ENV<HEYITSME_HOST> ||
        die("Missing HEYITSME_HOST in environment"),
    port => $*C.PORT || %*ENV<HEYITSME_PORT> ||
        die("Missing HEYITSME_PORT in environment"),
    # tls => %(
    #     private-key-file => %*ENV<HEYITSME_TLS_KEY> ||
    #         %?RESOURCES<fake-tls/server-key.pem> || "resources/fake-tls/server-key.pem",
    #     certificate-file => %*ENV<HEYITSME_TLS_CERT> ||
    #         %?RESOURCES<fake-tls/server-crt.pem> || "resources/fake-tls/server-crt.pem",
    # ),
    application => routes(),
    before => [
        Session::SessionStore.new(
            expiration => Duration.new(2000),
            cookie-name => 'IncrediblyUniqueCookie'
        )
    ],
    after => [
        Cro::HTTP::Log::File.new(logs => $*OUT, errors => $*ERR)
    ]
);
$http.start;
say "Listening at https://{ $*C.HOST || %*ENV<HEYITSME_HOST> }:{ $*C.PORT || %*ENV<HEYITSME_PORT> }";
react {
    whenever signal(SIGINT) {
        say "Shutting down...";
        $http.stop;
        done;
    }
}
