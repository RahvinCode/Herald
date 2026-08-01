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
_addon.version = '1.2'
_addon.commands = { 'her', 'herald' }

local packets = require('packets')
local res = require('resources')
local config = require('config')

--User-Defined equipment sets for your gearswap.  Modify in gearswap to match these, or modify the sets and the reset command here to match your gearswap.
local cure_set = "sets.Cure_Received"
local cursna_set = "sets.Cursna_Received"
local phalanx_set = "sets.Phalanx_Received"
local protect_shell_set = "sets.Protect_Shell_Received"
local regen_set = "sets.Regen_Received"
local equip_reset_command = "gs c update auto"

--Default Settings.  Overridden by Character Specific Settings.
local default_settings = {
    debug_mode = false,
    delay = 3,
    track_cursna = true,
    track_phalanx = true,
    track_regen = true,
    track_cure = true,
    track_protect_shell = true,
}
local settings = {}

local addon_enabled = true
local outgoing_cast_active = false
local active_incoming_casters = {}
local failsafe_active = false
local failsafe_trigger_time = 0

-- Consolidated spell definitions using metadata to dictate categories and AoE rules
local spell_info = {
    -- Cursna
    [20] = { category = 'track_cursna', equip = cursna_set, aoe = false, majesty = false },
    -- Phalanx
    [106] = { category = 'track_phalanx', equip = phalanx_set, aoe = false, majesty = false },
    [107] = { category = 'track_phalanx', equip = phalanx_set, aoe = false, majesty = false },
    -- Regen
    [108] = { category = 'track_regen', equip = regen_set, aoe = false, majesty = false },
    [110] = { category = 'track_regen', equip = regen_set, aoe = false, majesty = false },
    [111] = { category = 'track_regen', equip = regen_set, aoe = false, majesty = false },
    [477] = { category = 'track_regen', equip = regen_set, aoe = false, majesty = false },
    [504] = { category = 'track_regen', equip = regen_set, aoe = false, majesty = false },
    -- Protect (Majesty affected)
    [43] = { category = 'track_protect_shell', equip = protect_shell_set, aoe = false, majesty = true },
    [44] = { category = 'track_protect_shell', equip = protect_shell_set, aoe = false, majesty = true },
    [45] = { category = 'track_protect_shell', equip = protect_shell_set, aoe = false, majesty = true },
    [46] = { category = 'track_protect_shell', equip = protect_shell_set, aoe = false, majesty = true },
    [47] = { category = 'track_protect_shell', equip = protect_shell_set, aoe = false, majesty = true },
    [125] = { category = 'track_protect_shell', equip = protect_shell_set, aoe = true, majesty = true },
    [126] = { category = 'track_protect_shell', equip = protect_shell_set, aoe = true, majesty = true },
    [127] = { category = 'track_protect_shell', equip = protect_shell_set, aoe = true, majesty = true },
    [128] = { category = 'track_protect_shell', equip = protect_shell_set, aoe = true, majesty = true },
    [129] = { category = 'track_protect_shell', equip = protect_shell_set, aoe = true, majesty = true },
    -- Shell
    [48] = { category = 'track_protect_shell', equip = protect_shell_set, aoe = false, majesty = false },
    [49] = { category = 'track_protect_shell', equip = protect_shell_set, aoe = false, majesty = false },
    [50] = { category = 'track_protect_shell', equip = protect_shell_set, aoe = false, majesty = false },
    [51] = { category = 'track_protect_shell', equip = protect_shell_set, aoe = false, majesty = false },
    [52] = { category = 'track_protect_shell', equip = protect_shell_set, aoe = false, majesty = false },
    [130] = { category = 'track_protect_shell', equip = protect_shell_set, aoe = true, majesty = false },
    [131] = { category = 'track_protect_shell', equip = protect_shell_set, aoe = true, majesty = false },
    [132] = { category = 'track_protect_shell', equip = protect_shell_set, aoe = true, majesty = false },
    [133] = { category = 'track_protect_shell', equip = protect_shell_set, aoe = true, majesty = false },
    [134] = { category = 'track_protect_shell', equip = protect_shell_set, aoe = true, majesty = false },
    -- Cure
    [1] = { category = 'track_cure', equip = cure_set, aoe = false, majesty = true },
    [2] = { category = 'track_cure', equip = cure_set, aoe = false, majesty = true },
    [3] = { category = 'track_cure', equip = cure_set, aoe = false, majesty = true },
    [4] = { category = 'track_cure', equip = cure_set, aoe = false, majesty = true },
    [5] = { category = 'track_cure', equip = cure_set, aoe = false, majesty = true },
    [6] = { category = 'track_cure', equip = cure_set, aoe = false, majesty = true },
    -- Curaga / Cura
    [7] = { category = 'track_cure', equip = cure_set, aoe = true, majesty = true },
    [8] = { category = 'track_cure', equip = cure_set, aoe = true, majesty = true },
    [9] = { category = 'track_cure', equip = cure_set, aoe = true, majesty = true },
    [10] = { category = 'track_cure', equip = cure_set, aoe = true, majesty = true },
    [11] = { category = 'track_cure', equip = cure_set, aoe = true, majesty = true },
    [93] = { category = 'track_cure', equip = cure_set, aoe = true, majesty = true },
    [474] = { category = 'track_cure', equip = cure_set, aoe = true, majesty = true },
    [475] = { category = 'track_cure', equip = cure_set, aoe = true, majesty = true },
}

