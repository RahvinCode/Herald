# Herald

An open-source Final Fantasy XI Windower addon designed for multiboxers to track spellcasts and job abilities across locally connected game sessions, instantly swapping characters into specialized "received-buff" gear sets.

## Overview
When managing multiple characters simultaneously, manually swapping specialized equipment to receive optimization bonuses (such as `sets.Phalanx_Received` or `sets.Cursna_Received`) is impractical. Addons such as React and gearswap systems such as Selendrile's rely on deprecated action packets that take 600 ms or more to register that a cast has started.  With moderate fast cast, this means that your character will be equipping gear after the spell lands, making the swap pointless.

**Herald** resolves this by listening directly to network chunk payloads across your multibox instances to provide alerts to the main and all eligible aoe targets within 0 to 3 ms from the start of cast:
1. **Detection:** Intercepts outgoing action packets (`0x01A`) from a casting character to identify tracked spells or waltzes.
2. **AoE Calculations:** Evaluates active stratagems/buffs (**Accession** or **Majesty**) and runs a live 3D Euclidean distance vector check (within 10 yalms) to cleanly map all affected party members.
3. **IPC Broadcast:** Instantly fires data strings over Inter-Process Communication (IPC) to notify receiving characters.  Strings are encoded to prevent malicious injection from other players.
4. **Automation:** The receiving character swaps into target equipment, monitors incoming server action notifications (`0x028`), and updates back to their standard layout (`gs c update auto`) exactly when casting completes, is interrupted, or hits a customizable frame-rendered failsafe timer. Use herald_gear_sets.lua to set up your character-specific sets.  Herald does not use your characters's sets defined in gearswap, but does use custom commands.  See setup instructions. Optionally, lock gear in place while cast is incoming to prevent overwriting your gear due to combat actions.

---

## Features
* **Cross-Instance Network Syncing** — Communicates states instantly across active local sessions via Windower's IPC channel.
* **Smart AoE Target Packaging** — Calculates 3D distance positions relative to the spell target to include every nearby party member in a single, grouped string payload.  Accounts for native aoe, Accession and Majesty.
* **Granular Tracking Filters** — Deep support across specific critical spell and ability categories:
  * **Cures & Waltzes:** All tiers of Cure, Curaga, Cura, Curing Waltz, and Divine Waltz.
  * **Enhancing Magic:** Phalanx I/II, Regen I–V, Refresh I-III, Protect I–V, Shell I–V, Protectra I–V, and Shellra I–V.
  * **Status Removal:** Cursna.
* **Frame-Rendered Failsafe** — Utilizes a frame-timed event loop to guarantee equipment updates restore cleanly if an unexpected connection or status exception drops a packet handler.

---

## Gearswap Customization
By default, Herald triggers gearswap to equip sets configured in herald_gear_sets.lua. This requires custom commands in your gearswap include or job-specific gearswap file. The modified Mirdain-Include.lua that is packaged with this addon is a direct plug and play replacement for Mirdain gearswap ecosystem.  It is recommended to not use Selendriles with this addon, as Selendrile gearswap utilizes delayed action packets to perform gear swaps 600-1000ms after cast time, causing your character to equip their set after the spell has landed in most cases.  See Installation below for custom setups outside of Mirdain gearswap ecosystem.

---

## Installation for Mirdain Gearswap Users
1. Download the repository source files.
2. Navigate to your `Windower4/addons/` directory and create a new folder named `Herald`.
3. Drop the `Herald.lua` and `herald_gear_sets.lua` script inside that folder.
4. Open `herald_gear_sets.lua` in your preferred text editor or IDE and create your custom sets for each character.  All spell received increasing gear is listed at the bottom of the file for your convenience.
5. Navigate to your `Windower4/addons/GearSwap/data` directory and copy/paste the `Mirdain-Include.lua` file.
6. Open your game client and load the addon via the chat console `//lua load herald`
7. Reload your gearswap using the chat console `//lua reload gearswap` 
8. Use `//her help` to see the available commands to turn on and off spell groups, modify failsafe delay and enable or disable locking of gear, warnings and ebug mode. 

## Installation for other Gearswap Users
1. Download the repository source files.
2. Navigate to your `Windower4/addons/` directory and create a new folder named `Herald`.
3. Drop the `Herald.lua` and `herald_gear_sets.lua` script inside that folder.
4. Open `herald_gear_sets.lua` in your preferred text editor or IDE and create your custom sets for each character.  All spell received increasing gear is listed at the bottom of the file for your convenience.
5. Navigate to your `Windower4/addons/GearSwap/data` directory open `Herald_Gearswap_Commands` file. Copy/Paste the active_external_locks = {} toward the top of your job-specific gearswap file and copy/paste the function self_command(cmd) section into your existing self_command function, or copy/paste the whole function if none exists in your current gs.
6. Open your game client and load the addon via the chat console `//lua load herald`
7. Reload your gearswap using the chat console `//lua reload gearswap` 
8. Use `//her help` to see the available commands to turn on and off spell groups, modify failsafe delay and enable or disable locking of gear, warnings and ebug mode. 
---

## Commands
The addon recognizes both `//herald` and `//her` command aliases. 

*Note: Toggling tracking filters or debug modes will broadcast a synchronized update over IPC to automatically update configurations across all open instances concurrently.*

| Command | Action |
| :--- | :--- |
| `//herald on` | Enables global packet monitoring and gear state handling. |
| `//herald off` | Disables the addon completely. |
| `//herald lock` | Toggles locking of spell equipment into Herald sets during incoming tracked spells and abilities. |
| `//herald warn` | Toggles chat log warnings for when gear is equipped or sets are not configured for tracked incoming spells and abilities. |
| `//herald cure` | Toggles tracking for incoming Cures and Waltzes. |
| `//herald cursna` | Toggles tracking for incoming Cursna casts. |
| `//herald phalanx` | Toggles tracking for incoming Phalanx I & II spells. |
| `//herald protect` | Toggles tracking for incoming Protect, Shell, Protectra, and Shellra spells. |
| `//herald refresh` | Toggles tracking for incoming Refresh spells. |
| `//herald regen` | Toggles tracking for incoming Regen spells. |
| `//herald waltz` | Toggles tracking for incoming Curing and Divine Waltz abilities. |
| `//herald delay <seconds>` | Adjusts the frame-rendered failsafe reset threshold (Must be $\ge$ 1.5 seconds). |
| `//herald debug` | Toggles deep developer timestamp logs inside the chat screen. |

---

## License
Copyright © 2026 RahvinCode. This project is open-source software licensed under the terms of the **MIT License**.
