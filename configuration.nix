# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).
{ config, pkgs, inputs, ... }:
{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      ./cosmic.nix
  ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;


  networking.hostName = "nixos"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "America/New_York";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_US.UTF-8";
    LC_IDENTIFICATION = "en_US.UTF-8";
    LC_MEASUREMENT = "en_US.UTF-8";
    LC_MONETARY = "en_US.UTF-8";
    LC_NAME = "en_US.UTF-8";
    LC_NUMERIC = "en_US.UTF-8";
    LC_PAPER = "en_US.UTF-8";
    LC_TELEPHONE = "en_US.UTF-8";
    LC_TIME = "en_US.UTF-8";
  };

  
  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };

  # Enables fonts
  fonts.packages = with pkgs; [ 
     nerdfonts 
  ];

  # Enables fwup daemon
  services.fwupd.enable = true;

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable sound with pipewire.
  services.pulseaudio.enable = false;
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

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.indigo = {
    isNormalUser = true;
    description = "William";
    extraGroups = [ "networkmanager" "wheel" ];
    packages = with pkgs; [
    
    ];
  };
  
  
  # Install firefox.
  programs.firefox.enable = true;

  # Install Steam and config
  programs.steam = {
  enable = true;
  remotePlay.openFirewall = true; # Open ports in the firewall for Steam Remote Play
  dedicatedServer.openFirewall = true; # Open ports in the firewall for Source Dedicated Server
  localNetworkGameTransfers.openFirewall = true; # Open ports in the firewall for Steam Local Network Game Transfers
  package = pkgs.steam.override {
   extraEnv = {
     MANGOHUD = true;
    };
   };
   extraCompatPackages = with pkgs; [
      proton-ge-bin
    ]; 
  };   
  
   

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;
  
  # Enables generic binary executable
  programs.nix-ld.enable = true;
  programs.nix-ld.libraries = with pkgs; [
  # If pkgs here, don't put them in environment.systemPackages
  ];

  # Enable Flakes
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  
  # Enables Nix helper
  programs.nh = {
    enable = true;
    clean.enable = true;
    clean.extraArgs = "--keep-since 4d --keep 3";
    clean.dates = "weekly";
    flake = "/~/dotfiles/";
  };

  # Enable Flatpaks
  services.flatpak.enable = true;
  systemd.services.flatpak-repo = {
    wantedBy = [ "multi-user.target" ];
    path = [ pkgs.flatpak ];
    script = ''
      flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
    '';
  };
  
  # Flatpak pakages
  services.flatpak.packages = [
    { appId = "com.brave.Browser"; origin = "flathub";  }
    "org.gtk.Gtk3theme.adw-gtk3"
    "org.gtk.Gtk3theme.adw-gtk3-dark"
    "dev.vencord.Vesktop"
    "org.libreoffice.LibreOffice"
    "md.obsidian.Obsidian"
    "net.retrodeck.retrodeck"
    "org.localsend.localsend_app"
    "app.zen_browser.zen"
    "com.github.tchx84.Flatseal"
    
  ];
  
  # Auto updates Flatpaks
  services.flatpak.update.onActivation = true;


  # System Packages
  environment.systemPackages = with pkgs; [
    lact
    git
    gitui
    adw-gtk3
    gnome-disk-utility
    zsh
    oh-my-zsh
    zsh-autosuggestions
    zsh-autocomplete
    meslo-lgs-nf
    fastfetch
    btop
    papirus-icon-theme
    policycoreutils
    mangohud
    goverlay
    zsh-powerlevel10k
    asciiquarium-transparent
    steam-devices-udev-rules
    gearlever
    popsicle
    starship
  ];
  
  
  # Enables Gamescope, and config
  programs.gamescope = {
    enable = true;
    # Command-line arguments
    args = [
      "-w 2560"
      "-h 1440"
      "-f"    
      ];
   };  
      
      
  # Enables ZSH as defualt shell    
  users.defaultUserShell = pkgs.zsh;
  
  # Sets up update aliases to "nhu" for flake in HOME/dotfiles
  programs.zsh.shellAliases = {
   nhu = "nh os switch ~/dotfiles -u -a && fwupdmgr refresh && fwupdmgr update";
  };  
   

  #Enables p10k theme
  #programs.zsh.promptInit = "source ${pkgs.zsh-powerlevel10k}/share/zsh-powerlevel10k/powerlevel10k.zsh-theme";
  
  programs.zsh = {
    enable = true;
  };
  
  # Config for .zshrc file, needs to made in HOME
  environment.etc."zshrc".text = ''
  
    # Enable colors and change prompt:
    autoload -U colors && colors
    PS1="%B%{$fg[red]%}[%{$fg[yellow]%}%n%{$fg[green]%}@%{$fg[blue]%}%M %{$fg[magenta]%}%~%{$fg[red]%}]%{$reset_color%}$%b "

    HISTSIZE=10000
    SAVEHIST=10000
    HISTFILE=~/.cache/zshhistory
    setopt appendhistory
    
    export EDITOR="cosmic-edit --wait"

    fastfetch
    
    # Start ssh-agent if not running and add key
    if [ -z "$SSH_AUTH_SOCK" ]; then
       eval "$(ssh-agent -s)" > /dev/null
       ssh-add ~/.ssh/id_rsa 2>/dev/null
    fi

    eval "$(starship init zsh)"

    # Autosuggestions
    source ${pkgs.zsh-autosuggestions}/share/zsh-autosuggestions/zsh-autosuggestions.zsh
    # Autocomplete
    source ${pkgs.zsh-autocomplete}/share/zsh-autocomplete/zsh-autocomplete.plugin.zsh
    # Syntax highlighting (must be sourced last)
    source ${pkgs.zsh-syntax-highlighting}/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
  '';

  
  # Themes QT
  qt = {
  enable = true;
  platformTheme = "gnome";
  style = "adwaita-dark";
  };
  
  # Automatic Garbage Collection
  #nix.gc = {
  #automatic = true;
  #dates = "weekly";
  #options = "--delete-older-than 7d";
   #};
   
  # Automatic Upgrades
   #system.autoUpgrade = {
     #enable = true;
     #flake = inputs.self.outPath;
     #flags = [
       #"--update-input"
       #"--print-build-logs"
      #];
     #dates = "weekly";
     #randomizedDelaySec = "45min";
     #};   

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
  system.stateVersion = "24.11"; # Did you read the comment?

}
