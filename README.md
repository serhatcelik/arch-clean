Run this one-liner from a non-root user:

```bash
pacman -Syy --noconfirm --needed git && git clone https://github.com/serhatcelik/arch-clean.git && cd arch-clean && chmod +x install.sh && ./install.sh && cd .. && rm -rf arch-clean
```

Log out and log back in again.

**Tested under Arch Linux 2024.02.01**
