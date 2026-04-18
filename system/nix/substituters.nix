let
  cache = builtins.fromJSON (builtins.readFile ./cache.json);
in
{
  nix.settings = {
    inherit (cache) substituters trusted-public-keys;
  };
}
