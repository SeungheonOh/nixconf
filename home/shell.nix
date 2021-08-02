{config, pkgs, lib, ...}:
let
  shellAlias = {
    v = "nvim";
    c = "cd";
    ns = "nix-shell";
    nsp = "nix-shell -p";
  };
in
{
  programs.bash = {
    enable = true;
    shellAliases = shellAlias;
    bashrcExtra =
      let
        alias_completion = lib.concatStringsSep "\n" (
          lib.mapAttrsToList (k: v: "complete -F _complete_alias ${k} ") shellAlias
        );
      in ''
      source ${pkgs.complete-alias}/bin/complete_alias
      ${alias_completion}

      export PS1='[ \W ]$ '
      bind 'TAB:menu-complete'
      bind 'set show-all-if-ambiguous on'
    '';
  };
}