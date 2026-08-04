--[[
Copyright 2026 RahvinCode: http://www.github.com/rahvincode

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated
documentation files (the “Software”), to deal in the Software without restriction, including without
limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies
of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following
conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions
of the Software.

THE SOFTWARE IS PROVIDED “AS IS”, WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED
TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL
THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF
CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER
DEALINGS IN THE SOFTWARE.
]] --

_addon.name = 'Herald'
_addon.author = 'Rahvin'
_addon.version = '2.1'
_addon.commands = { 'her', 'herald' }

local packets = require('packets')
local res = require('resources')
local config = require('config')
local socket = require('socket')
local gear_sets = require('herald_gear_sets')

--Default Settings.  Overridden by Character Specific Settings.
local default_settings = {
    addon_enabled = true,
    debug_mode = false,
    delay = 3,
    gear_lock = true,
    warn = true,
    track_cure = true,
    track_cursna = true,
    track_phalanx = true,
    track_protect_shell = true,
    track_refresh = true,
    track_regen = true,
    track_waltz = true,
}
local settings = {}
local chat_color = 121
local outgoing_cast_active = false
local active_incoming_casters = {}
local cast_start_time = 0
local failsafe_active = false
local failsafe_trigger_time = 0

-- Spell definitions with metadata to dictate equipment categories and AoE rules
local spell_info = {
    -- Cursna
    [20] = { name = "Cursna", category = 'track_cursna', equip = "cursna_set", aoe = false, majesty = false, accession = true },                      --Cursna
    -- Phalanx
    [106] = { name = "Phalanx", category = 'track_phalanx', equip = "phalanx_set", aoe = false, majesty = false, accession = true },                  --Phalanx
    [107] = { name = "Phalanx II", category = 'track_phalanx', equip = "phalanx_set", aoe = false, majesty = false, accession = false },              --Phalanx II
    -- Regen
    [108] = { name = "Regen", category = 'track_regen', equip = "regen_set", aoe = false, majesty = false, accession = true },                        --Regen
    [110] = { name = "Regen II", category = 'track_regen', equip = "regen_set", aoe = false, majesty = false, accession = true },                     --Regen II
    [111] = { name = "Regen III", category = 'track_regen', equip = "regen_set", aoe = false, majesty = false, accession = true },                    --Regen III
    [477] = { name = "Regen IV", category = 'track_regen', equip = "regen_set", aoe = false, majesty = false, accession = true },                     --Regen IV
    [504] = { name = "Regen V", category = 'track_regen', equip = "regen_set", aoe = false, majesty = false, accession = true },                      --Regen V
    -- Protect
    [43] = { name = "Protect", category = 'track_protect_shell', equip = "protect_shell_set", aoe = false, majesty = true, accession = true },        --Protect
    [44] = { name = "Protect II", category = 'track_protect_shell', equip = "protect_shell_set", aoe = false, majesty = true, accession = true },     --Protect II
    [45] = { name = "Protect III", category = 'track_protect_shell', equip = "protect_shell_set", aoe = false, majesty = true, accession = true },    --Protect III
    [46] = { name = "Protect IV", category = 'track_protect_shell', equip = "protect_shell_set", aoe = false, majesty = true, accession = true },     --Protect IV
    [47] = { name = "Protect V", category = 'track_protect_shell', equip = "protect_shell_set", aoe = false, majesty = true, accession = true },      --Protect V
    [125] = { name = "Protectra", category = 'track_protect_shell', equip = "protect_shell_set", aoe = true, majesty = true, accession = false },     --Protectra
    [126] = { name = "Protectra II", category = 'track_protect_shell', equip = "protect_shell_set", aoe = true, majesty = true, accession = false },  --Protectra II
    [127] = { name = "Protectra III", category = 'track_protect_shell', equip = "protect_shell_set", aoe = true, majesty = true, accession = false }, --Protectra III
    [128] = { name = "Protectra IV", category = 'track_protect_shell', equip = "protect_shell_set", aoe = true, majesty = true, accession = false },  --Protectra IV
    [129] = { name = "Protectra V", category = 'track_protect_shell', equip = "protect_shell_set", aoe = true, majesty = true, accession = false },   --Protectra V
    -- Shell
    [48] = { name = "Shell", category = 'track_protect_shell', equip = "protect_shell_set", aoe = false, majesty = false, accession = true },         --Shell
    [49] = { name = "Shell II", category = 'track_protect_shell', equip = "protect_shell_set", aoe = false, majesty = false, accession = true },      --Shell II
    [50] = { name = "Shell III", category = 'track_protect_shell', equip = "protect_shell_set", aoe = false, majesty = false, accession = true },     --Shell III
    [51] = { name = "Shell IV", category = 'track_protect_shell', equip = "protect_shell_set", aoe = false, majesty = false, accession = true },      --Shell IV
    [52] = { name = "Shell V", category = 'track_protect_shell', equip = "protect_shell_set", aoe = false, majesty = false, accession = true },       --Shell V
    [130] = { name = "Shellra", category = 'track_protect_shell', equip = "protect_shell_set", aoe = true, majesty = false, accession = false },      --Shellra
    [131] = { name = "Shellra II", category = 'track_protect_shell', equip = "protect_shell_set", aoe = true, majesty = false, accession = false },   --Shellra II
    [132] = { name = "Shellra III", category = 'track_protect_shell', equip = "protect_shell_set", aoe = true, majesty = false, accession = false },  --Shellra III
    [133] = { name = "Shellra IV", category = 'track_protect_shell', equip = "protect_shell_set", aoe = true, majesty = false, accession = false },   --Shellra IV
    [134] = { name = "Shellra V", category = 'track_protect_shell', equip = "protect_shell_set", aoe = true, majesty = false, accession = false },    --Shellra V
    -- Cure
    [1] = { name = "Cure", category = 'track_cure', equip = "cure_set", aoe = false, majesty = true, accession = true },                              --Cure
    [2] = { name = "Cure II", category = 'track_cure', equip = "cure_set", aoe = false, majesty = true, accession = true },                           --Cure II
    [3] = { name = "Cure III", category = 'track_cure', equip = "cure_set", aoe = false, majesty = true, accession = true },                          --Cure III
    [4] = { name = "Cure IV", category = 'track_cure', equip = "cure_set", aoe = false, majesty = true, accession = true },                           --Cure IV
    [5] = { name = "Cure V", category = 'track_cure', equip = "cure_set", aoe = false, majesty = true, accession = false },                           --Cure V
    [6] = { name = "Cure VI", category = 'track_cure', equip = "cure_set", aoe = false, majesty = true, accession = false },                          --Cure VI
    -- Curaga / Cura
    [7] = { name = "Curaga", category = 'track_cure', equip = "cure_set", aoe = true, majesty = false, accession = false },                           --Curaga
    [8] = { name = "Curaga II", category = 'track_cure', equip = "cure_set", aoe = true, majesty = false, accession = false },                        --Curaga II
    [9] = { name = "Curaga III", category = 'track_cure', equip = "cure_set", aoe = true, majesty = false, accession = false },                       --Curaga III
    [10] = { name = "Curaga IV", category = 'track_cure', equip = "cure_set", aoe = true, majesty = false, accession = false },                       --Curaga IV
    [11] = { name = "Curaga V", category = 'track_cure', equip = "cure_set", aoe = true, majesty = false, accession = false },                        --Curaga V
    [93] = { name = "Cura", category = 'track_cure', equip = "cure_set", aoe = true, majesty = false, accession = false },                            --Cura
    [474] = { name = "Cura II", category = 'track_cure', equip = "cure_set", aoe = true, majesty = false, accession = false },                        --Cura II
    [475] = { name = "Cura III", category = 'track_cure', equip = "cure_set", aoe = true, majesty = false, accession = false },                       --Cura III
    --Refresh
    [109] = { name = "Refresh", category = 'track_refresh', equip = "refresh_set", aoe = false, majesty = false, accession = true },                  --Refresh
    [473] = { name = "Refresh II", category = 'track_refresh', equip = "refresh_set", aoe = false, majesty = false, accession = false },              --Refresh II
    [894] = { name = "Refresh III", category = 'track_refresh', equip = "refresh_set", aoe = false, majesty = false, accession = false },             --Refresh III
}

