#!/usr/bin/env bash
##########################################################################
# This is the Cake bootstrapper script for Linux and OS X.
# This file was downloaded from https://github.com/cake-build/resources
# Feel free to change this file to fit your needs.
##########################################################################

# Define directories.
SCRIPT_DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )
TOOLS_DIR=$SCRIPT_DIR/tools
CAKE_VERSION=0.26.1
CAKE_EXE=$TOOLS_DIR/Cake.CoreClr.$CAKE_VERSION/Cake.dll

# Temporarily skip verification of addins.
export CAKE_SETTINGS_SKIPVERIFICATION='true'

# Define default arguments.
TARGET="Default"
CONFIGURATION="Release"
VERBOSITY="verbose"
DRYRUN=
SCRIPT_ARGUMENTS=()

# Parse arguments.
for i in "$@"; do
    case $1 in
        -t|--target) TARGET="$2"; shift ;;
        -c|--configuration) CONFIGURATION="$2"; shift ;;
        -v|--verbosity) VERBOSITY="$2"; shift ;;
        -d|--dryrun) DRYRUN="-dryrun" ;;
        --) shift; SCRIPT_ARGUMENTS+=("$@"); break ;;
        *) SCRIPT_ARGUMENTS+=("$1") ;;
    esac
    shift
done

# Make sure the tools folder exist.
if [ ! -d "$TOOLS_DIR" ]; then
  mkdir "$TOOLS_DIR"
fi

###########################################################################
# INSTALL .NET CORE CLI
###########################################################################

echo "Installing .NET CLI..."
if [ ! -d "$SCRIPT_DIR/.dotnet" ]; then
  mkdir "$SCRIPT_DIR/.dotnet"
fi
curl -Lsfo "$SCRIPT_DIR/.dotnet/dotnet-install.sh" https://dot.net/v1/dotnet-install.sh
sudo bash "$SCRIPT_DIR/.dotnet/dotnet-install.sh" --version 2.1.4 --install-dir .dotnet --no-path
export PATH="$SCRIPT_DIR/.dotnet":$PATH
export DOTNET_SKIP_FIRST_TIME_EXPERIENCE=1
export DOTNET_CLI_TELEMETRY_OPTOUT=1
"$SCRIPT_DIR/.dotnet/dotnet" --info

###########################################################################
# INSTALL CAKE
###########################################################################

if [ ! -f "$CAKE_EXE" ]; then
    echo "Installing Cake $CAKE_VERSION..."
    curl -Lsfo Cake.zip "https://www.nuget.org/api/v2/package/Cake.CoreClr/$CAKE_VERSION" && unzip -q Cake.zip -d "$TOOLS_DIR/Cake.CoreClr.$CAKE_VERSION" && rm -f Cake.zip
    if [ $? -ne 0 ]; then
        echo "An error occured while installing Cake."
        exit 1
    fi
fi

# Make sure that Cake has been installed.
if [ ! -f "$CAKE_EXE" ]; then
    echo "Could not find Cake.exe at '$CAKE_EXE'."
    exit 1
fi

###########################################################################
# RUN BUILD SCRIPT
###########################################################################

# Start Cake
exec dotnet "$CAKE_EXE" build.cake --verbosity=$VERBOSITY --configuration=$CONFIGURATION --target=$TARGET $DRYRUN "${SCRIPT_ARGUMENTS[@]}"
