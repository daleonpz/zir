# Copyright 2025 Daniel Paredes (daleonpz)
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
{
    description = "Flake for nRF Connect SDK development";

    inputs = {
        nixpkgs.url = "github:nixos/nixpkgs/nixos-24.11";
    };

    outputs = { self, nixpkgs }:

    let
        system = "x86_64-linux";
        pkgs = import nixpkgs { system = system; };
        python = pkgs.python311;
        pythonPackages = pkgs.python311Packages;
    in
    {
        devShells.${system}.default = pkgs.mkShell {
        name = "zephyr-dev";
        packages = with pkgs; [
                cmake
                ninja
                gperf
                ccache
                dfu-util
                dtc
                wget
                curl
                python
                xz
                file
                gnumake
                pkgsi686Linux.gcc # for twister using native_sim
                SDL2
                openocd
                which # used in zephyr sdk setup.sh
                cacert # used in zephyr sdk
                pythonPackages.pip
                pythonPackages.setuptools
                pythonPackages.wheel
                pythonPackages.tkinter
                pythonPackages.pyelftools
                # mcuboot
                pythonPackages.click
                pythonPackages.cryptography
                pythonPackages.intelhex
                pythonPackages.cbor2
                pythonPackages.pyyaml
                pythonPackages.pytest
                # dev tools
                git
                openssh
                tree
                # cmake tools
                pythonPackages.lizard
                # hardware tools
                pythonPackages.pyserial
                pythonPackages.numpy
                pythonPackages.matplotlib
                pythonPackages.pandas
                pythonPackages.scipy
            ];

        shellHook = ''
            if [ ! -d .env ]; then
                python -m venv .env
            fi
            source .env/bin/activate
            export HOME=$(pwd)
            export LC_ALL=C
            pip install west
            pip install codechecker
            sh ~/scripts/install_zephyr_sdk.sh
            sh ~/scripts/install_nrf_tools.sh
            echo -e '\033[33m Adding nrftools to PATH\033[0m'
            echo -e '\033[33m NOTE: nrftools is defined in ~/scripts/nrf_tools_config.sh\033[0m'
            export PATH=$PATH:~/nrftools
            export LD_LIBRARY_PATH=${pkgs.pkgsi686Linux.glibc}/lib:$LD_LIBRARY_PATH
            if [ ! -d /opt/SEGGER/JLink ]; then
              echo -e '\033[31m ERROR: JLink is not installed in /opt/SEGGER/JLink\033[0m'
              echo -e '\033[31m\tPlease execute the following commands outside Nix, JLink Version may vary:\033[0m'
              echo -e '\033[31m\t\tsudo mkdir -p /opt/SEGGER/JLink\033[0m'
              echo -e '\033[31m\t\tsudo ln -sf ~/JLink/JLink_Linux_V818_x86_64/* /opt/SEGGER/JLink/\033[0m'
            fi
            echo -e '\033[32m Zephyr development environment is ready!\033[0m'
            echo -e '\033[32m You can now run west commands or build your projects.\033[0m'
            echo -e '\033[5;1;32m ==== NOTE: Place your app/ under ncs/<sdk_version> directory.====\033[0m'
        '';
        };
    };
}
