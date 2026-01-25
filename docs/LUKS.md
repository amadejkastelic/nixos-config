# LUKS FIDO2 Setup Guide

This guide covers setting up YubiKey FIDO2 unlock for LUKS-encrypted NixOS systems.

## Prerequisites

- YubiKey 5 series (with FIDO2 support)
- LUKS2-encrypted partition (convert from LUKS1 if needed)

## Step 1: Check LUKS Version

```bash
sudo cryptsetup luksDump /dev/nvme0n1p2 | head -n 1
```

If it shows `Version: 1`, you need to convert to LUKS2 first.

## Step 2: Convert LUKS1 to LUKS2 (if needed)

**Important: Do this from a live USB with the device unmounted**

```bash
# Boot NixOS installer ISO

# Backup LUKS header
sudo cryptsetup luksHeaderBackup /dev/nvme0n1p2 \
  --header-backup-file /run/media/usb/luks-header.backup

# Convert to LUKS2
sudo cryptsetup convert /dev/nvme0n1p2 --type luks2

# Verify
sudo cryptsetup luksDump /dev/nvme0n1p2 | head -n 1  # Should show "Version: 2"

reboot
```

## Step 3: Find Your LUKS Device UUID

```bash
lsblk -f
sudo blkid | grep crypto_LUKS
```

Note the UUID (e.g., `836e758a-4fe0-4e78-a965-edfcf1f1445a`).

## Step 4: Enroll YubiKey

```bash
nix-shell -p systemd cryptsetup libfido2

# Verify YubiKey is detected
systemd-cryptenroll --fido2-device=list

# Enroll with PIN and touch required
sudo systemd-cryptenroll --fido2-device=auto \
  --fido2-with-client-pin=yes \
  --fido2-with-user-presence=yes \
  /dev/nvme0n1p2
```

**Enter your current LUKS passphrase, set/enter YubiKey PIN, and touch the key when it blinks.**

## Step 5: Verify Enrollment

```bash
sudo cryptsetup luksDump /dev/nvme0n1p2
```

Look for `systemd-fido2` token in the output.

## Step 6: Configure NixOS

Add to your host's `hardware-configuration.nix` or similar:

```nix
boot.initrd.luks.fido2 = {
  enable = true;
  device = "836e758a-4fe0-4e78-a965-edfcf1f1445a";  # Your UUID
  extraOpts = [ "timeout=0" ];  # Optional: disable timeout
};
```

**Note:** This assumes you have the custom LUKS FIDO2 module imported in your system configuration.

## Troubleshooting

### Check if FIDO2 was used at boot:
```bash
journalctl -b | grep -i fido2
journalctl -b | grep cryptsetup
```

### Remove FIDO2 token if needed:
```bash
# List key slots
sudo cryptsetup luksDump /dev/nvme0n1p2

# Remove specific slot (e.g., slot 1)
sudo cryptsetup luksKillSlot /dev/nvme0n1p2 1
```

### Multiple YubiKeys:
Enroll additional keys for redundancy:
```bash
sudo systemd-cryptenroll --fido2-device=auto \
  --fido2-with-client-pin=yes \
  --fido2-with-user-presence=yes \
  /dev/nvme0n1p2
```

## Notes

- FIDO2 uses a separate application on the YubiKey—OTP slots remain untouched
- Your existing slot 2 challenge-response (if used for PC unlock) is not affected
- Always keep your passphrase as a backup unlock method
- Consider enrolling multiple YubiKeys for redundancy
