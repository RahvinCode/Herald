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
_addon.version = '1.1'
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
local settings = config.load(default_settings)

local addon_enabled = true
local in_progress = false
local failsafe_active = false
local failsafe_trigger_time = 0

local tracked_spells = {
    [20] = settings.track_cursna,         --Cursna
    [106] = settings.track_phalanx,       --Phalanx
    [107] = settings.track_phalanx,       --Phalanx II
    [108] = settings.track_regen,         --Regen
    [110] = settings.track_regen,         --Regen II
    [111] = settings.track_regen,         --Regen III
    [477] = settings.track_regen,         --Regen IV
    [504] = settings.track_regen,         --Regen V
    [43] = settings.track_protect_shell,  --Protect
    [44] = settings.track_protect_shell,  --Protect II
    [45] = settings.track_protect_shell,  --Protect III
    [46] = settings.track_protect_shell,  --Protect IV
    [47] = settings.track_protect_shell,  --Protect V
    [125] = settings.track_protect_shell, --Protectra
    [126] = settings.track_protect_shell, --Protectra II
    [127] = settings.track_protect_shell, --Protectra III
    [128] = settings.track_protect_shell, --Protectra IV
    [129] = settings.track_protect_shell, --Protectra V
    [48] = settings.track_protect_shell,  --Shell
    [49] = settings.track_protect_shell,  --Shell II
    [50] = settings.track_protect_shell,  --Shell III
    [51] = settings.track_protect_shell,  --Shell IV
    [52] = settings.track_protect_shell,  --Shell V
    [130] = settings.track_protect_shell, --Shellra
    [131] = settings.track_protect_shell, --Shellra II
    [132] = settings.track_protect_shell, --Shellra III
    [133] = settings.track_protect_shell, --Shellra IV
    [134] = settings.track_protect_shell, --Shellra V
    [1] = settings.track_cure,            --Cure
    [2] = settings.track_cure,            --Cure II
    [3] = settings.track_cure,            --Cure III
    [4] = settings.track_cure,            --Cure IV
    [5] = settings.track_cure,            --Cure V
    [6] = settings.track_cure,            --Cure VI
    [7] = settings.track_cure,            --Curaga
    [8] = settings.track_cure,            --Curaga II
    [9] = settings.track_cure,            --Curaga III
    [10] = settings.track_cure,           --Curaga IV
    [11] = settings.track_cure,           --Curaga V
    [93] = settings.track_cure,           --Cura
    [474] = settings.track_cure,          --Cura II
    [475] = settings.track_cure,          --Cura III
}

local tracked_abilities = {
    [190] = settings.track_cure, --Curing Waltz
    [191] = settings.track_cure, --Curing Waltz II
    [192] = settings.track_cure, --Curing Waltz III
    [193] = settings.track_cure, --Curing Waltz IV
    [311] = settings.track_cure, --Curing Waltz V
    [195] = settings.track_cure, --Divine Waltz
    [262] = settings.track_cure, --Divine Waltz II
}

local cursna_spells = {
    [20] = settings.track_cursna, --Cursna
}

local phalanx_spells = {
    [106] = settings.track_phalanx, --Phalanx
    [107] = settings.track_phalanx, --Phalanx II
}

local protect_spells = {
    [43] = settings.track_protect_shell,  --Protect
    [44] = settings.track_protect_shell,  --Protect II
    [45] = settings.track_protect_shell,  --Protect III
    [46] = settings.track_protect_shell,  --Protect IV
    [47] = settings.track_protect_shell,  --Protect V
    [125] = settings.track_protect_shell, --Protectra
    [126] = settings.track_protect_shell, --Protectra II
    [127] = settings.track_protect_shell, --Protectra III
    [128] = settings.track_protect_shell, --Protectra IV
    [129] = settings.track_protect_shell, --Protectra V
}

