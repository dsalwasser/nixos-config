{pkgs, ...}: let
  script = pkgs.writeShellApplication {
    name = "qemu-boot";

    runtimeInputs = [pkgs.qemu pkgs.OVMF.fd];

    text = ''
      if [ "$#" -ne 1 ]; then
        echo "Error: Invalid number of arguments."
        echo "Usage: nix run .#qemu-boot -- <disk-image.raw>"
        exit 1
      fi

      DISK_IMAGE="$1"
      OVMF_BIN="${pkgs.OVMF.fd}/FV/OVMF.fd"

      if [ ! -f "$DISK_IMAGE" ]; then
        echo "Error: File '$DISK_IMAGE' not found."
        exit 1
      fi

      if [ ! -w "$DISK_IMAGE" ]; then
        echo "Error: You do not have write permissions for '$DISK_IMAGE'."
        exit 1
      fi

      echo "Starting VM with image: '$DISK_IMAGE'."

      exec qemu-system-x86_64 \
        -enable-kvm \
        -m 2G \
        -drive file="$DISK_IMAGE",format=raw,if=virtio \
        -bios "$OVMF_BIN" \
        -device virtio-vga-gl \
        -display sdl,gl=on \
        -cpu host
    '';
  };
in {
  type = "app";
  program = "${script}/bin/qemu-boot";
}
