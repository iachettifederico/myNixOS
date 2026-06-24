{ self, inputs, ... }:
{
  flake.nixosModules.kalkomey = { pkgs, ... }:
  let
    sudoBin = "/run/wrappers/bin/sudo";
    keWorkspace = "/home/ke/code/kalkomey";

    keShell = pkgs.writeShellScript "ke-shell" ''
      exec ${sudoBin} -u ke -H -- ${pkgs.zsh}/bin/zsh -lc 'cd ${keWorkspace} && exec ${pkgs.zsh}/bin/zsh -l'
    '';

    keShellGui = pkgs.writeShellScript "ke-shell-gui" ''
      exec ${pkgs.ghostty}/bin/ghostty -e ${sudoBin} -u ke -H -- ${pkgs.zsh}/bin/zsh -lc 'cd ${keWorkspace} && exec ${pkgs.zsh}/bin/zsh -l'
    '';

    keEmacs = pkgs.writeShellScript "ke-emacs" ''
      exec ${sudoBin} --preserve-env=DISPLAY,XAUTHORITY,DBUS_SESSION_BUS_ADDRESS,XDG_RUNTIME_DIR -u ke -H ${pkgs.emacs}/bin/emacs "$@"
    '';

    keFirefox = pkgs.writeShellScript "ke-firefox" ''
      exec ${sudoBin} --preserve-env=DISPLAY,XAUTHORITY,DBUS_SESSION_BUS_ADDRESS,XDG_RUNTIME_DIR -u ke -H ${pkgs.firefox}/bin/firefox "$@"
    '';

    keFirefoxDevedition = pkgs.writeShellScript "ke-firefox-devedition" ''
      exec ${sudoBin} --preserve-env=DISPLAY,XAUTHORITY,DBUS_SESSION_BUS_ADDRESS,XDG_RUNTIME_DIR -u ke -H ${pkgs.firefox-devedition}/bin/firefox-devedition "$@"
    '';

    keGhostty = pkgs.writeShellScript "ke-ghostty" ''
      exec ${sudoBin} --preserve-env=DISPLAY,XAUTHORITY,DBUS_SESSION_BUS_ADDRESS,XDG_RUNTIME_DIR -u ke -H ${pkgs.ghostty}/bin/ghostty "$@"
    '';

    keRofi = pkgs.writeShellScript "ke-rofi" ''
      cmd_dir=/home/fedex/bin/ke
      choice=$(${pkgs.coreutils}/bin/printf '%s\n' \
        ke-shell \
        ke-emacs \
        ke-firefox \
        ke-firefox-devedition \
        ke-ghostty | ${pkgs.rofi}/bin/rofi -dmenu -p ke)

      test -n "$choice" || exit 0

      if [ "$choice" = "ke-shell" ]; then
        exec "$cmd_dir/ke-shell-gui"
      fi

      exec "$cmd_dir/$choice"
    '';
  in {
    services.xserver.displayManager.sessionCommands = ''
      ${pkgs.xhost}/bin/xhost +SI:localuser:ke >/dev/null
    '';

    security.sudo.extraConfig = ''
      fedex ALL=(ke) NOPASSWD:SETENV: ${pkgs.zsh}/bin/zsh, ${pkgs.emacs}/bin/emacs, ${pkgs.firefox}/bin/firefox, ${pkgs.firefox-devedition}/bin/firefox-devedition, ${pkgs.ghostty}/bin/ghostty
    '';

    system.activationScripts.keLaunchers.text = ''
      ${pkgs.coreutils}/bin/mkdir -p /home/fedex/bin/ke
      ${pkgs.coreutils}/bin/chown fedex /home/fedex/bin /home/fedex/bin/ke

      ${pkgs.coreutils}/bin/ln -sfn ${keShell} /home/fedex/bin/ke/ke-shell
      ${pkgs.coreutils}/bin/ln -sfn ${keShellGui} /home/fedex/bin/ke/ke-shell-gui
      ${pkgs.coreutils}/bin/ln -sfn ${keEmacs} /home/fedex/bin/ke/ke-emacs
      ${pkgs.coreutils}/bin/ln -sfn ${keFirefox} /home/fedex/bin/ke/ke-firefox
      ${pkgs.coreutils}/bin/ln -sfn ${keFirefoxDevedition} /home/fedex/bin/ke/ke-firefox-devedition
      ${pkgs.coreutils}/bin/ln -sfn ${keGhostty} /home/fedex/bin/ke/ke-ghostty
      ${pkgs.coreutils}/bin/ln -sfn ${keRofi} /home/fedex/bin/ke/ke-rofi
    '';
  };
}
