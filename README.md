Install `git` package:

```bash
pacman -Syy git
```

Clone this repo:

```bash
git clone https://github.com/serhatcelik/arch-clean.git
```

Then run the commands below as `root` user:

```bash
cd arch-clean
chmod +x install.sh
./install.sh
cd ..
rm -rf arch-clean
```

Reboot and log in as new user.

**Tested under Arch Linux 2024.02.01**
