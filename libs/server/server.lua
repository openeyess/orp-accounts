require('mysql')

addEventHandler('onPlayerJoin', root,
function()
    serial = getPlayerSerial(source)
    abc = source

    query('SELECT * FROM accounts WHERE serial = "?"', {serial}, 
    function(err, result, fields)
        if next(result) == 0 then
            return print('Tabela vazia.')
        else
            id = tonumber(result.id)
            email = tostring(result.email)
            
            account = getAccount(email) or false
            if (account == false) then
                if (#getAccountsBySerial(serial) > 1) then
                    return
                end
                account = addAccount(email, 'B13A73ED5EDC2913C7B40FCFF2C129FF32261E3B1D2EE69562D74B6B2E8F72F4')
                logIn(abc, account, 'B13A73ED5EDC2913C7B40FCFF2C129FF32261E3B1D2EE69562D74B6B2E8F72F4')
                setElementData(abc, 'player_id', id)
            else
                account = getAccount(email)
                logIn(abc, account, 'B13A73ED5EDC2913C7B40FCFF2C129FF32261E3B1D2EE69562D74B6B2E8F72F4')
                setElementData(abc, 'player_id', id)
            end

            query('SELECT approved FROM whitelists WHERE author_id = ?', {id},
            function(err, result2, fields)
                if next(result2) == 0 or result2.approved == 0 then
                    print('user sem wl')
                    -- substituir quando design estiver feito
                end
            end
            )
        end
    end
    )
end
)