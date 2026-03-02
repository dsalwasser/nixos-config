{pkgs, ...}: let
  script = pkgs.writeShellApplication {
    name = "qemu-boot";

    runtimeInputs = [pkgs.qemu pkgs.OVMF.fd];

    text = ''
      if [ "$#" -ne 1 ]; then
        echo "Error: Invalid number of arguments."
        echo "Usage: nix run .#qemu-boot -- <file.iso|file.raw>"
        exit 1
      fi

      FILE="$1"
      OVMF_BIN="${pkgs.OVMF.fd}/FV/OVMF.fd"

      if [ ! -f "$FILE" ]; then
        echo "Error: File '$FILE' not found."
        exit 1
      fi

      echo "Starting VM with: '$FILE'."

      QEMU_ARGS=(
        -enable-kvm
        -device virtio-vga-gl
        -display "sdl,gl=on"
        -bios "$OVMF_BIN"
        -cpu host
        -m 2G
      )

      if [[ "$FILE" == *.iso ]]; then
        QEMU_ARGS+=(-cdrom "$FILE")
      else
        if [ ! -w "$FILE" ]; then
          echo "Error: You do not have write permissions for '$FILE'."
          exit 1
        fi
        QEMU_ARGS+=("-drive" "file=$FILE,format=raw,if=virtio")
      fi

      echo -e "Executing command: qemu-system-x86_64 ''${QEMU_ARGS[*]}\n"
      exec qemu-system-x86_64 "''${QEMU_ARGS[@]}"
    '';
  };
in {
  type = "app";
  program = "${script}/bin/qemu-boot";
}