-- Consolidated abilities mapping
local ability_info = {
    [190] = { name = "Curing Waltz", category = 'track_waltz', equip = "waltz_set", aoe = false, accession = false },     --Curing Waltz
    [191] = { name = "Curing Waltz II", category = 'track_waltz', equip = "waltz_set", aoe = false, accession = false },  --Curing Waltz II
    [192] = { name = "Curing Waltz III", category = 'track_waltz', equip = "waltz_set", aoe = false, accession = false }, --Curing Waltz III
    [193] = { name = "Curing Waltz IV", category = 'track_waltz', equip = "waltz_set", aoe = false, accession = false },  --Curing Waltz IV
    [311] = { name = "Curing Waltz V", category = 'track_waltz', equip = "waltz_set", aoe = false, accession = false },   --Curing Waltz V
    [195] = { name = "Divine Waltz", category = 'track_waltz', equip = "waltz_set", aoe = true, accession = false },      --Divine Waltz
    [262] = { name = "Divine Waltz II", category = 'track_waltz', equip = "waltz_set", aoe = true, accession = false },   --Divine Waltz II
}

--Get the time in milliseconds from socket to provide synchronous time for all clients.
--Must use socket instead of os.clock() for this purpose
local function get_time()
    return math.floor(socket.gettime() * 1000)
