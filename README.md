# Herald

An open-source Final Fantasy XI Windower addon designed for multiboxers to track spellcasts and job abilities across locally connected game sessions, instantly swapping characters into specialized "received-buff" gear sets.

## Overview
When managing multiple characters simultaneously, manually swapping specialized equipment to receive optimization bonuses (such as `sets.Phalanx_Received` or `sets.Cursna_Received`) is impractical. 

**Herald** resolves this by listening directly to network chunk payloads across your multibox instances:
1. **Detection:** Intercepts outgoing action packets (`0x01A`) from a casting character to identify tracked spells or waltzes.
2. **AoE Calculations:** Evaluates active stratagems/buffs (**Accession** or **Majesty**) and runs a live 3D Euclidean distance vector check (within 10 yalms) to cleanly map all affected party members.
3. **IPC Broadcast:** Instantly fires data strings over Inter-Process Communication (IPC) to notify receiving characters.
4. **Automation:** The receiving character swaps into target equipment, monitors incoming server action notifications (`0x028`), and updates back to their standard layout (`gs c update auto`) exactly when casting completes, is interrupted, or hits a customizable frame-rendered failsafe timer.

---

## Features
* **Cross-Instance Network Syncing** — Communicates states instantly across active local sessions via Windower's IPC channel.
* **Smart AoE Target Packaging** — Calculates 3D distance positions relative to the spell target to include every nearby party member in a single, grouped string payload.
* **Granular Tracking Filters** — Deep support across specific critical spell and ability categories:
  * **Cures & Waltzes:** All tiers of Cure, Curaga, Cura, Curing Waltz, and Divine Waltz.
  * **Enhancing Magic:** Phalanx I/II, Regen I–V, Protect I–V, Shell I–V, Protectra I–V, and Shellra I–V.
  * **Status Removal:** Cursna.
* **Frame-Rendered Failsafe** — Utilizes a `prerender` event loop to guarantee equipment updates restore cleanly if an unexpected connection or status exception drops a packet handler.

---

## Gearswap Customization
By default, Herald triggers targeted equipment macros directly inside your active Gearswap profiles. Ensure the variables at the top of your `Herald.lua` file map properly to your layout:

```lua
local cure_set = "sets.Cure_Received"
local cursna_set = "sets.Cursna_Received"
local phalanx_set = "sets.Phalanx_Received"
local protect_shell_set = "sets.Protect_Shell_Received"
local regen_set = "sets.Regen_Received"
local equip_reset_command = "gs c update auto"
```

---

## Installation
1. Download the repository source files.
2. Navigate to your `Windower4/addons/` directory and create a new folder named `Herald`.
3. Drop the `Herald.lua` script inside that folder.
4. Open your game client and load the addon via the chat console:  
   `//lua load herald`
5. Add or modify your existing gearswap buff and cure received sets, or use the default set names listed above.
6. Change the equip_reset_command variable to match the command your gearswap uses to trigger choosing a set.  This software was designed to work with gs c apdate auto, which is standard for Mirdain's ecosystem, but can be adapted to any.

---

## Commands
The addon recognizes both `//herald` and `//her` command aliases. 

*Note: Toggling tracking filters or debug modes will broadcast a synchronized update over IPC to automatically update configurations across all open instances concurrently.*

| Command | Action |
| :--- | :--- |
| `//herald on` | Enables global packet monitoring and gear state handling. |
| `//herald off` | Disables the addon completely. |
| `//herald cure` | Toggles tracking for incoming Cures and Waltzes. |
| `//herald cursna` | Toggles tracking for incoming Cursna casts. |
| `//herald phalanx` | Toggles tracking for incoming Phalanx I & II spells. |
| `//herald regen` | Toggles tracking for incoming Regen tiers. |
| `//herald protect` | Toggles tracking for incoming Protect, Shell, Protectra, and Shellra tiers. |
| `//herald delay <seconds>` | Adjusts the frame-rendered failsafe reset threshold (Must be $\ge$ 1.5 seconds). |
| `//herald debug` | Toggles deep developer timestamp logs inside the chat screen. |

---

## License
Copyright © 2026 RahvinCode. This project is open-source software licensed under the terms of the **MIT License**.
