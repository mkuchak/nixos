# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      (import "${builtins.fetchTarball https://github.com/nix-community/home-manager/archive/release-24.05.tar.gz}/nixos")
    ];

  # Bootloader.
  boot.loader.grub.enable = true;
  boot.loader.grub.device = "/dev/sda";
  boot.loader.grub.useOSProber = true;

  networking.hostName = "nixos"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "America/Sao_Paulo";

  # Select internationalisation properties.
  i18n.defaultLocale = "pt_BR.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "pt_BR.UTF-8";
    LC_IDENTIFICATION = "pt_BR.UTF-8";
    LC_MEASUREMENT = "pt_BR.UTF-8";
    LC_MONETARY = "pt_BR.UTF-8";
    LC_NAME = "pt_BR.UTF-8";
    LC_NUMERIC = "pt_BR.UTF-8";
    LC_PAPER = "pt_BR.UTF-8";
    LC_TELEPHONE = "pt_BR.UTF-8";
    LC_TIME = "pt_BR.UTF-8";
  };

  # Enable the X11 windowing system.
  services.xserver.enable = true;

  # Enable the GNOME Desktop Environment.
  services.xserver.displayManager.gdm.enable = true;
  services.xserver.desktopManager.gnome.enable = true;

  # Configure keymap in X11
  services.xserver = {
    xkb = {
      layout = "br";
      variant = "";
    };
  };

  # Configure console keymap
  console.keyMap = "br-abnt2";

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable sound with pipewire.
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    #jack.enable = true;

    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    #media-session.enable = true;
  };

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.mkuchak = {
    isNormalUser = true;
    description = "Marcos";
    extraGroups = [ "networkmanager" "wheel" ];
    packages = with pkgs; [
    #  thunderbird
    ];
  };

  # Install firefox.
  programs.firefox.enable = true;

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
   xbindkeys xautomation xvkbd xdotool # Key bindings and automation tools
   home-manager gnome.gpaste
   vim wget eza btop iftop lsof
   git gh # gitkraken
   zip unzip unrar
   fish warp-terminal
   # docker_26 docker-compose kubernetes
   bun deno nodejs_22 corepack_22 # nodePackages_latest.pnpm nodePackages_latest.wrangler nodePackages_latest.vercel
   # go python3 jdk rustup cargo-cachecargo-expand
   vscode # typora netbeans android-studio
   # insomnia dbeaver zeal cloudflared # httpie-desktop # unstable
   google-chrome # tor-browser
   # qbittorrent vlc bitwarden-desktop
   # obs-studio kooha
   # davinci-resolve gimp-with-plugins audacity pavucontrol
   # godot_4 unityhub
   # discord slack
   # xdg-desktop-portal-hyprland alejandra

   # Kooha is a simple screen recoder that save as GIF
   # Zeal is an offline documentation of a variety of languages, libraries and frameworks
   # Portal Hyprland is a tiling window manager
  ];

  # programs.hyprland.enable = true; # tiling window manager
  # environment.sessionVariables.NIXOS_OZONE_WL = "1"; # optional, hint electron apps to use wayland
  programs.fish.enable = true;
  users.defaultUserShell = pkgs.fish;
  virtualisation.vmware.guest.enable = true; # VMware Tools
  
  # Enable Home Manager
  programs.dconf.enable = true;

  # Home Manager configuration
  nixpkgs.config = {
    packageOverrides = pkgs: {
     home-manager = pkgs.home-manager;
    };
  };

  # Define user configurations
  home-manager.users."mkuchak" = {
    home.stateVersion = "24.05";
    home.packages = with pkgs; [
      #  vim
    ];
    home.file = {
#       ".xbindkeysrc" = {
#         text = ''
# "xvkbd -xsendevent -text '?'"
# Control+Mod1 + w
# "xvkbd -xsendevent -text '|'"
# Control+Mod1 + z
# "xvkbd -xsendevent -text '\\'"
# Control+Mod1 + q
#         '';
#       };

#       ".xbindkeysrc" = {
#         text = ''
# "xdotool key --clearmodifiers '\\'"
# Control+Mod1 + q
# "xdotool key --clearmodifiers '?'"
# Control+Mod1 + w
# "xdotool key --clearmodifiers '|'"
# Control+Mod1 + z
#         '';
#       };

#       ".xbindkeysrc" = {
#         text = ''
# "xset r off; sleep 0.2 && xdotool key --clearmodifiers '\\'; xset r on;"
# Control+Mod1 + q
# "xset r off; sleep 0.2 && xdotool key --clearmodifiers '?'; xset r on;"
# Control+Mod1 + w
# "xset r off; sleep 0.2 && xdotool key --clearmodifiers '|'; xset r on;"
# Control+Mod1 + z
#         '';
#       };

#       ".xbindkeysrc" = {
#         text = ''
# "xdotool key --clearmodifiers --window $(xdotool getactivewindow) 'backslash'"
# Control+Mod1 + q
# "xdotool key --clearmodifiers --window $(xdotool getactivewindow) 'slash'"
# Control+Mod1 + w
# "xdotool key --clearmodifiers --window $(xdotool getactivewindow) 'backslash'"
# Control+Mod1 + z
#         '';
#       };

#       ".xbindkeysrc" = {
#         text = ''
# "xte 'key ?'"
# Control+Mod1 + w
# "xte 'key |'"
# Control+Mod1 + z
# "xte 'key \\'"
# Control+Mod1 + q
#         '';
#       };

#       ".xbindkeysrc" = {
#         text = ''
# "xte 'keydown Control_L' 'keydown Alt_L' 'key w' 'keyup Alt_L' 'keyup Control_L'"
# Control+Mod1 + w
# "xte 'keydown Control_L' 'keydown Alt_L' 'key z' 'keyup Alt_L' 'keyup Control_L'"
# Control+Mod1 + z
# "xte 'keydown Control_L' 'keydown Alt_L' 'key q' 'keyup Alt_L' 'keyup Control_L'"
# Control+Mod1 + q
#         '';
#       };
    };
    dconf.settings = {
      "org/gnome/desktop/wm/preferences" = {
        "resize-with-right-button" = true;
        "mouse-button-modifier" = "<Super>";
      };
      "org/gnome/mutter" = {
        "dynamic-workspaces" = true;
      };
      "org/gtk/Settings/FileChooser" = {
        "clock-format" = "24h";
      };
      "org/gnome/desktop/interface" = {
        "clock-format" = "24h";
        "clock-show-seconds" = true;
        "clock-show-date" = true;
      };
      "org/gnome/desktop/wm/keybindings" = {
        "switch-to-workspace-left" = ["<Super><Control>Left"];
        "switch-to-workspace-right" = ["<Super><Control>Right"];
        "move-to-workspace-left" = ["<Super><Control><Shift>Left"];
        "move-to-workspace-right" = ["<Super><Control><Shift>Right"];
      };
      "org/gnome/settings-daemon/plugins/media-keys" = {
        "play" = ["<Alt>z"];
      };
      "org/gnome/shell/keybindings" = {
        "show-screen-recording-ui" = ["<Shift><Super>r"];
        "show-screenshot-ui" = ["<Shift><Super>s"];
      };
    };
    programs.git = {
      enable = true;
      userName = "Marcos Kuchak";
      userEmail = "mkuchak@hotmail.com";
      extraConfig = {
        init.defaultBranch = "main";
        core.editor = "code --wait";
        push.followTags = true;
      };
    };
  };

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "24.05"; # Did you read the comment?

}
