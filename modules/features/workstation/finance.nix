{ ... }: {
  flake.nixosModules.workstationFinance = { pkgs, ... }: {
    environment.systemPackages = with pkgs; [
      hledger
      hledger-interest
      hledger-ui
      hledger-web
      ledger
    ];
  };
}