local protect_and_shell_spells = {
    [43] = settings.track_protect_shell,  --Protect
    [44] = settings.track_protect_shell,  --Protect II
    [45] = settings.track_protect_shell,  --Protect III
    [46] = settings.track_protect_shell,  --Protect IV
    [47] = settings.track_protect_shell,  --Protect V
    [125] = settings.track_protect_shell, --Protectra
    [126] = settings.track_protect_shell, --Protectra II
    [127] = settings.track_protect_shell, --Protectra III
    [128] = settings.track_protect_shell, --Protectra IV
    [129] = settings.track_protect_shell, --Protectra V
    [48] = settings.track_protect_shell,  --Shell
    [49] = settings.track_protect_shell,  --Shell II
    [50] = settings.track_protect_shell,  --Shell III
    [51] = settings.track_protect_shell,  --Shell IV
    [52] = settings.track_protect_shell,  --Shell V
    [130] = settings.track_protect_shell, --Shellra
    [131] = settings.track_protect_shell, --Shellra II
    [132] = settings.track_protect_shell, --Shellra III
    [133] = settings.track_protect_shell, --Shellra IV
    [134] = settings.track_protect_shell, --Shellra V
}

local regen_spells = {
    [108] = settings.track_regen, --Regen
    [110] = settings.track_regen, --Regen II
    [111] = settings.track_regen, --Regen III
    [477] = settings.track_regen, --Regen IV
    [504] = settings.track_regen, --Regen V
}

local cure_spells = {
    [1] = settings.track_cure,   --Cure
    [2] = settings.track_cure,   --Cure II
    [3] = settings.track_cure,   --Cure III
    [4] = settings.track_cure,   --Cure IV
    [5] = settings.track_cure,   --Cure V
    [6] = settings.track_cure,   --Cure VI
    [7] = settings.track_cure,   --Curaga
    [8] = settings.track_cure,   --Curaga II
    [9] = settings.track_cure,   --Curaga III
    [10] = settings.track_cure,  --Curaga IV
    [11] = settings.track_cure,  --Curaga V
    [93] = settings.track_cure,  --Cura
    [474] = settings.track_cure, --Cura II
    [475] = settings.track_cure, --Cura III
}

local cure_abilities = {
    [190] = settings.track_cure, --Curing Waltz
    [191] = settings.track_cure, --Curing Waltz II
    [192] = settings.track_cure, --Curing Waltz III
    [193] = settings.track_cure, --Curing Waltz IV
    [311] = settings.track_cure, --Curing Waltz V
    [195] = settings.track_cure, --Divine Waltz
    [262] = settings.track_cure, --Divine Waltz II
}

local aoe_spells = {
    [125] = settings.track_protect_shell, --Protectra
    [126] = settings.track_protect_shell, --Protectra II
    [127] = settings.track_protect_shell, --Protectra III
    [128] = settings.track_protect_shell, --Protectra IV
    [129] = settings.track_protect_shell, --Protectra V
    [130] = settings.track_protect_shell, --Shellra
    [131] = settings.track_protect_shell, --Shellra II
    [132] = settings.track_protect_shell, --Shellra III
    [133] = settings.track_protect_shell, --Shellra IV
    [134] = settings.track_protect_shell, --Shellra V
    [7] = settings.track_cure,            --Curaga
    [8] = settings.track_cure,            --Curaga II
    [9] = settings.track_cure,            --Curaga III
    [10] = settings.track_cure,           --Curaga IV
    [11] = settings.track_cure,           --Curaga V
    [93] = settings.track_cure,           --Cura
    [474] = settings.track_cure,          --Cura II
    [475] = settings.track_cure,          --Cura III
}

local aoe_abilities = {
    [195] = settings.track_cure, --Divine Waltz
    [262] = settings.track_cure, --Divine Waltz II
}


local function log_echo(message, color_id)
    windower.add_to_chat(color_id or 204, '[Herald] ' .. message)
end

