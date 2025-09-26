# 🚗 capo_clearkeys

A lightweight FiveM resource that gives players and server owners an easy way to **manage and clear vehicle key items** from inventories.  
Supports all major frameworks and inventory systems out of the box, with localization, notifications, and simple configuration.

---

## ✨ Core Features

- 🗑️ **Clear all keys** in your inventory instantly.  
- 🚗 **Keep only the closest vehicle’s key** (auto-detects nearby plates).  
- 🔑 **Keep only your current vehicle’s key** (if you’re inside a vehicle).  
- ⚙️ **Framework autodetect** — works with **QBCore**, **QBX**, or **ESX**.  
- 📦 **Inventory autodetect** — supports **ox_inventory**, **qs-inventory**, **qb/ps-inventory**, or ESX inventory.  
- 🖥️ **Clean UI** — ox_lib context menu with customizable keybind & command.  
- 🔔 **Flexible notifications** — ox_lib, framework notify, custom notify, or console fallback.  
- 🌍 **Multi-language support** with easy overrides (English, ES, DE, FR, IT, PT, TR, RU, AR, PL, NL).  
- 🔒 **Server-authoritative** — all item removal is handled on the server.  

---

## 📦 Requirements

- **Framework**: QBCore / QBX / ESX  
- **Inventory**: ox_inventory / qs-inventory / qb-inventory / ps-inventory / ESX inventory  
- **UI library**: [ox_lib](https://github.com/overextended/ox_lib)  

---

## ⚙️ Installation

1. **Download** and place the resource in your server’s resources folder:
2. Add to your `server.cfg` **after** framework and inventory:
3. Edit [`config.lua`](./config.lua) to match your server’s setup (item name, locale, notify, etc.).

---

## 🕹️ Usage

- Default command: `/clearkeys`  
- Default keybind: **F7** (can be changed in `config.lua`)  
- Optional **ox_target** integration — interact with vehicles directly.  
- Players will see a menu with three options:
- **Remove ALL keys**  
- **Keep closest vehicle key**  
- **Keep current vehicle key**  

---

## 🌍 Localization

- Fully localized in multiple languages (EN, ES, DE, FR, IT, PT, TR, RU, AR, PL, NL).  
- Fallback to English if a string is missing.  
- Easily override or add your own strings in [`locales.lua`](./locales.lua).  

---

## 🛠️ Configuration Highlights

- `Config.KeyItem` → name of your key item (default: `vehiclekeys`).  
- `Config.Command` / `Config.KeyMapping` → change command and keybind.  
- `Config.NotifyProvider` → choose `ox`, `qb`, `qbx`, `esx`, `custom`, or `print`.  
- `Config.Locale` → auto-detect or force specific language.  
- `Config.Target*` → enable and customize ox_target support.  

---

## 📜 License & Credits

- Licensed under the **MIT License** (see [LICENSE](./LICENSE)).  
- Please provide attribution if you use or redistribute:  

### 💡 Why use this?
Because vehicle key spam is messy — this keeps your players’ inventories clean, avoids duplicate key issues, and works no matter what framework or inventory you’re running.