# MintBlueprint

> Export and recreate your complete Linux Mint environment — packages, interface, tools and personalization — in a clean, reproducible way.

MintBlueprint is a lightweight system replication toolkit built for Linux Mint users who want to audit, document and rebuild their working environment on a new machine.

It does not clone your files.

It extracts your system blueprint.

---

## ✨ What It Does

MintBlueprint scans and structures:

- Installed APT packages (manual and system)
- Flatpak applications
- Snap packages
- Development toolchains
- Design and creative software
- Cinnamon interface customization
- GTK, icon and cursor themes
- Enabled extensions, applets and desklets
- Login manager and boot splash configuration
- Active repositories

It then generates:

- A structured TXT audit report
- A selective installation script
- A reproducible deployment workflow

---

## 🎯 Philosophy

MintBlueprint is not a backup tool.

It is a system blueprint generator.

Instead of copying your machine, it extracts its structure so you can rebuild it intentionally, cleanly and selectively.

No personal files.  
No `/home` cloning.  
Only system-level configuration and applications.

---

## 🧠 Ideal Use Cases

- Migrating to a new MacBook running Linux Mint
- Recreating a macOS-like Mint customization
- Standardizing development environments
- Rebuilding after clean installs
- Auditing installed tools and dependencies
- Creating reproducible workstation setups

---

## ⚙ Requirements

- Linux Mint (Cinnamon recommended)
- Bash
- APT package manager
- Optional: Flatpak and Snap (if used)

---

## 🚀 Usage

### 1️⃣ On the Original Machine

Run:

```bash
bash exportar-sistema.sh
