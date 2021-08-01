{config, pkgs, lib, ...}:
let
  shellAlias = {
    v = "nvim";
    c = "cdns";
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
      function cdns() {
        cd $1
        if [ -f ./shell.nix ]; then
          nix-shell
        fi
      }
      function sysrebuild() {
        cdns $NIXCONFPATH
        sudo make
      }
      # Prompt
      restore_prompt_after_nix_shell() {
        if [ "$PS1" != "$PROMPT" ]; then
          PS1="*$PROMPT"
          PROMPT_COMMAND=""
        fi
      }
      PROMPT_COMMAND=restore_prompt_after_nix_shell
      PROMPT='[ \W ]$ '
      export PS1=$PROMPT
      bind 'TAB:menu-complete'
      bind 'set show-all-if-ambiguous on'
    '';
  };
}