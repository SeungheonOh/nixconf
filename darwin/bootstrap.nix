{config, pkgs, libs, ...}:

{
  nix.binaryCaches = [
    "https://cache.nixos.org/"
    "https://iohk.cachix.org"
    "https://hydra.iohk.io"
    "https://malo.cachix.org"
  ];
  nix.binaryCachePublicKeys = [
    "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
    "iohk.cachix.org-1:DpRUyj7h7V830dp/i6Nti+NEO2/nhblbov/8MW7Rqoo="
    "hydra.iohk.io:f/Ea+s+dFdN+3Y/G+FDgSq+a5NEWhJGzdjvKNGv0/EQ="
    "malo.cachix.org-1:fJL4+lpyMs/1cdZ23nPQXArGj8AS7x9U67O8rMkkMIo="
  ];
  nix.trustedUsers = [
    "@admin"
  ];
  users.nix.configureBuildUsers = true;
  nix.package = pkgs.nixUnstable;
  nix.extraOptions = "experimental-features = nix-command flakes";
  services.nix-daemon.enable = true; 
}