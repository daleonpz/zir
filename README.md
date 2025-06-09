# Nix-Based Zephyr nRF Connect Development Environment (Zir)

This project is designed to be built and run using Nix, providing a reproducible development environment for Zephyr RTOS and nRF Connect SDK. It includes scripts for building the application and MCUboot bootloader.

## Table of Contents

- [About the Project](#about-the-project)
- [Project Status](#project-status)
- [Getting Started](#getting-started)
    - [Requirements](#requirements)
    - [Starting the environment](#starting-the-environment)
    - [Adding Your Application](#adding-your-application)
    - [Troubleshooting](#troubleshooting)
- [Contributing](#contributing)
- [Authors](#authors)
- [License](#license)
- [Extras](#extras)
    - [BLE Sniffer](#ble-sniffer)

## About the Project

This project is ideal for developers working with Nordic Semiconductors MCUs, especially those focusing on embedded systems and IoT applications. It simplifies the setup process and ensures that all dependencies are managed consistently across different development environments. It includes:

- A Nix-based development environment for reproducibility.
- Installation of nRF Connect SDK, nrfutil and Zephyr SDK.
- JLink support for debugging and programming.

**[Back to top](#table-of-contents)**

## Project Status

The project is functional and was tested for the nrf52840dk board. 

- Bluetooth Low Energy (BLE) sniffer support is experimental.
- Twister wasn't tested yet.

**[Back to top](#table-of-contents)**

## Getting Started

### Requirements

To build and run this project, you need:

- Nix: A package manager for reproducible builds.

  ```bash
  sh <(curl --proto '=https' --tlsv1.2 -L https://nixos.org/nix/install) --daemon
  ```
### Starting the environment

1. Clone the repository

```bash
git clone --recursive https://github.com/daleonpz/zir.git
```

2. Change to the project directory:

   ```bash
   cd zephyr_ncs_devenv
   ```
3. Start the Nix shell:

   ```bash
   nix develop .
   ```

If it is your first time using Nix, it will take a while to download and build the dependencies. This process may take several minutes depending on your system and internet connection.

**Note**: If you change the `flake.nix` file, you may need to run `nix develop .` again to rebuild the environment. Don't worry, Nix will only rebuild the parts that have changed.

**[Back to top](#table-of-contents)**

### Adding Your Application

1. Start the Nix shell, if you haven't already:

   ```bash
   nix develop .
   ```

2. Clone your application:
   
   ```bash
   cd ncs
   west init -m https://github.com/your-name/your-application your-app-worskpace
   cd your-app-workspace
   west update
   ```

**[Back to top](#table-of-contents)**

### Troubleshooting

* If you encounter issues with the Nix environment, try running:

   ```bash
   nix-collect-garbage
   ```

* If you cannot access the serial port from Nix, add your user to the device's group (e.g., `uucp`):

   ```bash
   ls -l /dev/ttyACM0  # Check group (e.g., uucp)
   sudo usermod -a -G uucp $USER
   sudo reboot
   ```

* `nrfutil` searchs for JLinkArm library in `/opt/SEGGER/JLink`, so you need to create a symlink to the JLink directory:

   ```bash
   sudo mkdir -p /opt/SEGGER/JLink
   sudo ln -s /full-path/to/JLink/* /opt/SEGGER/JLink/
   ```
**[Back to top](#table-of-contents)**

## Contributing

Contributions are welcome! Please create a pull request on GitHub.

**[Back to top](#table-of-contents)**

## Authors

-  Daniel Paredes (daleonpz)

**[Back to top](#table-of-contents)**

## License

Licensed under the Apache License 2.0. See the LICENSE file for details.

Copyright (c) 2025 Daniel Paredes (daleonpz)

**[Back to top](#table-of-contents)**

## Extras
### BLE Sniffer
This project uses BLE as a communication protocol for the wearable device. The [nRF52840 Dongle](https://www.nordicsemi.com/Products/Development-hardware/nRF52840-Dongle) can be configured as a BLE sniffer to capture and analyze Bluetooth Low Energy packets.

1. Start the power profiler, if you installed the version 5.1.0 of nRF Connect for Desktop:

   ```bash
   nrfconnect-5.1.0-x86_64.appimage
   ```

2. Open the Programmer app, select the device (`Open DFU bootloader`).

3. Flash the sniffer firmware:

   ```bash
   # Select: nrftools/nrfutil_tools/hex/sniffer_nrf51dongle_nrf51422_4.1.1.hex
   # Click "write" to flash
   ```

4. Verify the device appears as `nRF Sniffer for Bluetooth`.

**[Back to top](#table-of-contents)**