-- Consolidated abilities mapping
local ability_info = {
    [190] = { category = 'track_cure', equip = cure_set, aoe = false },
    [191] = { category = 'track_cure', equip = cure_set, aoe = false },
    [192] = { category = 'track_cure', equip = cure_set, aoe = false },
    [193] = { category = 'track_cure', equip = cure_set, aoe = false },
    [311] = { category = 'track_cure', equip = cure_set, aoe = false },
    [195] = { category = 'track_cure', equip = cure_set, aoe = true },
    [262] = { category = 'track_cure', equip = cure_set, aoe = true },
}


local function log_echo(message, color_id)
    windower.add_to_chat(color_id or 204, '[Herald] ' .. message)
end

local function debug(message, color_id)
    if not settings.debug_mode then return end
    local timestamp = math.floor(os.clock() * 1000)
    windower.add_to_chat(color_id or 204, "[Herald] [Time: " .. timestamp .. "] DEBUG: " .. message)
end

local function equip_gear(spell_id)
    local info = spell_info[spell_id]
    if info then
        debug("Sending Equip Command: " .. info.equip)
        windower.send_command("gs equip " .. info.equip)
    end
end

local function equip_gear_ability(ability_id)
    local info = ability_info[ability_id]
    if info then
        debug("Sending Equip Command: " .. info.equip)
        windower.send_command("gs equip " .. info.equip)
    end
end

local function count_keys(tbl)
    local count = 0
    for _ in pairs(tbl) do
        count = count + 1
    end
    return count
end

local function load_character_settings()
    settings = config.load(default_settings, 'global')
    log_echo('Tracked Spells: Cure/Waltz ' .. (settings.track_cure and "ON" or "OFF") .. ' | Cursna ' ..
        (settings.track_cursna and "ON" or "OFF") ..
        ' | Phalanx ' ..
        (settings.track_phalanx and "ON" or "OFF") ..
        ' | Regen ' ..
        (settings.track_regen and "ON" or "OFF") .. ' | Protect ' .. (settings.track_protect_shell and "ON" or "OFF"))
    log_echo("Failsafe equipment reversion delay is " ..
        tostring(settings.delay) .. "s and debug mode is " .. (settings.debug_mode and "ON" or "OFF"))
end

local function set_random_seeds()
    --Initialize a random seed that's player specific to avoid config save race condition
    local player = windower.ffxi.get_player()
    local char_seed = player and player.id or os.time()

    -- Combine system time, fractional processor clock, and the player ID
    math.randomseed(os.time() + math.floor(os.clock() * 1000) + char_seed)

    -- Pop a few initial random numbers to flush out early seeding patterns
    debug("Random 1 " .. math.random())
    debug("Random 2 " .. math.random())
    debug("Random 3 " .. math.random())
end

windower.register_event('load', function()
    log_echo('Herald Loaded Successfully and Tracking Enabled', 204)
    log_echo("Options: //her [help|on|off|debug|cursna|phalanx|regen|protect|delay <seconds>]")

    --Initialize character specific settings
    load_character_settings()
    set_random_seeds()
end)

windower.register_event('login', function()
    --Initialize character specific settings
    load_character_settings()
    set_random_seeds()
    debug("Character changed. Profile settings reloaded.")
end)