end

--Helper function to count the number of items in the top level of a table.
local function count_keys(tbl)
    local count = 0
    for _ in pairs(tbl) do
        count = count + 1
    end
    return count
end

--Log a formatted message to chat in preferred color
local function log_echo(message)
    windower.add_to_chat(chat_color, '[Herald] ' .. message)
end

--Used for info-toggled display of gear swaps
local function info_echo(message)
    if not settings.warn then return end
    windower.add_to_chat(chat_color, '[Herald] ' .. message)
end

--Used to display timestamped debug messages when debug mode is on
local function debug(message)
    if not settings.debug_mode then return end
    windower.add_to_chat(chat_color, "[Herald] [Time: " .. get_time() .. "] DEBUG: " .. message)
end

local function validate_table(tbl, resource_table)
    for id, data in pairs(tbl) do
        if data.name == resource_table[id].en then
            debug("Validated Herald ID " ..
                id ..
                ": " ..
                data.name .. " matches Windower resource ID " .. resource_table[id].id .. ": " .. resource_table[id].en)
        else
            log_echo("Spell/Ability ID " ..
                id .. " for " .. data.name .. " does not match resource table.  Searching for correct ID")
            for resource_id, resource_data in pairs(resource_table) do
                if data.name == resource_data.en then
                    tbl[resource_id] = data
                    tbl[id] = nil
                    log_echo("Table ID " ..
                        resource_id ..
                        " in resource table matches " ..
                        data.name .. ".  Adding to spell table and removing invalid entry.")
                    if tbl[id] then
                        log_echo("ID removal unsuccessful for " .. id ": " .. data.name)
                    end
                    break
                end
            end
        end
    end
end

--Turn a table into a flat string in a GS lua format that can be encoded into HEX for data security.
--This protects against malicious actors sending you gs c herald_lock_equip updates through
--text or injection. Hex string decode performed by herald gearswap functions.
local function tstring(tbl)
    if type(tbl) == 'number' then
        return tostring(tbl)
    elseif type(tbl) ~= 'table' then
        return string.format("%q", tbl)
    end

    local result = "{"
    for k, v in pairs(tbl) do
        local key
        if type(k) == "string" and k:match("^[%a_][%w_]*$") then
            key = k .. "="
        else
            key = type(k) == "string" and "[\"" .. k .. "\"]=" or "[" .. k .. "]="
        end
        result = result .. key .. tstring(v) .. ","
    end

    if #result > 1 then
        result = result:sub(1, -2)
    end
    return result .. "}"
end

