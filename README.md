Run this one-liner as `root` user:

```bash
pacman -Syy --noconfirm git && git clone https://github.com/serhatcelik/arch-clean.git && cd arch-clean && chmod +x install.sh && ./install.sh && cd .. && rm -rf arch-clean
```

Reboot and log in as new user.

**Tested under Arch Linux 2024.02.01**