windower.register_event('outgoing chunk', function(id, data, modified, injected, blocked)
    if not addon_enabled then return end
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

                --Extract Target and Spell Data from the packet.
                local target_id = packet['Target']
                debug("Target of outgoing spell is " .. target_id)
                local spell_data = res.spells[spell_id]
                debug("Outgoing spell name is " .. spell_data.en)

                --Get player and target and then send spell cast notifications.
                local player = windower.ffxi.get_player() or "Unknown Player ID"
                local target_mob = windower.ffxi.get_mob_by_id(target_id)
                local target_name = target_mob and target_mob.name or "Unknown Target"
                debug(player.name .. " is attempting to cast: " .. spell_data.en .. " on " .. target_name)

                --IPC Messaging is not received by the caster/sender.  Must track self casts separately.
                if target_name == player.name then
                    debug("Self Cast Detected")
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

                if s_info.aoe or accession_active or (majesty_active and s_info.majesty) then
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
                                    debug(member.name .. " is OUT of range.")
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
                local msg = string.format("HERALD|%s|%s|%s", player.name, target_name, spell_data.id)
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

                local target_id = packet['Target']
                debug("Target of outgoing spell is " .. target_id)
                local ability_data = res.job_abilities[ability_id]
                debug("Outgoing ability name is " .. ability_data.en)

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
                                    debug(member.name .. " is OUT of range.")
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

                local msg = string.format("HERALD_ABILITY|%s|%s|%s", player.name, target_name, ability_data.id)
                debug("IPC Message Sent: " .. msg)
                windower.send_ipc_message(msg)
                outgoing_cast_active = true
            end
        end
    end
end)

--Register when casting is completed, only during a previously registered cast.
windower.register_event('incoming chunk', function(id, data, modified, injected, blocked)
    if not addon_enabled then return end
    if id == 0x028 then
        local packet = packets.parse('incoming', data)
        local player = windower.ffxi.get_player()

        if player and packet['Actor'] == player.id then
            debug("Confirmed that player is the packet actor")
            local category = packet['Category']
            debug("0x028 packet category is " .. category)

            -- Spell Cast Completed
            if category == 4 and outgoing_cast_active then
                debug("Category 4 Spell Cast Completion Detected")
                local spell_id = packet['Param']
                local msg = string.format("HERALD_DONE|%s|%s", player.name, spell_id)
                windower.send_ipc_message(msg)
                outgoing_cast_active = false
                debug("Cast complete! Broadcasted IPC: " .. msg)

                -- Job Ability Completed
            elseif category == 14 and outgoing_cast_active then
                debug("Category 14 Ability Cast Completion Detected")
                local ability_id = packet['Param']
                local msg = string.format("HERALD_DONE|%s|%s", player.name, ability_id)
                windower.send_ipc_message(msg)
                outgoing_cast_active = false
                debug("JA cast complete! Broadcasted IPC: " .. msg)

                -- Spell Cast Interrupted
            elseif category == 5 and outgoing_cast_active then
                debug("Category 5 detected - Spell Interrupted")
                local msg_id = packet['Param']
                if msg_id == 16 or msg_id == 85 then
                    local msg = string.format("HERALD_INTERRUPT|%s", player.name)
                    windower.send_ipc_message(msg)
                    debug("Cast interrupted! Broadcasted IPC: " .. msg)
                    outgoing_cast_active = false
                end
            end
        end
    end
end)