local function debug(message, color_id)
    if not settings.debug_mode then return end

    local timestamp = math.floor(os.clock() * 1000)
    windower.add_to_chat(color_id or 204, "[Herald] [Time: " .. timestamp .. "] DEBUG: " .. message)
end

local function equip_gear(spell_i)
    debug("Equip Gear Function Initiated with Spell ID " .. spell_i)
    if cursna_spells[spell_i] then
        debug("Sending Cursna Equip Command")
        windower.send_command("gs equip " .. cursna_set)
    elseif phalanx_spells[spell_i] then
        debug("Sending Phalanx Equip Command")
        windower.send_command("gs equip " .. phalanx_set)
    elseif protect_and_shell_spells[spell_i] then
        debug("Sending Prot/Shell Equip Command")
        windower.send_command("gs equip " .. protect_shell_set)
    elseif regen_spells[spell_i] then
        debug("Sending Regen Equip Command")
        windower.send_command("gs equip " .. regen_set)
    end
end

local function equip_gear_ability(ability_i)
    debug("Equip Gear Function Initiated with Ability ID " .. ability_i)
    if cure_abilities[ability_i] then
        debug("Sending Cure Equip Command")
        windower.send_command("gs equip " .. cure_set)
    end
end

windower.register_event('load', function()
    log_echo('Herald Loaded Successfully and Tracking Enabled', 204)
    log_echo('Tracked Spells: Cure/Waltz ' .. (settings.track_cure and "ON" or "OFF") .. ' | Cursna ' ..
        (settings.track_cursna and "ON" or "OFF") ..
        ' | Phalanx ' ..
        (settings.track_phalanx and "ON" or "OFF") ..
        ' | Regen ' ..
        (settings.track_regen and "ON" or "OFF") .. ' | Protect ' .. (settings.track_protect_shell and "ON" or "OFF"))
    log_echo("Failsafe equipment reversion delay is " ..
        tostring(settings.delay) .. "s and debug mode is " .. (settings.debug_mode and "ON" or "OFF"))
    log_echo("Options: //her [help|on|off|debug|cursna|phalanx|regen|protect|delay <seconds>]")
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

            --Check if spell is currently being tracked and continue to equipment changing if so
            if tracked_spells[spell_id] then
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

                if aoe_spells[spell_id] or accession_active or (majesty_active and (cure_spells[spell_id] or protect_spells[spell_id])) then
                    debug("AoE Spell Cast Detected.  Calculating targets.")

                    local party = windower.ffxi.get_party()
                    if not player or not target_mob or not party then return end

                    local max_distance = 10
                    local nearby_members = {}
                    local threshold_squared = max_distance * max_distance

                    for slot, member in pairs(party) do
                        -- Ensure the slot contains a valid party member table with a name
                        if type(member) == 'table' and member.name then
                            -- Get the full mob table for this specific party member to fetch coordinates
                            local member_mob = windower.ffxi.get_mob_by_name(member.name)

                            if member_mob then
                                -- Calculate spatial deltas between the party member and the spell target
                                local dx = member_mob.x - target_mob.x
                                local dy = member_mob.y - target_mob.y
                                local dz = member_mob.z - target_mob.z

                                -- Compute 3D Euclidean distance squared
                                local distance_squared = (dx * dx) + (dy * dy) + (dz * dz)

                                -- Compare directly against the squared threshold
                                if distance_squared <= threshold_squared then
                                    debug(member.name .. " is WITHIN 10 yalms of " .. target_mob.name)
                                    table.insert(nearby_members, member.name)

                                    -- TODO: Pack this player into an IPC broadcast table
                                else
                                    debug(member.name .. " is OUT of range.")
                                end
                            else
                                -- The party member is out of zone or beyond local draw distance limits
                                debug(member.name .. " data unavailable (Too far away).")
                            end
                        end
                    end

                    if #nearby_members > 0 then
                        target_name = table.concat(nearby_members, ",")
                    end
                end

                --Send IPC Message to others indicating target, spell name and send time.
                local msg = string.format("HERALD|%s|%s", target_name, spell_data.id)
                debug("IPC Message Sent: " .. msg)
                windower.send_ipc_message(msg)
                in_progress = true
            end
            --Detect Outgoing Job Abilities, Category 9
        elseif packet['Category'] == 9 then
            local ability_id = packet['Param'] -- The ID of the ability being used

            --Check if detected ability is tracked before continuing
            if tracked_abilities[ability_id] then
                debug('Outgoing ability ID is tracked. Continuing to messaging.')

                --Extract Target and Spell Data from the packet.
                local target_id = packet['Target']
                debug("Target of outgoing spell is " .. target_id)
                local ability_data = res.job_abilities[ability_id]
                debug("Outgoing ability name is " .. ability_data.en)

                --Get player and target and then send spell cast notifications.
                local player = windower.ffxi.get_player() or "Unknown Player ID"
                local target_mob = windower.ffxi.get_mob_by_id(target_id)
                local target_name = target_mob and target_mob.name or "Unknown Target"
                debug(player.name .. " is attempting to use: " .. ability_data.en .. " on " .. target_name)

                --IPC Messaging is not received by the caster/sender.  Must track self casts separately.
                if target_name == player.name then
                    debug("Self Cast Detected")
                end

                --Calculate AoE Targets
                if aoe_abilities[ability_id] then
                    debug("AoE Ability Cast Detected.  Calculating targets.")

                    local party = windower.ffxi.get_party()
                    if not player or not target_mob or not party then return end

                    local max_distance = 10
                    local nearby_members = {}
                    local threshold_squared = max_distance * max_distance

                    for slot, member in pairs(party) do
                        -- Ensure the slot contains a valid party member table with a name
                        if type(member) == 'table' and member.name then
                            -- Get the full mob table for this specific party member to fetch coordinates
                            local member_mob = windower.ffxi.get_mob_by_name(member.name)

                            if member_mob then
                                -- Calculate spatial deltas between the party member and the spell target
                                local dx = member_mob.x - target_mob.x
                                local dy = member_mob.y - target_mob.y
                                local dz = member_mob.z - target_mob.z

                                -- Compute 3D Euclidean distance squared
                                local distance_squared = (dx * dx) + (dy * dy) + (dz * dz)

                                -- Compare directly against the squared threshold
                                if distance_squared <= threshold_squared then
                                    debug(member.name .. " is WITHIN 10 yalms of " .. target_mob.name)
                                    table.insert(nearby_members, member.name)

                                    -- TODO: Pack this player into an IPC broadcast table
                                else
                                    debug(member.name .. " is OUT of range.")
                                end
                            else
                                -- The party member is out of zone or beyond local draw distance limits
                                debug(member.name .. " data unavailable (Too far away).")
                            end
                        end
                    end

                    if #nearby_members > 0 then
                        target_name = table.concat(nearby_members, ",")
                    end
                end

                --Send IPC Message to others indicating target and ability name.
                local msg = string.format("HERALD_ABILITY|%s|%s", target_name, ability_data.id)
                debug("IPC Message Sent: " .. msg)
                windower.send_ipc_message(msg)
                in_progress = true
            end
        end
    end
end)