--Equip the gear set corresponding to the spell or ability being cast
local function equip_gear(spell_id, player_name, player_job, type)
    debug("Equip gear function triggered: " .. spell_id .. ", " .. player_name .. ", " .. player_job .. ", " .. type)
    local info = {}
    if type == "spell" then
        info = spell_info[spell_id]
    elseif type == "ability" then
        info = ability_info[spell_id]
    end

    --Calculate delta since cast start time in milliseconds
    local elapsed_ms = get_time() - cast_start_time

    --Checks if the spell id exists in the Herald tables before attempting to equip gear
    if info then
        --Checks that the player has gear_sets_herald.lua sets defined for the incoming spell
        if gear_sets[player_name] and gear_sets[player_name][info.equip] then
            local target_set = {}
            if gear_sets[player_name][info.equip][player_job] and next(gear_sets[player_name][info.equip][player_job]) ~= nil then
                info_echo("Equipping spell received set [" ..
                    player_name .. "] [" .. info.equip .. "] [" .. player_job .. "]")
                target_set = gear_sets[player_name][info.equip][player_job]
            elseif gear_sets[player_name][info.equip]["all_jobs"] and next(gear_sets[player_name][info.equip]["all_jobs"]) ~= nil then
                info_echo("Equipping spell received set [" .. player_name .. "] [" .. info.equip .. "] [all_jobs]")
                target_set = gear_sets[player_name][info.equip]["all_jobs"]
            else
                info_echo("Herald gear set [" ..
                    player_name ..
                    "] [" ..
                    info.equip ..
                    "] [all_jobs]/[" .. player_job .. "] not found or are empty. Customize in herald_gear_sets.lua.")
            end

            -- Find and initialize a gear set table from gear_sets_herald.lua for encoding.
            -- Convert the table into a raw Lua code string: "{ waist = 'Gishdubar Sash', ... }"
            -- Encode the string in HEX to prevent malicious actors from spoofing your gearswap commands.
            local set_string = tstring(target_set)
            local hex_string = set_string:gsub('.', function(c)
                return string.format('%02x', string.byte(c))
            end)
            debug(string.format("Sending Equip Command: %s ms after cast start.", elapsed_ms))
            debug("Serialized string is: " .. set_string)
            debug("Hex string is: " .. hex_string)

            --Send the encoded equipment set to gearswap
            if settings.gear_lock then
                windower.send_command("gs c herald_lock_equip " .. hex_string)
                debug("Sending command gs c herald_lock_equip " .. hex_string)
            else
                windower.send_command("gs c herald_equip " .. hex_string)
                debug("Sending command gs c herald_equip " .. hex_string)
            end
        else
            info_echo("Herald gear set [" ..
                player_name .. "] [" .. info.equip .. "] not found. Customize in herald_gear_sets.lua.")
        end
    end
end

--Text display of current settings
local function display_status()
    log_echo('[Status] Cure ' .. (settings.track_cure and "ON" or "OFF") ..
        ' | Cursna ' .. (settings.track_cursna and "ON" or "OFF") ..
        ' | Phalanx ' .. (settings.track_phalanx and "ON" or "OFF") ..
        ' | Protect ' .. (settings.track_protect_shell and "ON" or "OFF") ..
        ' | Refresh ' .. (settings.track_refresh and "ON" or "OFF") ..
        ' | Regen ' .. (settings.track_regen and "ON" or "OFF") ..
        ' | Waltz ' .. (settings.track_waltz and "ON" or "OFF") ..
        '\n[Herald] [Status] Addon Enabled ' .. (settings.addon_enabled and "YES" or "NO") ..
        ' | Gear Locking ' .. (settings.gear_lock and "ON" or "OFF") ..
        ' | Failsafe ' .. settings.delay .. 's' ..
        ' | Debug ' .. (settings.debug_mode and "ON" or "OFF") ..
        ' | Warn ' .. (settings.warn and "ON" or "OFF"))
end

--Text display of options for help and load
local function display_options()
    log_echo(
        '[Options] //her cure | cursna | phalanx | protect | refresh | regen | waltz' ..
        '\n[Herald] [Options] //her on | off | lock | delay <seconds> | warn | debug | help')
end

--Load settings from data/settings.xml.  Currently saves and loads only to global to prevent mismatched IPC.
local function load_character_settings()
    settings = config.load(default_settings, 'global')
    display_status()
end

--Used to set random seeds for staggering config.save and config.load
--Initialize a random seed that's player specific to avoid config save race condition
local function set_random_seeds()
    local player = windower.ffxi.get_player()
    local char_seed = player and player.id or os.time()

    -- Combine system time, fractional processor clock, and the player ID
    math.randomseed(os.time() + math.floor(os.clock() * 1000) + char_seed)

    -- Pop a few initial random numbers to flush out early seeding patterns
    math.random()
    math.random()
    math.random()
end

local function initialize()
    --Initialize settings
    load_character_settings()
    set_random_seeds()
    display_options()
    --Validate that spells and abilities correspond correctly to resource tables and replace ids automatically
    validate_table(spell_info, res.spells)
    validate_table(ability_info, res.job_abilities)
    log_echo('Herald spell received gear system loaded. Spell and ability tables validated.')
