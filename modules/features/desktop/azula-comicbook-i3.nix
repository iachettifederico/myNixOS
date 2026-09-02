{ ... }: {
  flake.nixosModules.azulaComicbookI3 = { pkgs, ... }:
  let
    comicbookLock = pkgs.writeShellScriptBin "comicbook-lock" ''
      if [ "$#" -eq 1 ] && [ "$1" = "--print-i3lock-path" ]; then
        ${pkgs.coreutils}/bin/printf '%s\n' "${pkgs.i3lock-color}/bin/i3lock"
        exit 0
      fi

      export COMICBOOK_I3LOCK="${pkgs.i3lock-color}/bin/i3lock"
      export COMICBOOK_MAGICK="${pkgs.imagemagick}/bin/magick"

      exec ${pkgs.bash}/bin/bash "$HOME/.config/i3/lock/lock-screen" "$@"
    '';
  in {
    services.picom = {
      backend = "xrender";
      fade = true;
      fadeDelta = 10;
      fadeSteps = [ 0.125 0.125 ];
      fadeExclude = [
        "window_type = 'dock'"
        "fullscreen"
        "class_g = 'i3lock'"
      ];
      shadow = true;
      shadowExclude = [
        "!(class_g = 'Rofi' || class_g = 'Dunst' || window_type = 'dialog' || window_type = 'utility' || window_type = 'menu' || window_type = 'popup_menu' || window_type = 'dropdown_menu')"
        "window_type = 'dock'"
        "fullscreen"
        "class_g = 'i3lock'"
      ];

      settings = {
        "shadow-radius" = 6;
        "shadow-offset-x" = 6;
        "shadow-offset-y" = 6;
        "shadow-opacity" = 0.25;
        "blur-method" = "none";
        "corner-radius" = 0;
        "inactive-dim" = 0;
        "unredir-if-possible" = true;
      };
    };

    environment.systemPackages = with pkgs; [
      bash
      coreutils
      imagemagick
      i3lock-color
      comicbookLock
    ];

    fonts.packages = [
      (pkgs.google-fonts.override {
        fonts = [ "Bangers" "Comic Neue" "Permanent Marker" ];
      })
    ];

    system.userActivationScripts.comicbookI3Compatibility.text = ''
      set -eu

      ensure_directory() {
        directory="$1"
        if [ -e "$directory" ]; then
          if [ ! -d "$directory" ]; then
            ${pkgs.coreutils}/bin/printf '%s\n' "comicbook-i3: expected directory at $directory" >&2
            exit 1
          fi
          return
        fi

        ${pkgs.coreutils}/bin/mkdir -p "$directory"
      }

      ensure_link() {
        destination="$1"
        target="$2"

        if [ -L "$destination" ]; then
          if [ "$(${pkgs.coreutils}/bin/readlink "$destination")" = "$target" ]; then
            return
          fi
          ${pkgs.coreutils}/bin/printf '%s\n' "comicbook-i3: refusing conflicting link at $destination" >&2
          exit 1
        fi

        if [ -e "$destination" ]; then
          ${pkgs.coreutils}/bin/printf '%s\n' "comicbook-i3: refusing to replace existing path at $destination" >&2
          exit 1
        fi

        ${pkgs.coreutils}/bin/ln -s "$target" "$destination"
      }

      ensure_directory "$HOME/.config/rofi"
      ensure_directory "$HOME/.config/dunst"
      ensure_directory "$HOME/bin"

      ensure_link "$HOME/.config/rofi/config.rasi" "$HOME/.config/i3/rofi/config.rasi"
      ensure_link "$HOME/.config/dunst/dunstrc" "$HOME/.config/i3/dunst/dunstrc"
      ensure_link "$HOME/bin/lock-screen" ${comicbookLock}/bin/comicbook-lock

    '';
  };
}
