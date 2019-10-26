unit module XYZ::Claims;

class Claimer is export {
  has $.r;

  method claimed(Str $path) {
    ?$!r.get("path.$path.claimed")
  }

  method new-claim(Str $path) {
    if (self.claimed($path)) {
      my $secret = ('a'..'z').roll(128).join;
      $!r.set("path.$path.secret", $secret);
      $secret
    } else {
      ''
    }
  }

  method lay-claim(Str $path, Str $secret, *%slurp) {
    my %ARGS-TO-REDIS-KEYS = (
      :name<"path.$path.name">,
      :pronouns<"path.$path.pronouns">,
      :bio<"path.$path.bio">,
      :link1text<"path.$path.link.1.text">,
      :link1href<"path.$path.link.1.href">,
      :link2text<"path.$path.link.2.text">,
      :link2href<"path.$path.link.2.href">,
      :link3text<"path.$path.link.3.text">,
      :link3href<"path.$path.link.3.href">,
      :link4text<"path.$path.link.4.text">,
      :link4href<"path.$path.link.4.href">,
      :link5text<"path.$path.link.5.text">,
      :link5href<"path.$path.link.5.href">
    );

    if ($secret eq ($*R.get("path.$path.secret").decode)) {
      # fill all the slurpy args
      for %ARGS-TO-REDIS-KEYS.kv -> $k, $v {
        $!r.set($v, %slurp{$k});
      }
      # and lay claim
      $!r.set("path.$path.claimed", "true");
    }
  }
}