end

--Performed at load.  Initialize character settings and display commands.
windower.register_event('load', function()
    initialize()
end)

--Performed at character login.  Initialize character settings and display commands.
windower.register_event('login', function()
    initialize()
end)

--Monitors for 0x01A outgoing packets to determine when spell casts and ability casts begin.
--Determine the target and party members that are within distance for aoe through native -aga
--and -ra spells, divine waltz, or the use of accession or majesty.
windower.register_event('outgoing chunk', function(id, data, modified, injected, blocked)
    if not settings.addon_enabled then return end
    --Detect outgoing action packet
    if id == 0x01A then
        debug("Action Initiated")
        local packet = packets.parse('outgoing', data)

        --Detect spell casting. Category 3 corresponds to Magic Spell Cast Start
        if packet['Category'] == 3 then
            debug('Category 3 Outgoing Action Recognized')

            local spell_id = packet['Param'] -- The ID of the spell being cast
            debug('Outgoing Spell ID is ' .. spell_id)

            local s_info = spell_info[spell_id]
            if s_info and settings[s_info.category] then
                debug('Outgoing Spell ID is tracked. Continuing to messaging.')

                --Extract Player, Target and Spell Data from the packet.
                local target_id = packet['Target']
                local spell_data = res.spells[spell_id]
                local player = windower.ffxi.get_player() or "Unknown Player ID"
                local target_mob = windower.ffxi.get_mob_by_id(target_id)
                local target_name = target_mob and target_mob.name or "Unknown Target"
                debug(player.name .. " is attempting to cast: " .. spell_data.en .. " on " .. target_name)

                --IPC Messaging is not received by the caster/sender.  Must track self casts separately.
                if target_name == player.name then
                    debug(
                        "Self Cast Detected - Caster will use their normal precast, midcast, aftercast gear.  Set your midcast gear for combined casting and spell received bonus.")
                end

                --Calculate AoE Targets
                local accession_active = false
                local majesty_active = false
                if player and player.buffs then
                    if table.contains(player.buffs, 366) then
                        debug("Accession has been detected")
                        accession_active = true
                    end
                    if table.contains(player.buffs, 621) then
                        debug("Majesty has been detected")
                        majesty_active = true
                    end
                end

                if s_info.aoe or (accession_active and s_info.accession) or (majesty_active and s_info.majesty) then
                    debug("AoE Spell Cast Detected.  Calculating targets.")

                    local party = windower.ffxi.get_party()
                    if not player or not target_mob or not party then return end

                    local max_distance = 10
                    local nearby_members = {}
                    local threshold_squared = max_distance * max_distance

                    for slot, member in pairs(party) do
                        if type(member) == 'table' and member.name then
                            local member_mob = windower.ffxi.get_mob_by_name(member.name)
                            if member_mob then
                                local dx = member_mob.x - target_mob.x
                                local dy = member_mob.y - target_mob.y
                                local dz = member_mob.z - target_mob.z
                                local distance_squared = (dx * dx) + (dy * dy) + (dz * dz)

                                if distance_squared <= threshold_squared then
                                    debug(member.name .. " is WITHIN 10 yalms of " .. target_mob.name)
                                    table.insert(nearby_members, member.name)
                                else
                                    debug(member.name .. " is OUT of aoe range from " .. target_mob.name)
                                end
                            else
                                debug(member.name .. " data unavailable (Too far away).")
                            end
                        end
                    end

                    if #nearby_members > 0 then
                        target_name = table.concat(nearby_members, ",")
                    end
                end

                --Send IPC Message to others indicating sender, target, and spell name.
                local msg = string.format("HERALD|%s|%s|%s|%.0f", player.name, target_name, spell_data.id, get_time())
                debug("IPC Message Sent: " .. msg)
                windower.send_ipc_message(msg)
                outgoing_cast_active = true
            end

            --Detect Outgoing Job Abilities, Category 9
        elseif packet['Category'] == 9 then
            local ability_id = packet['Param']

            local a_info = ability_info[ability_id]
            if a_info and settings[a_info.category] then
                debug('Outgoing ability ID is tracked. Continuing to messaging.')

                --Extract Player, Target and Ability Data from the packet.
                local target_id = packet['Target']
                local ability_data = res.job_abilities[ability_id]
                local player = windower.ffxi.get_player() or "Unknown Player ID"
                local target_mob = windower.ffxi.get_mob_by_id(target_id)
                local target_name = target_mob and target_mob.name or "Unknown Target"
                debug(player.name .. " is attempting to use: " .. ability_data.en .. " on " .. target_name)

                if target_name == player.name then
                    debug("Self Cast Detected")
                end

                if a_info.aoe then
                    debug("AoE Ability Cast Detected.  Calculating targets.")

                    local party = windower.ffxi.get_party()
                    if not player or not target_mob or not party then return end

                    local max_distance = 10
                    local nearby_members = {}
                    local threshold_squared = max_distance * max_distance

                    for slot, member in pairs(party) do
                        if type(member) == 'table' and member.name then
                            local member_mob = windower.ffxi.get_mob_by_name(member.name)
                            if member_mob then
                                local dx = member_mob.x - target_mob.x
                                local dy = member_mob.y - target_mob.y
                                local dz = member_mob.z - target_mob.z
                                local distance_squared = (dx * dx) + (dy * dy) + (dz * dz)

                                if distance_squared <= threshold_squared then
                                    debug(member.name .. " is WITHIN 10 yalms of " .. target_mob.name)
                                    table.insert(nearby_members, member.name)
                                else
                                    debug(member.name .. " is OUT of aoe range from " .. target_mob.name)
                                end
                            else
                                debug(member.name .. " data unavailable (Too far away).")
                            end
                        end
                    end

                    if #nearby_members > 0 then
                        target_name = table.concat(nearby_members, ",")
                    end
                end

                local msg = string.format("HERALD_ABILITY|%s|%s|%s|%.0f", player.name, target_name, ability_data.id,
                    get_time())
                debug("IPC Message Sent: " .. msg)
                windower.send_ipc_message(msg)
                outgoing_cast_active = true
            end
        end
    end
end)

