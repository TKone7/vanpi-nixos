{ inputs, ... }: {
  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = false;
    backupFileExtension = "backup";
    extraSpecialArgs = { 
      inherit inputs;
    };
  };
}
