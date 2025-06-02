# Wearable Bruxism

This project is a wearable device application built with Zephyr RTOS to detect and monitor bruxism (teeth grinding) using a sensor on the STM32WB55RG board. It includes an Over-The-Air (OTA) update feature for easy firmware updates. The project is useful for developers creating health-monitoring wearables, offering a lightweight, real-time solution with low power consumption.

## Table of Contents

- [About the Project](#about-the-project)
- [Project Status](#project-status)
- [Getting Started](#getting-started)
    - [Requirements](#requirements)
    - [Getting the Source](#getting-the-source)
    - [Building](#building)
    - [Testing](#testing)
- [Documentation](#documentation)
- [Contributing](#contributing)
- [Authors](#authors)
- [License](#license)
- [Acknowledgments](#acknowledgments)
-[Extras](#extras)
    - [Data Collection](#data-collection)
    - [BLE Sniffer](#ble-sniffer)

## About the Project

The Wearable Bruxism project is a Zephyr-based application that detects teeth grinding using sensors on the STM32WB55RG board. It supports OTA updates via a bootloader (mcuboot), making it easy to update firmware wirelessly. Key features include:

- Real-time bruxism detection with low power consumption.
- OTA firmware updates using mcuboot.
- Data collection for normal and stress-related samples, saved in CSV format.
- Visualization tools for analyzing sensor data in real-time or post-collection.

This project is ideal for developers working on wearable health devices, providing a foundation for sensor-based monitoring with OTA capabilities.

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

2. Build the application, bootloader, or both:

   ```bash
   make app              # Build otau_example application
   make bootloader       # Build mcuboot bootloader
   make combined         # Build both together
   make app-codechecker  # Build application with codechecker
   ```

3. Flash to the board:

   ```bash
   make flash-app        # Flash application
   make flash-bootloader # Flash bootloader
   make flash-combined   # Flash combined build
   ```

4. Clean build directories:

   ```bash
   make clean
   ```

5. See all available targets:

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

## Documentation

Documentation is not currently built locally (Makefile does not include a `docs` target). Check the project GitHub page for any available documentation or contribute to add a `docs` target.

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
### Data Collection
This project includes a Python-based data collection tool to gather sensor data for bruxism detection. It allows you to record normal and stress-related samples, which can be visualized later.

1. Start the Python environment:

   ```bash
   nix develop .
   ```

2. Collect data:

   ```bash
   cd hardware/python
   python datacollector.py
   ```

   - Click `record normal` or `record stress` to save 5-second samples in `normal/` or `stress/` folders.

3. Visualize samples:

   ```bash
   python plot_csv.py  # Plot saved data
   python nir_realtime_plotter.py  # Real-time visualization
   ```

 **[Back to top](#table-of-contents)**

### BLE Sniffer
This project uses BLE as a communication protocol for the wearable device. The nRF52840 Dongle can be configured as a BLE sniffer to capture and analyze Bluetooth Low Energy packets.

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