--Register when casting is completed, only during a previously registered cast.
windower.register_event('incoming chunk', function(id, data, modified, injected, blocked)
    if not addon_enabled then return end
    --Watch for the server's authoritative action confirmation packet
    if id == 0x028 then
        local packet = packets.parse('incoming', data)
        local player = windower.ffxi.get_player()

        --Ensure the actor for the incoming packet is self prior to performing any operation.
        if player and packet['Actor'] == player.id then
            debug("Confirmed that player is the packet actor")
            local category = packet['Category']
            debug("0x028 packet category is " .. category)

            --Detect tracked spell cast, Broadcast IPC message and reset state
            --Category 4 = Spell Cast Completed Successfully
            if category == 4 and in_progress then
                debug("Category 4 Spell Cast Completion Detected")
                local spell_id = packet['Param']

                --Broadcast the completion payload over IPC
                --Structure: HERALD_DONE|PlayerName|SpellID
                local msg = string.format("HERALD_DONE|%s|%s", player.name, spell_id)
                windower.send_ipc_message(msg)
                in_progress = false
                debug("Cast complete! Broadcasted IPC: " .. msg)

                --Detect tracked ability completion, Broadcast IPC message and reset state
                --Category 3 = Job Ability Completed Successfully
            elseif category == 14 and in_progress then
                debug("Category 14 Ability Cast Completion Detected")
                local ability_id = packet['Param']

                --Broadcast the completion payload over IPC
                --Structure: HERALD_DONE|PlayerName|AbilityID
                local msg = string.format("HERALD_DONE|%s|%s", player.name, ability_id)
                windower.send_ipc_message(msg)
                in_progress = false
                debug("JA cast complete! Broadcasted IPC: " .. msg)


                --Detect spell intefrrupts, broadcast IPC message and reset state.
                --Category 5 = Spell Cast Interrupted
            elseif category == 5 and in_progress then
                debug("Category 5 detected - Spell Interrupted")
                local msg_id = packet['Param']
                if msg_id == 16 or msg_id == 85 then
                    local msg = string.format("HERALD_INTERRUPT|%s", player.name)
                    windower.send_ipc_message(msg)
                    debug("Cast interrupted! Broadcasted IPC: " .. msg)
                    in_progress = false
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
        local target_name = split_msg[2] or "Missing Target Name"
        local spell_id = split_msg[3] or "Missing Spell ID"

        local player = windower.ffxi.get_player() or "Unknown Player ID"
        if string.find(target_name, player.name, 1, true) and not in_progress then
            equip_gear(tonumber(spell_id))
            in_progress = true
            failsafe_active = true
            failsafe_trigger_time = os.clock() + settings.delay
            debug(player.name .. " is recognized within targets list. Equipping gear and setting in_progress to true")
        end
    elseif msg:startswith('HERALD_ABILITY|') then
        debug("IPC Message Received: " .. msg)

        local split_msg = msg:split("|")
        local target_name = split_msg[2] or "Missing Target Name"
        local ability_id = split_msg[3] or "Missing Ability ID"

        local player = windower.ffxi.get_player() or "Unknown Player ID"
        if string.find(target_name, player.name, 1, true) and not in_progress then
            equip_gear_ability(tonumber(ability_id))
            in_progress = true
            failsafe_active = true
            failsafe_trigger_time = os.clock() + settings.delay
            debug(player.name .. " is recognized within targets list. Equipping gear and setting in_progress to true")
        end
    elseif msg:startswith("HERALD_DONE|") and in_progress then
        debug("IPC Message Received: " .. msg)

        local split_msg = msg:split("|")
        local caster_name = split_msg[2]
        local spell_id = split_msg[3]

        windower.send_command(equip_reset_command)
        in_progress = false
        debug(caster_name .. " has finished casting spell/ability ID: " .. spell_id .. " Resetting in_progress")
    elseif msg:startswith("HERALD_INTERRUPT|") and in_progress then
        debug("IPC Message Received: " .. msg)

        local split_msg = msg:split("|")
        local caster_name = split_msg[2]

        debug(caster_name .. " has been interrupted while casting. Resetting in_progress")
        in_progress = false
    elseif msg:startswith("HERALD_SETTINGS|") then
        debug("IPC Message Received: " .. msg)
        local split_msg = msg:split("|")
        local setting = split_msg[2]
        local new_setting = split_msg[3]
        if setting == "Debug" then
            settings.debug_mode = (new_setting == "true")
        elseif setting == "Delay" then
            settings.delay = tonumber(new_setting)
        elseif setting == "Phalanx" then
            settings.track_phalanx = (new_setting == "true")
        elseif setting == "Regen" then
            settings.track_regen = (new_setting == "true")
        elseif setting == "Protect/Shell" then
            settings.track_protect_shell = (new_setting == "true")
        elseif setting == "Cursna" then
            settings.track_cursna = (new_setting == "true")
        elseif setting == "Cure" then
            settings.track_cure = (new_setting == "true")
        end
        log_echo(setting .. ' is now ' .. new_setting)
    end
end)

