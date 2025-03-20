#!/bin/bash
# build.sh: Execute CMake configuration and build process to run the install_dotfiles target

set -e  # Exit on error

# Create a build directory if it doesn't exist
if [ ! -d "build" ]; then
    mkdir build
fi

cd build

# Run CMake to configure the project
cmake ..

# Build and run the custom target install_dotfiles
cmake --build . --target install_dotfiles

