# Zephyr nRF Connect Development Environment

This project is designed to be built and run using Nix, providing a reproducible development environment for Zephyr RTOS and nRF Connect SDK. It includes scripts for building the application and MCUboot bootloader.

## Table of Contents

- [About the Project](#about-the-project)
- [Project Status](#project-status)
- [Getting Started](#getting-started)
    - [Requirements](#requirements)
    - [Getting the Source](#getting-the-source)
    - [Building](#building)
    - [Testing](#testing)
- [Contributing](#contributing)
- [Authors](#authors)
- [License](#license)
- [Acknowledgments](#acknowledgments)
-[Extras](#extras)
    - [BLE Sniffer](#ble-sniffer)

## About the Project

This project is ideal for developers working with Nordic Semiconductors MCUs, especially those focusing on embedded systems and IoT applications. It simplifies the setup process and ensures that all dependencies are managed consistently across different development environments. It includes:

- A Nix-based development environment for reproducibility.
- Scripts for building Zephyr and NSC applications and MCUboot.
- Installation scripts for nRF Connect SDK, nrfutil and Zephyr SDK.
- JLink support for debugging and programming.


**[Back to top](#table-of-contents)**

## Project Status

The project is functional and compiles for the STM32WB55RG board (nucleo_wb55rg). It supports building the application, bootloader, and combined firmware, with OTA update capabilities. Testing is supported via Zephyr's Twister framework. Current limitations:

- Only tested on the nucleo_wb55rg board.
- Bluetooth Low Energy (BLE) sniffer support is experimental.
- Real-time data visualization is available but may need optimization for specific use cases.

**[Back to top](#table-of-contents)**

## Getting Started

### Requirements

To build and run this project, you need:

- STM32CubeProgrammer: Download and place the zip file in `scripts/`.

- Nix: A package manager for reproducible builds.

  ```bash
  sh <(curl --proto '=https' --tlsv1.2 -L https://nixos.org/nix/install) --daemon
  ```

- git-lfs: For handling binary files.

  - On Linux: `sudo apt install git-lfs`
  - On macOS: `brew install git-lfs`

- pre-commit: For code quality checks.

  ```bash
  pip install pre-commit
  pre-commit install
  ```

- Zephyr SDK and west (included via Nix environment).

**Hardware Setup**:

1. Set `STM32_INSTALL_DIR` in `scripts/install_stm32.sh`:

   ```bash
   STM32_INSTALL_DIR="${HOME}/STMicroelectronics/STM32Cube/STM32CubeProgrammer"
   ```

2. Set `JLINK_INSTALL_DIR` in `scripts/power_profiler_config.sh`:

   ```bash
   JLINK_INSTALL_DIR="${HOME}/JLink"
   ```

3. Add your user to the device's group (e.g., `uucp`):

   ```bash
   ls -l /dev/ttyACM0  # Check group (e.g., uucp)
   sudo usermod -a -G uucp $USER
   sudo reboot
   ```

4. Copy and configure udev rules:

   ```bash
   sudo cp scripts/99-stlinkv2_1.rules /etc/udev/rules.d/
   sudo udevadm control --reload-rules
   sudo udevadm trigger
   ```

5. Create symlinks for STM32CubeProgrammer and JLink:

   ```bash
   sudo mkdir -p /opt/SEGGER/JLink
   sudo ln -s /path/to/JLink/ /opt/SEGGER/JLink/
   ``` 

**[Back to top](#table-of-contents)**

### Getting the Source

Clone the repository with `git-lfs` installed:

```bash
git clone --recursive git@github.com:daleonpz/wearable-bruxism.git
```

If you cloned without `--recursive`, run:

```bash
git submodule update --init
git lfs pull
```

**[Back to top](#table-of-contents)**

### Building

1. Start the Nix shell:

   ```bash
   nix develop .
   ```

2. Clone your application:
   
   ```bash
   cd ncs/sdk-version
   west init -m https://github.com/your-name/your-application your-app-worskpace
   cd your-app-workspace
   west update
   ```

3. Build the application, bootloader (MCUBoot), or both, using the provided Makefile. The Makefile is located in the sdk directory **NOT in the application directory**. The directory structure looks like this:

   ```bash
   ncs/v3.0.1/
   ├── bootloader
   ├── build
   ├── Makefile
   ├── modules
   ├── nrf
   ├── nrfxlib
   ├── your-app-workspace
   │   ├── boards
   │   ├── CMakeLists.txt
   │   ├── config
   │   ├── inc
   │   ├── prj.conf
   │   ├── src
   │   ├── sysbuild
   │   ├── sysbuild.conf
   │   ├── tools
   │   ├── VERSION
   │   └── west.yaml
   ├── test
   ├── tools
   └── zephyr
   ```

The Makefile provides targets for building and flashing the application and bootloader:

   ```bash
   make app              # Build otau_example application
   make bootloader       # Build mcuboot bootloader
   make all              # Build both together (default)
   make app-codechecker  # Build application with codechecker
   make flash-app        # Flash application
   make flash-bootloader # Flash bootloader
   make flash            # Flash all (bootloader + application)
   ```

There are several options you can pass to the `make` command:

   ```bash
   make all VERBOSE=1 BOARD=your_board_name APP_DIR=your_app_dir
   make flash APP_DIR=your_app_dir
   ```

   - `VERBOSE`: Show verbose output (0 or 1, default 0).
   - `BOARD`: Target board (default: `nrf52840dk/nrf52840`).
   - `APP_DIR`: Application directory (default: `app`).

3. Clean build directories:

   ```bash
   make clean
   ```

4. See all available targets:

   ```bash
   make help
   ```

**Updating Dependencies**:

- Update `west.yml`: `west update`
- Update `flake.nix` and `flake.lock`: `nix flake update`
- Reload Nix shell: `nix develop .`

**[Back to top](#table-of-contents)**

### Testing

Run tests using Zephyr's Twister framework:

```bash
make test
```

Test results are saved in JUnit XML format in the respective build directories (e.g., `build/otau_example/twister_out`).

**[Back to top](#table-of-contents)**

## Contributing

Contributions are welcome! Please create a pull request on GitHub. Use `pre-commit` to ensure code quality before submitting.

**[Back to top](#table-of-contents)**

## Authors

-  Daniel Paredes (daleonpz)

**[Back to top](#table-of-contents)**

## License

Licensed under the Apache License 2.0. See the LICENSE file for details.

Copyright (c) 2025 Daniel Paredes (daleonpz)

**[Back to top](#table-of-contents)**

## Acknowledgments

- Uses Zephyr RTOS for real-time operation and mcuboot for OTA updates.

## Extras
### BLE Sniffer
This project uses BLE as a communication protocol for the wearable device. The [nRF52840 Dongle](https://www.nordicsemi.com/Products/Development-hardware/nRF52840-Dongle) can be configured as a BLE sniffer to capture and analyze Bluetooth Low Energy packets.

1. Start the power profiler:

   ```bash
   sh scripts/run_power_profiler.sh
   ```

2. Open the Programmer app, select the device (`Open DFU bootloader`).

3. Flash the sniffer firmware:

   ```bash
   # Select: scripts/sniffer_fw/hex/sniffer_nrf51dongle_nrf51422_4.1.1.hex
   # Click "write" to flash
   ```

4. Verify the device appears as `nRF Sniffer for Bluetooth`.

**[Back to top](#table-of-contents)**

