require('mysql')

addEventHandler('onPlayerJoin', root,
function()
    serial = getPlayerSerial(source)
    player = source

    query('SELECT * FROM accounts WHERE serial = "?"', {serial}, function(err, result, fields)
        if next(result) == 0 then  --[[att design no account]] end
        id = tonumber(result.id)
        email = tostring(result.email)
        
        query('SELECT approved FROM whitelists WHERE author_id = ?', {id}, function(err, result2, fields)
            if next(result2) == 0 or result2.approved == 0 then
                print('user sem wl')
                -- att design no wl
                return
            end
            query('SELECT characters FROM characters WHERE id = ?', {id}, function(err, result3, fields)
                password = sha256(email)
                account = getAccount(email)
                logIn(player, account, password)

                setElementData(player, 'id', id)

                triggerClientEvent(player, 'drawAccounts', player, result3.characters)
            end)
        end
        )
    end
    )
end
)