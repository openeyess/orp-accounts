require('mysql')

addEventHandler('onPlayerJoin', root,
function()
    serial = source:getSerial()
    abc = source

    query('SELECT * FROM accounts WHERE serial = "?"', {serial}, 
    function(err, result, fields)
        if next(result) == 0 then
            return print('Tabela vazia.')
        else
            id_discord = string.format("%.f", result.discord_id)
        
            account = getAccount(id_discord) or false
            if (account == false) then
                if (#getAccountsBySerial(serial) > 1) then
                    return 
                end
                conta = addAccount(id_discord, 'senhafoda')
                abc:logIn(conta, 'senhafoda')
            else
                conta = getAccount(id_discord)
                abc:logIn(conta, 'senhafoda') 
            end
        end
    end
    )
end
)