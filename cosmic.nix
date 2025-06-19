{ config, pkgs, ... }:

{
  # Enable Cosmic Desktop
  services.desktopManager.cosmic.enable = true;
  services.displayManager.cosmic-greeter.enable = true;

  environment.systemPackages = with pkgs; [
    cosmic-ext-calculator
    forecast
    tasks
    cosmic-ext-tweaks
    cosmic-applibrary
    seahorse
    cheese
    loupe
  ];
}