--Register when casting is completed, only during a previously registered cast.
windower.register_event('incoming chunk', function(id, data, modified, injected, blocked)
    if not settings.addon_enabled then return end
    if id == 0x028 then
        local packet = packets.parse('incoming', data)
        local player = windower.ffxi.get_player()

        if player and packet['Actor'] == player.id then
            local category = packet['Category']
            debug("Player has initiated 0x028 packet of category " .. category)

            -- Spell Cast Completed - Send IPC and reset state.
            if category == 4 and outgoing_cast_active then
                local spell_id = packet['Param']
                local msg = string.format("HERALD_DONE|%s|%s|%.0f", player.name, spell_id, get_time())
                windower.send_ipc_message(msg)
                outgoing_cast_active = false
                debug("Category 4 - Spell cast complete! Broadcasted IPC: " .. msg)

                -- Job Ability Completed - Send IPC and reset state.
            elseif category == 14 and outgoing_cast_active then
                local ability_id = packet['Param']
                local msg = string.format("HERALD_DONE|%s|%s|%.0f", player.name, ability_id, get_time())
                windower.send_ipc_message(msg)
                outgoing_cast_active = false
                debug("Category 14 - JA cast complete! Broadcasted IPC: " .. msg)

                -- Spell Cast Interrupted -- Needs testing. Potentially the wrong category and msg_id.  Ongoing research.
            elseif category == 5 and outgoing_cast_active then
                debug("Category 5 detected - Spell Interrupted")
                local msg_id = packet['Param']
                if msg_id == 16 or msg_id == 85 then
                    local msg = string.format("HERALD_INTERRUPT|%s|%s|%.0f", player.name, msg_id, get_time())
                    windower.send_ipc_message(msg)
                    debug("Category 5 - Cast interrupted! Broadcasted IPC: " .. msg)
                    outgoing_cast_active = false
                end
            end
        end
    end
end)

