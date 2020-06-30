use MongoDB::Client;
use BSON::Document;

our class Config {
    has $.HOST is readonly = '0.0.0.0';
    has $.PORT is readonly = 20000;

    has $.DB-URI is readonly = 'mongodb://127.0.0.1:27017/heyitsme';
    has $.DB-CLIENT is readonly = MongoDB::Client.new(uri => $!DB-URI);
    has $.DB is readonly = $!DB-CLIENT.database('heyitsme');
}