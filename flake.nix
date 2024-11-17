{
  description = "The flake that is used add python and it's packages the dev shell.";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { nixpkgs, flake-utils, ... }: flake-utils.lib.eachDefaultSystem ( system :
    let
      
      pkgs = import nixpkgs { inherit system; };

    in rec { 

      devShell = pkgs.mkShell {

        buildInputs = with pkgs; [
          (pkgs.python312.withPackages (python-libraries: with python-libraries; [
            pandas numpy notebook
          ]))
        ];

        shellHook = (''
          echo "Started a Python Development Shell."
          python --version
          export PS1="(\033[1m\033[35mDev-Shell\033[0m) $PS1"
        '');
      };
    }
  );
}