--Receive IPC Messages, send commands to gearswap and set casting state.  These commands must be registered in each character's
--job specific gearswap files, OR in an include that is referenced by the job file.  Mirdain's gearswap system is recommended.
windower.register_event('ipc message', function(msg)
    if not settings.addon_enabled then return end

    --Sent by caster at the start of spell cast. 0-3ms delay.  Seems to be agnostic of framerates in testing.
    if msg:startswith('HERALD|') then
        local split_msg = msg:split("|")
        local caster_name = split_msg[2]
        local target_name = split_msg[3] or "Missing Target Name"
        local spell_id = split_msg[4] or "Missing Spell ID"
        local time_sent = split_msg[5]

        local time_received = get_time()
        debug("IPC Message Received: " ..
            msg .. " after " .. (time_sent - time_received) .. " ms since sending")

        local player = windower.ffxi.get_player() or "Unknown Player ID"
        if string.find(target_name, player.name, 1, true) then
            if next(active_incoming_casters) == nil then
                cast_start_time = time_sent
                equip_gear(tonumber(spell_id), player.name, player.main_job:lower(), "spell")
            end

            -- Add caster to active pool and refresh failsafe timer
            active_incoming_casters[caster_name] = true
            debug(caster_name .. " added to Active Incoming Casters (" .. count_keys(active_incoming_casters) .. ")")
            failsafe_active = true
            failsafe_trigger_time = os.clock() + settings.delay
            debug(player.name .. " is targeted by " .. caster_name .. ". Gear equipped and timer refreshed.")
        end
        --Same as HERALD| for spell casts, but for waltzes.  Duplicated due to spells and abilities having potentially.
        --overlapping spell/ability id's.
    elseif msg:startswith('HERALD_ABILITY|') then
        local split_msg = msg:split("|")
        local caster_name = split_msg[2]
        local target_name = split_msg[3] or "Missing Target Name"
        local ability_id = split_msg[4] or "Missing Ability ID"
        local time_sent = split_msg[5]

        debug("IPC Message Received: " .. msg .. " after " .. (get_time() - time_sent) .. " ms since sending")

        local player = windower.ffxi.get_player() or "Unknown Player ID"
        if string.find(target_name, player.name, 1, true) then
            if next(active_incoming_casters) == nil then
                cast_start_time = time_sent
                equip_gear(tonumber(ability_id), player.name, player.main_job:lower(), "ability")
            end

            active_incoming_casters[caster_name] = true
            debug(caster_name .. " added to Active Incoming Casters (" .. count_keys(active_incoming_casters) .. ")")
            failsafe_active = true
            failsafe_trigger_time = os.clock() + settings.delay
            debug(player.name .. " is targeted by " .. caster_name .. ". Gear equipped and timer refreshed.")
        end
        --Message sent by caster when the spell completion packet is detected.  0-3ms delay, but at the mercy of 400ms ffxi server tick.
        --Use Packetflow addon to reduce server ticks to 250ms.  Signals receiver to tell gearswap to unlock slots and update gear using
        --custom herald commands.
    elseif msg:startswith("HERALD_DONE|") or msg:startswith("HERALD_INTERRUPT|") then
        local split_msg = msg:split("|")
        local caster_name = split_msg[2]
        local time_sent = tonumber(split_msg[4])

        debug("IPC Message Received: " .. msg .. " after " .. (get_time() - time_sent) .. " ms since sending")
        if active_incoming_casters[caster_name] then
            active_incoming_casters[caster_name] = nil
            debug(caster_name ..
                " finished casting after " ..
                (time_sent - cast_start_time) ..
                " ms and is removed from casting pool (" .. count_keys(active_incoming_casters) .. ")")

            -- If no one is actively casting on us anymore, reset gear
            if next(active_incoming_casters) == nil then
                windower.send_command('gs c herald_finished')
                debug("No active incoming casts remain. Resetting gear.")
            end
        end
        --Signals other clients to reload global settings after making a change.  All characters are synced right now.
        --Standalone stagger system will replace this and allow for character-specific settings.
    elseif msg:startswith("HERALD_SETTINGS|") then
        debug("IPC Message Received: " .. msg)

        -- Prevent file write collisions by staggering the saves randomly between 0.5 and 2.5 seconds
        local load_delay = math.random() * 2 + 0.5
        coroutine.schedule(function()
            load_character_settings()
            debug("Settings changed on another character, reloaded after " ..
                string.format("%.2f", load_delay) .. "s delay.")
        end, load_delay)
    end
end)

