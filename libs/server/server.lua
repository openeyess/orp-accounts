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
            id = tonumber(result.id)

            account = getAccount(id_discord) or false
            if (account == false) then
                if (#getAccountsBySerial(serial) > 1) then
                    return 
                end
                account = addAccount(id_discord, 'C5B34D56EC038AC2B92DB556E293748BFECDAEF90414EFE08523D7D78F4F4F72')
                abc:logIn(account, 'C5B34D56EC038AC2B92DB556E293748BFECDAEF90414EFE08523D7D78F4F4F72')
            else
                account = getAccount(id_discord)
                abc:logIn(account, 'C5B34D56EC038AC2B92DB556E293748BFECDAEF90414EFE08523D7D78F4F4F72') 
            end

            query('SELECT approved FROM whitelists WHERE author_id = ?', {result.id}, 
            function(err, result2, fields)
                if next(result2) == 0 or result2.approved == 0 then
                    outputChatBox('vc nao tem whitelist') -- temporary message
                end
            end
            )   
        end
    end
    )
end
)