local sql = exports['jp-sql2']

function getPlayerBank(cid)
    local myBank

    local query = [[
        SELECT account_id
        FROM bank_accounts
        WHERE type='PERSONAL' AND character_id=?
        LIMIT 1
    ]]

    local bank = sql:executeSync(query, {cid})[1]

    myBank = {}
    if bank then        
        myBank.account_id = bank.account_id
    else
        local query = [[
            INSERT INTO bank_accounts
            SET character_id=?
        ]]

        local bank = sql:executeSync(query, {cid})
        if bank.warningStatus ~= 0 and bank.affectedRows ~= 1 then
            DropPlayer(source, "Error panga konto tegemisega???")
        end

        myBank.account_id = bank.insertId
    end
    
    return myBank
end

function refreshPlayerBank(source)
    local character = exports['players']:getCharacter(source)
    if not character then return end
    
    local bank = getPlayerBank(character.cid)
    exports['players']:modifyPlayerCurrentCharacter(source, 'bank', bank)

    local character = exports['players']:getCharacter(source)
end

AddEventHandler('login:server:selectedCharacter', refreshPlayerBank)
