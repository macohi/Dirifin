# Compiling

This page will cover all the steps needed to download and compile the source code for Dirifin on your device.

## Requirements

- [Haxe 4.3.7+](https://haxe.org/download/)
- [Git](https://www.git-scm.com)

## Instructions

1. Run `cd where\you\want\the\source` to change your directory to where you wish to download the source.
2. Run `git clone https://github.com/macohi/Dirifin.git` to clone the repository.
3. Run `cd Dirifin` to enter the source code directory.
4. Run `git submodule update --init --recursive`.
5. Run `.\source\macohi\install.bat` to install the necessary dependencies.
6. To test that everything is working, run `lime test <your platform>`(e.g., `lime test windows` or `lime test html5`)