--Receive IPC Messages, send commands to gearswap and set casting state
windower.register_event('ipc message', function(msg)
    if not addon_enabled then return end

    if msg:startswith('HERALD|') then
        debug("IPC Message Received: " .. msg)

        local split_msg = msg:split("|")
        local caster_name = split_msg[2]
        local target_name = split_msg[3] or "Missing Target Name"
        local spell_id = split_msg[4] or "Missing Spell ID"

        local player = windower.ffxi.get_player() or "Unknown Player ID"
        if string.find(target_name, player.name, 1, true) then
            if next(active_incoming_casters) == nil then
                equip_gear(tonumber(spell_id))
            end

            -- Add caster to active pool and refresh failsafe timer
            active_incoming_casters[caster_name] = true
            debug(caster_name .. " added to Active Incoming Casters (" .. count_keys(active_incoming_casters) .. ")")
            failsafe_active = true
            failsafe_trigger_time = os.clock() + settings.delay
            debug(player.name .. " is targeted by " .. caster_name .. ". Gear equipped and timer refreshed.")
        end
    elseif msg:startswith('HERALD_ABILITY|') then
        debug("IPC Message Received: " .. msg)

        local split_msg = msg:split("|")
        local caster_name = split_msg[2]
        local target_name = split_msg[3] or "Missing Target Name"
        local ability_id = split_msg[4] or "Missing Ability ID"

        local player = windower.ffxi.get_player() or "Unknown Player ID"
        if string.find(target_name, player.name, 1, true) then
            if next(active_incoming_casters) == nil then
                equip_gear_ability(tonumber(ability_id))
            end

            active_incoming_casters[caster_name] = true
            debug(caster_name .. " added to Active Incoming Casters (" .. count_keys(active_incoming_casters) .. ")")
            failsafe_active = true
            failsafe_trigger_time = os.clock() + settings.delay
            debug(player.name .. " is targeted by " .. caster_name .. ". Gear equipped and timer refreshed.")
        end
    elseif msg:startswith("HERALD_DONE|") or msg:startswith("HERALD_INTERRUPT|") then
        debug("IPC Message Received: " .. msg)

        local split_msg = msg:split("|")
        local caster_name = split_msg[2]

        if active_incoming_casters[caster_name] then
            active_incoming_casters[caster_name] = nil
            debug(caster_name .. " finished casting. Removed from pool. (" .. count_keys(active_incoming_casters) .. ")")

            -- If no one is actively casting on us anymore, reset gear
            if next(active_incoming_casters) == nil then
                windower.send_command(equip_reset_command)
                debug("No active incoming casts remain. Resetting gear.")
            end
        end
    elseif msg:startswith("HERALD_SETTINGS|") then
        debug("IPC Message Received: " .. msg)

        -- Prevent file write collisions by staggering the saves randomly between 0.5 and 2.5 seconds
        local load_delay = 2.5
        coroutine.schedule(function()
            load_character_settings()
            debug("Settings changed on another character, reloaded after " ..
                string.format("%.2f", load_delay) .. "s delay.")
        end, load_delay)
    end
end)

windower.register_event('addon command', function(cmd, ...)
    local args = { ... }
    if not cmd then return end
    cmd = cmd:lower()

    if cmd == 'on' then
        log_echo('Enabled.')
        addon_enabled = true
        outgoing_cast_active = false
        active_incoming_casters = {}
        failsafe_active = false
        failsafe_trigger_time = 0
    elseif cmd == 'off' then
        log_echo('Disabled.')
        addon_enabled = false
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
    elseif cmd == 'protect' then
        settings.track_protect_shell = not settings.track_protect_shell
        log_echo('Protect and Shell tracking ' .. tostring(settings.track_protect_shell))
    elseif cmd == 'phalanx' then
        settings.track_phalanx = not settings.track_phalanx
        log_echo('Phalanx tracking ' .. tostring(settings.track_phalanx))
    elseif cmd == 'regen' then
        settings.track_regen = not settings.track_regen
        log_echo('Regen tracking ' .. tostring(settings.track_regen))
    elseif cmd == 'cursna' then
        settings.track_cursna = not settings.track_cursna
        log_echo('Cursna tracking ' .. tostring(settings.track_cursna))
    elseif cmd == "cure" then
        settings.track_cure = not settings.track_cure
        log_echo('Cure tracking ' .. tostring(settings.track_cure))
    else
        log_echo(
            "Unknown command. Options: //herald //her [help|on|off|debug|cure|cursna|phalanx|regen|protect|delay <seconds>]")
        return
    end

    local save_delay = math.random() * 2 + 0.5
    coroutine.schedule(function()
        config.save(settings, 'global')
        debug("Settings saved to disk after " .. string.format("%.2f", save_delay) .. "s delay.")
        log_echo('Tracked Spells: Cure/Waltz ' .. (settings.track_cure and "ON" or "OFF") .. ' | Cursna ' ..
            (settings.track_cursna and "ON" or "OFF") ..
            ' | Phalanx ' ..
            (settings.track_phalanx and "ON" or "OFF") ..
            ' | Regen ' ..
            (settings.track_regen and "ON" or "OFF") .. ' | Protect ' .. (settings.track_protect_shell and "ON" or "OFF"))
        log_echo("Failsafe equipment reversion delay is " ..
            tostring(settings.delay) .. "s and debug mode is " .. (settings.debug_mode and "ON" or "OFF"))
        windower.send_ipc_message("HERALD_SETTINGS|Save|All")
    end, save_delay)
end)

windower.register_event('prerender', function()
    if not addon_enabled or not failsafe_active then return end

    if os.clock() >= failsafe_trigger_time then
        failsafe_active = false
        failsafe_trigger_time = 0
        active_incoming_casters = {}
        windower.send_command(equip_reset_command)
        debug("Failsafe triggered! Sending equipment reset command.")
    end
end)