--Logic for commands to toggle and modify settings. //her help
windower.register_event('addon command', function(cmd, ...)
    local args = { ... }
    if not cmd then return end
    cmd = cmd:lower()

    if cmd == 'on' then
        log_echo('Enabled.')
        settings.addon_enabled = true
        outgoing_cast_active = false
        active_incoming_casters = {}
        failsafe_active = false
        failsafe_trigger_time = 0
    elseif cmd == 'off' then
        log_echo('Disabled.')
        settings.addon_enabled = false
        outgoing_cast_active = false
        active_incoming_casters = {}
        failsafe_active = false
        failsafe_trigger_time = 0
    elseif cmd == 'debug' then
        settings.debug_mode = not settings.debug_mode
        log_echo('Debug Mode ' .. tostring(settings.debug_mode))
    elseif cmd == 'delay' then
        local new_delay = tonumber(args[1])
        if new_delay and new_delay >= 1.5 then
            settings.delay = new_delay
            log_echo('Failsafe reset delay is now: ' .. settings.delay .. ' seconds.')
        else
            log_echo('Invalid delay value. Must be >= 1.5. Example: //her delay 1.5')
        end
    elseif cmd == 'warn' then
        settings.warn = not settings.warn
        log_echo('Equipment swap warning is now ' .. tostring(settings.warn))
    elseif cmd == 'protect' then
        settings.track_protect_shell = not settings.track_protect_shell
        log_echo('Protect and Shell tracking is now ' .. tostring(settings.track_protect_shell))
    elseif cmd == 'phalanx' then
        settings.track_phalanx = not settings.track_phalanx
        log_echo('Phalanx tracking is now ' .. tostring(settings.track_phalanx))
    elseif cmd == 'regen' then
        settings.track_regen = not settings.track_regen
        log_echo('Regen tracking is now ' .. tostring(settings.track_regen))
    elseif cmd == 'cursna' then
        settings.track_cursna = not settings.track_cursna
        log_echo('Cursna tracking is now ' .. tostring(settings.track_cursna))
    elseif cmd == "cure" then
        settings.track_cure = not settings.track_cure
        log_echo('Cure tracking is now ' .. tostring(settings.track_cure))
    elseif cmd == "refresh" then
        settings.track_refresh = not settings.track_refresh
        log_echo('Refresh tracking is now ' .. tostring(settings.track_refresh))
    elseif cmd == "help" then
        log_echo([[Herald - //her or //herald Command List:
[Herald] 1. help - Displays this help menu.
[Herald] 3. cure : Toggle tracking of cure spells and equipping of cure_set.
[Herald] 4. cursna : Toggle tracking of cursna spells and equipping of cursna_set.
[Herald] 5. phalanx : Toggle tracking of phalanx spells and equipping of phalanx_set.
[Herald] 6. protect : Toggle tracking of protect and shell spells and equipping of protect_shell_set.
[Herald] 7. refresh : Toggle tracking of refresh spells and equipping of refresh_set.
[Herald] 8. regen : Toggle tracking of cure spells and equipping of regen_set.
[Herald] 9. waltz : Toggle tracking of curing and divine waltz abilities and equipping of waltz_set.
[Herald] 10 on | off: Turn on or off all spell tracking and gear equipping.
[Herald] 11 lock : Toggle the locking of equipped gearsets during incoming spell cast to disallow overwriting.
[Herald] 12. warn : Toggle simple notifications when a gear set has been eqiupped or is not set up for the character.
[Herald] 13. delay <seconds> : Sets the failsafe equipment reset delay. Default 3s, minimum 1.5s.
[Herald] 14. debug : Toggles verbose debug mode with extensive timestamped monitoring of spell tracking.]])
    else
        log_echo("Unknown command.")
        display_options()
        return
    end

    if cmd ~= "help" then
        local save_delay = math.random() * 2 + 0.5
        coroutine.schedule(function()
            config.save(settings, 'global')
            debug("Settings saved to disk after " .. string.format("%.2f", save_delay) .. "s delay.")
            windower.send_ipc_message("HERALD_SETTINGS|Load|All")
            display_status()
        end, save_delay)
    end
end)

--Failsafe fallback will trigger at the <delay> amount of seconds since cast was initially detected.  Default is 3s.
--Sends equipment reset command to ensure that packet drops, errors and latency do not cause indefinite equipment locks.
windower.register_event('prerender', function()
    if not settings.addon_enabled or not failsafe_active then return end

    if os.clock() >= failsafe_trigger_time then
        failsafe_active = false
        failsafe_trigger_time = 0
        active_incoming_casters = {}
        windower.send_command('gs c herald_finished')
        debug("Failsafe triggered! Sending equipment reset command.")
    end
end)
