#!/bin/bash
detect_os() { 
  detected_platform="$(uname -s | tr '[:upper:]' '[:lower:]')"

  case "$detected_platform" in
    linux*)
      printf '%s\n' "Detected OS: Linux."
      PLATFORM="linux"
      FILE_EXTENSION="zip"
      ;;
    darwin*)
      printf '%s\n' "Detected OS: macOS."
      PLATFORM="macos"
      FILE_EXTENSION="pkg"
      ;;
    *)
      printf '%s\n' "Unsupported OS: \"$detected_platform\"."
      exit 1
      ;;
  esac

  export PLATFORM
  export FILE_EXTENSION
}

detect_arch() {
    detected_arch="$(uname -m)"
    
    case "$detected_arch" in
        x86_64 | amd64)
          printf '%s\n' "Detected Arch: x86_64."
          ARCH=x86_64 ;;
        arm64 | aarch64)
          printf '%s\n' "Detected Arch: arm64."
          ARCH=arm64 ;;
        *) return 1 ;;
    esac

    export ARCH
}

set_sudo () {
    if [ "$(id -u)" -ne 0 ] && which sudo > /dev/null ; then
        SUDO="sudo"
    fi

    export SUDO
}