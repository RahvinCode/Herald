active_external_locks = {}

function self_command(cmd)
    local command = cmd:lower()
    if command == 'update auto' then
        local built_set = choose_set()
        if choose_set_custom then
            built_set = set_combine(built_set, choose_set_custom())
        else
            warn('choose_set_custom() not found!')
        end
        -- Order the gear and then equip
        equip(built_set)
        return
    elseif command:sub(1, 18) == 'herald_lock_equip ' then
        --Herald command to equip the encoded set and lock it in place until cast completion or failsafe.
        --Converts hex_payload from herald back into a readable string and then converts that string into
        --a gearswap set to be immediately equipped.

        --Use the raw cmd and not the lowercase to convert hex to string
        local hex_payload = cmd:sub(19)
        local raw_table_string = hex_payload:gsub('..', function(cc)
            return string.char(tonumber(cc, 16))
        end)

        --Convert the decoded string into a gearswap table and equip
        local external_set = loadstring('return ' .. raw_table_string)()
        if type(external_set) == 'table' then
            equip(external_set)
            --Lock the slots of items from the herald set to prevent other actions from overwriting until cast completion
            for slot, item in pairs(external_set) do
                disable(slot)
                active_external_locks[slot] = true
            end
        end
        return
    elseif command:sub(1, 13) == 'herald_equip ' then
        --Herald command to equip the encoded set without locking slots.  Converts hex_payload from herald back into a
        --readable string and then converts that string into a gearswap set to be immediately equipped.
        --Extract hex chunk and decode it back to native text layout
        local hex_payload = cmd:sub(14)
        local raw_table_string = hex_payload:gsub('..', function(cc)
            return string.char(tonumber(cc, 16))
        end)

        --Convert the decoded string into a gearswap table
        local external_set = loadstring('return ' .. raw_table_string)()
        if type(external_set) == 'table' then
            equip(external_set)
        end
        return
    elseif command == 'herald_finished' then
        -- Safely release the locked equipment slots and re-equip appropriate gear
        for slot, _ in pairs(active_external_locks) do
            enable(slot)
        end
        active_external_locks = {}

        local built_set = choose_set()
        if type(choose_set_custom) == 'function' then
            built_set = set_combine(built_set, choose_set_custom())
        else
            -- Using a non-breaking print instead of warn() to protect console logs
            warn('[Herald]: choose_set_custom() not found!')
        end

        -- Order the gear and then equip back to normal status
        equip(built_set)
        return
    end
end
