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
            pip ipykernel notebook
            pandas numpy scipy scikit-learn torchvision matplotlib # sklearn-deap
          ]))
        ];

        shellHook = (''
          # if the terminal supports color.
          if [[ -n "$(tput colors)" && "$(tput colors)" -gt 2 ]]; then
            echo -e "\033[1;32mStarted\033[0m a \033[1;31mPython\033[0m Development Shell powered by \033[1;34mNix\033[0m."
            echo -e "Using \033[1;33m$(python --version)\033[00m together with \033[1;33m$(pip --version)\033[00m."
            export PS1="(\033[1m\033[35mDev-Shell\033[0m) $PS1"
          else 
            echo "Started a Python Development Shell powered by Nix."
            echo "Using $(python --version) together with $(pip --version)."
            export PS1="(Dev-Shell) $PS1"
          fi
        '');
      };
    }
  );
}