windower.register_event('addon command', function(cmd, ...)
    local args = { ... }
    if not cmd then return end
    cmd = cmd:lower()

    if cmd == 'on' then
        log_echo('Enabled.')
        addon_enabled = true
        in_progress = false
        failsafe_active = false
        failsafe_trigger_time = 0
    elseif cmd == 'off' then
        log_echo('Disabled.')
        addon_enabled = false
        in_progress = false
        failsafe_active = false
        failsafe_trigger_time = 0
    elseif cmd == 'debug' then
        settings.debug_mode = not settings.debug_mode
        log_echo('Debug Mode ' .. tostring(settings.debug_mode))
        windower.send_ipc_message("HERALD_SETTINGS|" .. "Debug|" .. tostring(settings.debug_mode))
    elseif cmd == 'delay' then
        local new_delay = tonumber(args[1])
        if new_delay and new_delay >= 1.5 then
            settings.delay = new_delay
            log_echo('Failsafe reset delay is now: ' .. settings.delay .. ' seconds.')
            windower.send_ipc_message("HERALD_SETTINGS|" .. "Delay|" .. settings.delay)
        else
            log_echo('Invalid delay value. Must be >= 1.5. Example: //her delay 1.5')
        end
    elseif cmd == 'protect' then
        settings.track_protect_shell = not settings.track_protect_shell
        log_echo('Protect and Shell tracking ' .. tostring(settings.track_protect_shell))
        windower.send_ipc_message("HERALD_SETTINGS|" .. "Debug|" .. tostring(settings.track_protect_shell))
    elseif cmd == 'phalanx' then
        settings.track_phalanx = not settings.track_phalanx
        log_echo('Phalanx tracking ' .. tostring(settings.track_phalanx))
        windower.send_ipc_message("HERALD_SETTINGS|" .. "Phalanx|" .. tostring(settings.track_phalanx))
    elseif cmd == 'regen' then
        settings.track_regen = not settings.track_regen
        log_echo('Regen tracking ' .. tostring(settings.track_regen))
        windower.send_ipc_message("HERALD_SETTINGS|" .. "Regen|" .. tostring(settings.track_regen))
    elseif cmd == 'cursna' then
        settings.track_cursna = not settings.track_cursna
        log_echo('Cursna tracking ' .. tostring(settings.track_cursna))
        windower.send_ipc_message("HERALD_SETTINGS|" .. "Cursna|" .. tostring(settings.track_cursna))
    elseif cmd == "cure" then
        settings.track_cure = not settings.track_cure
        log_echo('Cure tracking ' .. tostring(settings.track_cure))
        windower.send_ipc_message("HERALD_SETTINGS|" .. "Cure|" .. tostring(settings.track_cure))
    else
        log_echo(
            "Unknown command. Options: //herald //her [help|on|off|debug|cure|cursna|phalanx|regen|protect|delay <seconds>]")
    end
end)

windower.register_event('prerender', function()
    if not addon_enabled or not failsafe_active then return end

    if os.clock() >= failsafe_trigger_time then
        failsafe_active = false
        failsafe_trigger_time = 0
        in_progress = false
        windower.send_command("gs c update auto")
        debug("Failsafe triggered! Sending equipment reset command.")
    end
end)
