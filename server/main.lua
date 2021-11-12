local QBCore = exports['qb-core']:GetCoreObject()
local QBPhone = {}
local Tweets = {}
local AppAlerts = {}
local MentionedTweets = {}
local Hashtags = {}
local Calls = {}
local Adverts = {}
local GeneratedPlates = {}
local WebHook = "https://discord.com/api/webhooks/866990620078112798/KCvLfky9V4o-OEKvI4y6i7c7sZdtUuRd3HFX3qEhRNQnjQli_IOo49dsdGCSvCO7x5-2"

-- Functions

local function GetOnlineStatus(number)
    local Target = QBCore.Functions.GetPlayerByPhone(number)
    local retval = false
    if Target ~= nil then
        retval = true
    end
    return retval
end

local function GenerateMailId()
    return math.random(111111, 999999)
end

local function escape_sqli(source)
    local replacements = {
        ['"'] = '\\"',
        ["'"] = "\\'"
    }
    return source:gsub("['\"]", replacements)
end

local function round(num, numDecimalPlaces)
    if numDecimalPlaces and numDecimalPlaces > 0 then
        local mult = 10 ^ numDecimalPlaces
        return math.floor(num * mult + 0.5) / mult
    end
    return math.floor(num + 0.5)
end

function QBPhone.AddMentionedTweet(citizenid, TweetData)
    if MentionedTweets[citizenid] == nil then
        MentionedTweets[citizenid] = {}
    end
    MentionedTweets[citizenid][#MentionedTweets[citizenid]+1] = TweetData
end

function QBPhone.SetPhoneAlerts(citizenid, app, alerts)
    if citizenid ~= nil and app ~= nil then
        if AppAlerts[citizenid] == nil then
            AppAlerts[citizenid] = {}
            if AppAlerts[citizenid][app] == nil then
                if alerts == nil then
                    AppAlerts[citizenid][app] = 1
                else
                    AppAlerts[citizenid][app] = alerts
                end
            end
        else
            if AppAlerts[citizenid][app] == nil then
                if alerts == nil then
                    AppAlerts[citizenid][app] = 1
                else
                    AppAlerts[citizenid][app] = 0
                end
            else
                if alerts == nil then
                    AppAlerts[citizenid][app] = AppAlerts[citizenid][app] + 1
                else
                    AppAlerts[citizenid][app] = AppAlerts[citizenid][app] + 0
                end
            end
        end
    end
end

local function SplitStringToArray(string)
    local retval = {}
    for i in string.gmatch(string, "%S+") do
        retval[#retval+1] = i
    end
    return retval
end

local function GenerateOwnerName()
    local names = {
        [1] = {
            name = "Jan Bloksteen",
            citizenid = "DSH091G93"
        },
        [2] = {
            name = "Jay Dendam",
            citizenid = "AVH09M193"
        },
        [3] = {
            name = "Ben Klaariskees",
            citizenid = "DVH091T93"
        },
        [4] = {
            name = "Karel Bakker",
            citizenid = "GZP091G93"
        },
        [5] = {
            name = "Klaas Adriaan",
            citizenid = "DRH09Z193"
        },
        [6] = {
            name = "Nico Wolters",
            citizenid = "KGV091J93"
        },
        [7] = {
            name = "Mark Hendrickx",
            citizenid = "ODF09S193"
        },
        [8] = {
            name = "Bert Johannes",
            citizenid = "KSD0919H3"
        },
        [9] = {
            name = "Karel de Grote",
            citizenid = "NDX091D93"
        },
        [10] = {
            name = "Jan Pieter",
            citizenid = "ZAL0919X3"
        },
        [11] = {
            name = "Huig Roelink",
            citizenid = "ZAK09D193"
        },
        [12] = {
            name = "Corneel Boerselman",
            citizenid = "POL09F193"
        },
        [13] = {
            name = "Hermen Klein Overmeen",
            citizenid = "TEW0J9193"
        },
        [14] = {
            name = "Bart Rielink",
            citizenid = "YOO09H193"
        },
        [15] = {
            name = "Antoon Henselijn",
            citizenid = "QBC091H93"
        },
        [16] = {
            name = "Aad Keizer",
            citizenid = "YDN091H93"
        },
        [17] = {
            name = "Thijn Kiel",
            citizenid = "PJD09D193"
        },
        [18] = {
            name = "Henkie Krikhaar",
            citizenid = "RND091D93"
        },
        [19] = {
            name = "Teun Blaauwkamp",
            citizenid = "QWE091A93"
        },
        [20] = {
            name = "Dries Stielstra",
            citizenid = "KJH0919M3"
        },
        [21] = {
            name = "Karlijn Hensbergen",
            citizenid = "ZXC09D193"
        },
        [22] = {
            name = "Aafke van Daalen",
            citizenid = "XYZ0919C3"
        },
        [23] = {
            name = "Door Leeferds",
            citizenid = "ZYX0919F3"
        },
        [24] = {
            name = "Nelleke Broedersen",
            citizenid = "IOP091O93"
        },
        [25] = {
            name = "Renske de Raaf",
            citizenid = "PIO091R93"
        },
        [26] = {
            name = "Krisje Moltman",
            citizenid = "LEK091X93"
        },
        [27] = {
            name = "Mirre Steevens",
            citizenid = "ALG091Y93"
        },
        [28] = {
            name = "Joosje Kalvenhaar",
            citizenid = "YUR09E193"
        },
        [29] = {
            name = "Mirte Ellenbroek",
            citizenid = "SOM091W93"
        },
        [30] = {
            name = "Marlieke Meilink",
            citizenid = "KAS09193"
        }
    }
    return names[math.random(1, #names)]
end

-- Callbacks

QBCore.Functions.CreateCallback('qb-phone:server:GetCallState', function(source, cb, ContactData)
    local Target = QBCore.Functions.GetPlayerByPhone(ContactData.number)
    if Target ~= nil then
        if Calls[Target.PlayerData.citizenid] ~= nil then
            if Calls[Target.PlayerData.citizenid].inCall then
                cb(false, true)
            else
                cb(true, true)
            end
        else
            cb(true, true)
        end
    else
        cb(false, false)
    end
end)

QBCore.Functions.CreateCallback('qb-phone:server:GetPhoneData', function(source, cb)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    if Player ~= nil then
        local PhoneData = {
            Applications = {},
            PlayerContacts = {},
            MentionedTweets = {},
            Chats = {},
            Hashtags = {},
            Invoices = {},
            Garage = {},
            Mails = {},
            Adverts = {},
            CryptoTransactions = {},
            Tweets = {},
            InstalledApps = Player.PlayerData.metadata["phonedata"].InstalledApps
        }
        PhoneData.Adverts = Adverts

        local result = exports.oxmysql:executeSync('SELECT * FROM player_contacts WHERE citizenid = ? ORDER BY name ASC', {Player.PlayerData.citizenid})
        local Contacts = {}
        if result[1] ~= nil then
            for k, v in pairs(result) do
                v.status = GetOnlineStatus(v.number)
            end

            PhoneData.PlayerContacts = result
        end

        local invoices = exports.oxmysql:executeSync('SELECT * FROM phone_invoices WHERE citizenid = ?', {Player.PlayerData.citizenid})
        if invoices[1] ~= nil then
            for k, v in pairs(invoices) do
                local Ply = QBCore.Functions.GetPlayerByCitizenId(v.sender)
                if Ply ~= nil then
                    v.number = Ply.PlayerData.charinfo.phone
                else
                    local res = exports.oxmysql:executeSync('SELECT * FROM players WHERE citizenid = ?', {v.sender})
                    if res[1] ~= nil then
                        res[1].charinfo = json.decode(res[1].charinfo)
                        v.number = res[1].charinfo.phone
                    else
                        v.number = nil
                    end
                end
            end
            PhoneData.Invoices = invoices
        end

        local garageresult = exports.oxmysql:executeSync('SELECT * FROM player_vehicles WHERE citizenid = ?', {Player.PlayerData.citizenid})
        if garageresult[1] ~= nil then
            for k, v in pairs(garageresult) do
                local vehicleModel = v.vehicle
                if (QBCore.Shared.Vehicles[vehicleModel] ~= nil) and (Garages[v.garage] ~= nil) then
                    v.garage = Garages[v.garage].label
                    v.vehicle = QBCore.Shared.Vehicles[vehicleModel].name
                    v.brand = QBCore.Shared.Vehicles[vehicleModel].brand
                end

            end
            PhoneData.Garage = garageresult
        end

        local messages = exports.oxmysql:executeSync('SELECT * FROM phone_messages WHERE citizenid = ?', {Player.PlayerData.citizenid})
        if messages ~= nil and next(messages) ~= nil then
            PhoneData.Chats = messages
        end

        if AppAlerts[Player.PlayerData.citizenid] ~= nil then
            PhoneData.Applications = AppAlerts[Player.PlayerData.citizenid]
        end

        if MentionedTweets[Player.PlayerData.citizenid] ~= nil then
            PhoneData.MentionedTweets = MentionedTweets[Player.PlayerData.citizenid]
        end

        if Hashtags ~= nil and next(Hashtags) ~= nil then
            PhoneData.Hashtags = Hashtags
        end

        if Tweets ~= nil and next(Tweets) ~= nil then
            PhoneData.Tweets = Tweets
        end

        local mails = exports.oxmysql:executeSync('SELECT * FROM player_mails WHERE citizenid = ? ORDER BY `date` ASC', {Player.PlayerData.citizenid})
        if mails[1] ~= nil then
            for k, v in pairs(mails) do
                if mails[k].button ~= nil then
                    mails[k].button = json.decode(mails[k].button)
                end
            end
            PhoneData.Mails = mails
        end

        local transactions = exports.oxmysql:executeSync('SELECT * FROM crypto_transactions WHERE citizenid = ? ORDER BY `date` ASC', {Player.PlayerData.citizenid})
        if transactions[1] ~= nil then
            for _, v in pairs(transactions) do
                PhoneData.CryptoTransactions[#PhoneData.CryptoTransactions+1] = {
                    TransactionTitle = v.title,
                    TransactionMessage = v.message
                }
            end
        end

        cb(PhoneData)
    end
end)

QBCore.Functions.CreateCallback('qb-phone:server:PayInvoice', function(source, cb, society, amount, invoiceId, sendercitizenid)
    local Invoices = {}
    local Ply = QBCore.Functions.GetPlayer(source)
    local SenderPly = QBCore.Functions.GetPlayerByCitizenId(sendercitizenid)
    local invoiceMailData = {}
    if SenderPly and Config.BillingCommissions[society] then
        local commission = round(amount * Config.BillingCommissions[society])
        SenderPly.Functions.AddMoney('bank', commission)
        invoiceMailData = {
            sender = 'Billing Department',
            subject = 'Commission Received',
            message = string.format('You received a commission check of $%s when %s %s paid a bill of $%s.', commission, Ply.PlayerData.charinfo.firstname, Ply.PlayerData.charinfo.lastname, amount)
        }
    elseif not SenderPly and Config.BillingCommissions[society] then
        invoiceMailData = {
            sender = 'Billing Department',
            subject = 'Bill Paid',
            message = string.format('%s %s paid a bill of $%s', Ply.PlayerData.charinfo.firstname, Ply.PlayerData.charinfo.lastname, amount)
        }
    end
    Ply.Functions.RemoveMoney('bank', amount, "paid-invoice")
    TriggerEvent('qb-phone:server:sendNewMailToOffline', sendercitizenid, invoiceMailData)
    TriggerEvent("qb-bossmenu:server:addAccountMoney", society, amount)
    exports.oxmysql:execute('DELETE FROM phone_invoices WHERE id = ?', {invoiceId})
    local invoices = exports.oxmysql:executeSync('SELECT * FROM phone_invoices WHERE citizenid = ?', {Ply.PlayerData.citizenid})
    if invoices[1] ~= nil then
        Invoices = invoices
    end
    cb(true, Invoices)
end)

QBCore.Functions.CreateCallback('qb-phone:server:DeclineInvoice', function(source, cb, sender, amount, invoiceId)
    local Invoices = {}
    local Ply = QBCore.Functions.GetPlayer(source)
    exports.oxmysql:execute('DELETE FROM phone_invoices WHERE id = ?', {invoiceId})
    local invoices = exports.oxmysql:executeSync('SELECT * FROM phone_invoices WHERE citizenid = ?', {Ply.PlayerData.citizenid})
    if invoices[1] ~= nil then
        Invoices = invoices
    end
    cb(true, Invoices)
end)

QBCore.Functions.CreateCallback('qb-phone:server:GetContactPictures', function(source, cb, Chats)
    for k, v in pairs(Chats) do
        local Player = QBCore.Functions.GetPlayerByPhone(v.number)

        local query = '%' .. v.number .. '%'
        local result = exports.oxmysql:executeSync('SELECT * FROM players WHERE charinfo LIKE ?', {query})
        if result[1] ~= nil then
            local MetaData = json.decode(result[1].metadata)

            if MetaData.phone.profilepicture ~= nil then
                v.picture = MetaData.phone.profilepicture
            else
                v.picture = "default"
            end
        end
    end
    SetTimeout(100, function()
        cb(Chats)
    end)
end)

QBCore.Functions.CreateCallback('qb-phone:server:GetContactPicture', function(source, cb, Chat)
    local query = '%' .. Chat.number .. '%'
    local result = exports.oxmysql:executeSync('SELECT * FROM players WHERE charinfo LIKE ?', {query})
    local MetaData = json.decode(result[1].metadata)
    if MetaData.phone.profilepicture ~= nil then
        Chat.picture = MetaData.phone.profilepicture
    else
        Chat.picture = "default"
    end
    SetTimeout(100, function()
        cb(Chat)
    end)
end)

QBCore.Functions.CreateCallback('qb-phone:server:GetPicture', function(source, cb, number)
    local Picture = nil
    local query = '%' .. number .. '%'
    local result = exports.oxmysql:executeSync('SELECT * FROM players WHERE charinfo LIKE ?', {query})
    if result[1] ~= nil then
        local MetaData = json.decode(result[1].metadata)
        if MetaData.phone.profilepicture ~= nil then
            Picture = MetaData.phone.profilepicture
        else
            Picture = "default"
        end
        cb(Picture)
    else
        cb(nil)
    end
end)

QBCore.Functions.CreateCallback('qb-phone:server:FetchResult', function(source, cb, search)
    local search = escape_sqli(search)
    local searchData = {}
    local ApaData = {}
    local query = 'SELECT * FROM `players` WHERE `citizenid` = "' .. search .. '"'
    -- Split on " " and check each var individual
    local searchParameters = SplitStringToArray(search)
    -- Construct query dynamicly for individual parm check
    if #searchParameters > 1 then
        query = query .. ' OR `charinfo` LIKE "%' .. searchParameters[1] .. '%"'
        for i = 2, #searchParameters do
            query = query .. ' AND `charinfo` LIKE  "%' .. searchParameters[i] .. '%"'
        end
    else
        query = query .. ' OR `charinfo` LIKE "%' .. search .. '%"'
    end
    local ApartmentData = exports.oxmysql:executeSync('SELECT * FROM apartments', {})
    for k, v in pairs(ApartmentData) do
        ApaData[v.citizenid] = ApartmentData[k]
    end
    local result = exports.oxmysql:executeSync(query)
    if result[1] ~= nil then
        for k, v in pairs(result) do
            local charinfo = json.decode(v.charinfo)
            local metadata = json.decode(v.metadata)
            local appiepappie = {}
            if ApaData[v.citizenid] ~= nil and next(ApaData[v.citizenid]) ~= nil then
                appiepappie = ApaData[v.citizenid]
            end
            searchData[#searchData+1] = {
                citizenid = v.citizenid,
                firstname = charinfo.firstname,
                lastname = charinfo.lastname,
                birthdate = charinfo.birthdate,
                phone = charinfo.phone,
                nationality = charinfo.nationality,
                gender = charinfo.gender,
                warrant = false,
                driverlicense = metadata["licences"]["driver"],
                appartmentdata = appiepappie
            }
        end
        cb(searchData)
    else
        cb(nil)
    end
end)

QBCore.Functions.CreateCallback('qb-phone:server:GetVehicleSearchResults', function(source, cb, search)
    local search = escape_sqli(search)
    local searchData = {}
    local query = '%' .. search .. '%'
    local result = exports.oxmysql:executeSync('SELECT * FROM player_vehicles WHERE plate LIKE ? OR citizenid = ?',
        {query, search})
    if result[1] ~= nil then
        for k, v in pairs(result) do
            local player = exports.oxmysql:executeSync('SELECT * FROM players WHERE citizenid = ?', {result[k].citizenid})
            if player[1] ~= nil then
                local charinfo = json.decode(player[1].charinfo)
                local vehicleInfo = QBCore.Shared.Vehicles[result[k].vehicle]
                if vehicleInfo ~= nil then
                    searchData[#searchData+1] = {
                        plate = result[k].plate,
                        status = true,
                        owner = charinfo.firstname .. " " .. charinfo.lastname,
                        citizenid = result[k].citizenid,
                        label = vehicleInfo["name"]
                    }
                else
                    searchData[#searchData+1] = {
                        plate = result[k].plate,
                        status = true,
                        owner = charinfo.firstname .. " " .. charinfo.lastname,
                        citizenid = result[k].citizenid,
                        label = "Name not found.."
                    }
                end
            end
        end
    else
        if GeneratedPlates[search] ~= nil then
            searchData[#searchData+1] = {
                plate = GeneratedPlates[search].plate,
                status = GeneratedPlates[search].status,
                owner = GeneratedPlates[search].owner,
                citizenid = GeneratedPlates[search].citizenid,
                label = "Brand unknown.."
            }
        else
            local ownerInfo = GenerateOwnerName()
            GeneratedPlates[search] = {
                plate = search,
                status = true,
                owner = ownerInfo.name,
                citizenid = ownerInfo.citizenid
            }
            searchData[#searchData+1] = {
                plate = search,
                status = true,
                owner = ownerInfo.name,
                citizenid = ownerInfo.citizenid,
                label = "Brand unknown.."
            }
        end
    end
    cb(searchData)
end)

QBCore.Functions.CreateCallback('qb-phone:server:ScanPlate', function(source, cb, plate)
    local src = source
    local vehicleData = {}
    if plate ~= nil then
        local result = exports.oxmysql:executeSync('SELECT * FROM player_vehicles WHERE plate = ?', {plate})
        if result[1] ~= nil then
            local player = exports.oxmysql:executeSync('SELECT * FROM players WHERE citizenid = ?', {result[1].citizenid})
            local charinfo = json.decode(player[1].charinfo)
            vehicleData = {
                plate = plate,
                status = true,
                owner = charinfo.firstname .. " " .. charinfo.lastname,
                citizenid = result[1].citizenid
            }
        elseif GeneratedPlates ~= nil and GeneratedPlates[plate] ~= nil then
            vehicleData = GeneratedPlates[plate]
        else
            local ownerInfo = GenerateOwnerName()
            GeneratedPlates[plate] = {
                plate = plate,
                status = true,
                owner = ownerInfo.name,
                citizenid = ownerInfo.citizenid
            }
            vehicleData = {
                plate = plate,
                status = true,
                owner = ownerInfo.name,
                citizenid = ownerInfo.citizenid
            }
        end
        cb(vehicleData)
    else
        TriggerClientEvent('QBCore:Notify', src, 'No Vehicle Nearby', 'error')
        cb(nil)
    end
end)

QBCore.Functions.CreateCallback('qb-phone:server:GetGarageVehicles', function(source, cb)
    local Player = QBCore.Functions.GetPlayer(source)
    local Vehicles = {}

    local result = exports.oxmysql:executeSync('SELECT * FROM player_vehicles WHERE citizenid = ?',
        {Player.PlayerData.citizenid})
    if result[1] ~= nil then
        for k, v in pairs(result) do
            local VehicleData = QBCore.Shared.Vehicles[v.vehicle]

            local VehicleGarage = "None"
            if v.garage ~= nil then
                if Garages[v.garage] ~= nil then
                    VehicleGarage = Garages[v.garage]["label"]
                end
            end

            local VehicleState = "In"
            if v.state == 0 then
                VehicleState = "Out"
            elseif v.state == 2 then
                VehicleState = "Impounded"
            end

            local vehdata = {}

            if VehicleData["brand"] ~= nil then
                vehdata = {
                    fullname = VehicleData["brand"] .. " " .. VehicleData["name"],
                    brand = VehicleData["brand"],
                    model = VehicleData["name"],
                    plate = v.plate,
                    garage = VehicleGarage,
                    state = VehicleState,
                    fuel = v.fuel,
                    engine = v.engine,
                    body = v.body
                }
            else
                vehdata = {
                    fullname = VehicleData["name"],
                    brand = VehicleData["name"],
                    model = VehicleData["name"],
                    plate = v.plate,
                    garage = VehicleGarage,
                    state = VehicleState,
                    fuel = v.fuel,
                    engine = v.engine,
                    body = v.body
                }
            end
            Vehicles[#Vehicles+1] = vehdata
        end
        cb(Vehicles)
    else
        cb(nil)
    end
end)

QBCore.Functions.CreateCallback('qb-phone:server:HasPhone', function(source, cb)
    local Player = QBCore.Functions.GetPlayer(source)
    if Player ~= nil then
        local HasPhone = Player.Functions.GetItemByName("phone")
        if HasPhone ~= nil then
            cb(true)
        else
            cb(false)
        end
    end
end)

QBCore.Functions.CreateCallback('qb-phone:server:CanTransferMoney', function(source, cb, amount, iban)
    local Player = QBCore.Functions.GetPlayer(source)
    if (Player.PlayerData.money.bank - amount) >= 0 then
        local query = '%' .. iban .. '%'
        local result = exports.oxmysql:executeSync('SELECT * FROM players WHERE charinfo LIKE ?', {query})
        if result[1] ~= nil then
            local Reciever = QBCore.Functions.GetPlayerByCitizenId(result[1].citizenid)
            Player.Functions.RemoveMoney('bank', amount)
            if Reciever ~= nil then
                Reciever.Functions.AddMoney('bank', amount)
            else
                local RecieverMoney = json.decode(result[1].money)
                RecieverMoney.bank = (RecieverMoney.bank + amount)
                exports.oxmysql:execute('UPDATE players SET money = ? WHERE citizenid = ?', {json.encode(RecieverMoney), result[1].citizenid})
            end
            cb(true)
        else
            TriggerClientEvent('QBCore:Notify', source, "This account number does not exist!", "error")
            cb(false)
        end
    end
end)

QBCore.Functions.CreateCallback('qb-phone:server:GetCurrentLawyers', function(source, cb)
    local Lawyers = {}
    for k, v in pairs(QBCore.Functions.GetPlayers()) do
        local Player = QBCore.Functions.GetPlayer(v)
        if Player ~= nil then
            if (Player.PlayerData.job.name == "lawyer" or Player.PlayerData.job.name == "realestate" or
                Player.PlayerData.job.name == "mechanic" or Player.PlayerData.job.name == "taxi" or
                Player.PlayerData.job.name == "police" or Player.PlayerData.job.name == "ambulance") and
                Player.PlayerData.job.onduty then
                Lawyers[#Lawyers+1] = {
                    name = Player.PlayerData.charinfo.firstname .. " " .. Player.PlayerData.charinfo.lastname,
                    phone = Player.PlayerData.charinfo.phone,
                    typejob = Player.PlayerData.job.name
                }
            end
        end
    end
    cb(Lawyers)
end)

QBCore.Functions.CreateCallback("qb-phone:server:GetWebhook",function(source,cb)
	if WebHook ~= "" then
		cb(WebHook)
	else
		cb(nil)
	end

end)

-- Events

RegisterNetEvent('qb-phone:server:AddAdvert', function(msg, url)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    local CitizenId = Player.PlayerData.citizenid
    if Adverts[CitizenId] ~= nil then
        Adverts[CitizenId].message = msg
        Adverts[CitizenId].name = "@" .. Player.PlayerData.charinfo.firstname .. "" .. Player.PlayerData.charinfo.lastname
        Adverts[CitizenId].number = Player.PlayerData.charinfo.phone
        Adverts[CitizenId].url = url
    else
        Adverts[CitizenId] = {
            message = msg,
            name = "@" .. Player.PlayerData.charinfo.firstname .. "" .. Player.PlayerData.charinfo.lastname,
            number = Player.PlayerData.charinfo.phone,
            url = url
        }
    end
    TriggerClientEvent('qb-phone:client:UpdateAdverts', -1, Adverts, "@" .. Player.PlayerData.charinfo.firstname .. "" .. Player.PlayerData.charinfo.lastname)
end)

RegisterNetEvent('qb-phone:server:SetCallState', function(bool)
    local src = source
    local Ply = QBCore.Functions.GetPlayer(src)
    if Calls[Ply.PlayerData.citizenid] ~= nil then
        Calls[Ply.PlayerData.citizenid].inCall = bool
    else
        Calls[Ply.PlayerData.citizenid] = {}
        Calls[Ply.PlayerData.citizenid].inCall = bool
    end
end)

RegisterNetEvent('qb-phone:server:RemoveMail', function(MailId)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    exports.oxmysql:execute('DELETE FROM player_mails WHERE mailid = ? AND citizenid = ?', {MailId, Player.PlayerData.citizenid})
    SetTimeout(100, function()
        local mails = exports.oxmysql:executeSync('SELECT * FROM player_mails WHERE citizenid = ? ORDER BY `date` ASC', {Player.PlayerData.citizenid})
        if mails[1] ~= nil then
            for k, v in pairs(mails) do
                if mails[k].button ~= nil then
                    mails[k].button = json.decode(mails[k].button)
                end
            end
        end
        TriggerClientEvent('qb-phone:client:UpdateMails', src, mails)
    end)
end)

RegisterNetEvent('qb-phone:server:sendNewMail', function(mailData)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    if mailData.button == nil then
        exports.oxmysql:insert('INSERT INTO player_mails (`citizenid`, `sender`, `subject`, `message`, `mailid`, `read`) VALUES (?, ?, ?, ?, ?, ?)', {Player.PlayerData.citizenid, mailData.sender, mailData.subject, mailData.message, GenerateMailId(), 0})
    else
        exports.oxmysql:insert('INSERT INTO player_mails (`citizenid`, `sender`, `subject`, `message`, `mailid`, `read`, `button`) VALUES (?, ?, ?, ?, ?, ?, ?)', {Player.PlayerData.citizenid, mailData.sender, mailData.subject, mailData.message, GenerateMailId(), 0, json.encode(mailData.button)})
    end
    TriggerClientEvent('qb-phone:client:NewMailNotify', src, mailData)
    SetTimeout(200, function()
        local mails = exports.oxmysql:executeSync('SELECT * FROM player_mails WHERE citizenid = ? ORDER BY `date` DESC',
            {Player.PlayerData.citizenid})
        if mails[1] ~= nil then
            for k, v in pairs(mails) do
                if mails[k].button ~= nil then
                    mails[k].button = json.decode(mails[k].button)
                end
            end
        end

        TriggerClientEvent('qb-phone:client:UpdateMails', src, mails)
    end)
end)

RegisterNetEvent('qb-phone:server:sendNewMailToOffline', function(citizenid, mailData)
    local Player = QBCore.Functions.GetPlayerByCitizenId(citizenid)
    if Player then
        local src = Player.PlayerData.source
        if mailData.button == nil then
            exports.oxmysql:insert('INSERT INTO player_mails (`citizenid`, `sender`, `subject`, `message`, `mailid`, `read`) VALUES (?, ?, ?, ?, ?, ?)', {Player.PlayerData.citizenid, mailData.sender, mailData.subject, mailData.message, GenerateMailId(), 0})
            TriggerClientEvent('qb-phone:client:NewMailNotify', src, mailData)
        else
            exports.oxmysql:insert('INSERT INTO player_mails (`citizenid`, `sender`, `subject`, `message`, `mailid`, `read`, `button`) VALUES (?, ?, ?, ?, ?, ?, ?)', {Player.PlayerData.citizenid, mailData.sender, mailData.subject, mailData.message, GenerateMailId(), 0, json.encode(mailData.button)})
            TriggerClientEvent('qb-phone:client:NewMailNotify', src, mailData)
        end
        SetTimeout(200, function()
            local mails = exports.oxmysql:executeSync(
                'SELECT * FROM player_mails WHERE citizenid = ? ORDER BY `date` ASC', {Player.PlayerData.citizenid})
            if mails[1] ~= nil then
                for k, v in pairs(mails) do
                    if mails[k].button ~= nil then
                        mails[k].button = json.decode(mails[k].button)
                    end
                end
            end

            TriggerClientEvent('qb-phone:client:UpdateMails', src, mails)
        end)
    else
        if mailData.button == nil then
            exports.oxmysql:insert('INSERT INTO player_mails (`citizenid`, `sender`, `subject`, `message`, `mailid`, `read`) VALUES (?, ?, ?, ?, ?, ?)', {citizenid, mailData.sender, mailData.subject, mailData.message, GenerateMailId(), 0})
        else
            exports.oxmysql:insert('INSERT INTO player_mails (`citizenid`, `sender`, `subject`, `message`, `mailid`, `read`, `button`) VALUES (?, ?, ?, ?, ?, ?, ?)', {citizenid, mailData.sender, mailData.subject, mailData.message, GenerateMailId(), 0, json.encode(mailData.button)})
        end
    end
end)

RegisterNetEvent('qb-phone:server:sendNewEventMail', function(citizenid, mailData)
    local Player = QBCore.Functions.GetPlayerByCitizenId(citizenid)
    if mailData.button == nil then
        exports.oxmysql:insert('INSERT INTO player_mails (`citizenid`, `sender`, `subject`, `message`, `mailid`, `read`) VALUES (?, ?, ?, ?, ?, ?)', {citizenid, mailData.sender, mailData.subject, mailData.message, GenerateMailId(), 0})
    else
        exports.oxmysql:insert('INSERT INTO player_mails (`citizenid`, `sender`, `subject`, `message`, `mailid`, `read`, `button`) VALUES (?, ?, ?, ?, ?, ?, ?)', {citizenid, mailData.sender, mailData.subject, mailData.message, GenerateMailId(), 0, json.encode(mailData.button)})
    end
    SetTimeout(200, function()
        local mails = exports.oxmysql:executeSync('SELECT * FROM player_mails WHERE citizenid = ? ORDER BY `date` ASC', {citizenid})
        if mails[1] ~= nil then
            for k, v in pairs(mails) do
                if mails[k].button ~= nil then
                    mails[k].button = json.decode(mails[k].button)
                end
            end
        end
        TriggerClientEvent('qb-phone:client:UpdateMails', Player.PlayerData.source, mails)
    end)
end)

RegisterNetEvent('qb-phone:server:ClearButtonData', function(mailId)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    exports.oxmysql:execute('UPDATE player_mails SET button = ? WHERE mailid = ? AND citizenid = ?', {'', mailId, Player.PlayerData.citizenid})
    SetTimeout(200, function()
        local mails = exports.oxmysql:executeSync('SELECT * FROM player_mails WHERE citizenid = ? ORDER BY `date` ASC', {Player.PlayerData.citizenid})
        if mails[1] ~= nil then
            for k, v in pairs(mails) do
                if mails[k].button ~= nil then
                    mails[k].button = json.decode(mails[k].button)
                end
            end
        end
        TriggerClientEvent('qb-phone:client:UpdateMails', src, mails)
    end)
end)

RegisterNetEvent('qb-phone:server:MentionedPlayer', function(firstName, lastName, TweetMessage)
    for k, v in pairs(QBCore.Functions.GetPlayers()) do
        local Player = QBCore.Functions.GetPlayer(v)
        if Player ~= nil then
            if (Player.PlayerData.charinfo.firstname == firstName and Player.PlayerData.charinfo.lastname == lastName) then
                QBPhone.SetPhoneAlerts(Player.PlayerData.citizenid, "twitter")
                QBPhone.AddMentionedTweet(Player.PlayerData.citizenid, TweetMessage)
                TriggerClientEvent('qb-phone:client:GetMentioned', Player.PlayerData.source, TweetMessage, AppAlerts[Player.PlayerData.citizenid]["twitter"])
            else
                local query1 = '%' .. firstName .. '%'
                local query2 = '%' .. lastName .. '%'
                local result = exports.oxmysql:executeSync('SELECT * FROM players WHERE charinfo LIKE ? AND charinfo LIKE ?', {query1, query2})
                if result[1] ~= nil then
                    local MentionedTarget = result[1].citizenid
                    QBPhone.SetPhoneAlerts(MentionedTarget, "twitter")
                    QBPhone.AddMentionedTweet(MentionedTarget, TweetMessage)
                end
            end
        end
    end
end)

RegisterNetEvent('qb-phone:server:CallContact', function(TargetData, CallId, AnonymousCall)
    local src = source
    local Ply = QBCore.Functions.GetPlayer(src)
    local Target = QBCore.Functions.GetPlayerByPhone(TargetData.number)
    if Target ~= nil then
        TriggerClientEvent('qb-phone:client:GetCalled', Target.PlayerData.source, Ply.PlayerData.charinfo.phone, CallId, AnonymousCall)
    end
end)

RegisterNetEvent('qb-phone:server:BillingEmail', function(data, paid)
    for k, v in pairs(QBCore.Functions.GetPlayers()) do
        local target = QBCore.Functions.GetPlayer(v)
        if target.PlayerData.job.name == data.society then
            if paid then
                local name = '' .. QBCore.Functions.GetPlayer(source).PlayerData.charinfo.firstname .. ' ' .. QBCore.Functions.GetPlayer(source).PlayerData.charinfo.lastname .. ''
                TriggerClientEvent('qb-phone:client:BillingEmail', target.PlayerData.source, data, true, name)
            else
                local name = '' .. QBCore.Functions.GetPlayer(source).PlayerData.charinfo.firstname .. ' ' .. QBCore.Functions.GetPlayer(source).PlayerData.charinfo.lastname .. ''
                TriggerClientEvent('qb-phone:client:BillingEmail', target.PlayerData.source, data, false, name)
            end
        end
    end
end)

RegisterNetEvent('qb-phone:server:UpdateHashtags', function(Handle, messageData)
    if Hashtags[Handle] ~= nil and next(Hashtags[Handle]) ~= nil then
        Hashtags[Handle].messages[#Hashtags[Handle].messages+1] = messageData
    else
        Hashtags[Handle] = {
            hashtag = Handle,
            messages = {}
        }
        Hashtags[Handle].messages[#Hashtags[Handle].messages+1] = messageData
    end
    TriggerClientEvent('qb-phone:client:UpdateHashtags', -1, Handle, messageData)
end)

RegisterNetEvent('qb-phone:server:SetPhoneAlerts', function(app, alerts)
    local src = source
    local CitizenId = QBCore.Functions.GetPlayer(src).citizenid
    QBPhone.SetPhoneAlerts(CitizenId, app, alerts)
end)

RegisterNetEvent('qb-phone:server:UpdateTweets', function(NewTweets, TweetData)
    Tweets = NewTweets
    local TwtData = TweetData
    local src = source
    TriggerClientEvent('qb-phone:client:UpdateTweets', -1, src, Tweets, TwtData)
end)

RegisterNetEvent('qb-phone:server:TransferMoney', function(iban, amount)
    local src = source
    local sender = QBCore.Functions.GetPlayer(src)

    local query = '%' .. iban .. '%'
    local result = exports.oxmysql:executeSync('SELECT * FROM players WHERE charinfo LIKE ?', {query})
    if result[1] ~= nil then
        local reciever = QBCore.Functions.GetPlayerByCitizenId(result[1].citizenid)

        if reciever ~= nil then
            local PhoneItem = reciever.Functions.GetItemByName("phone")
            reciever.Functions.AddMoney('bank', amount, "phone-transfered-from-" .. sender.PlayerData.citizenid)
            sender.Functions.RemoveMoney('bank', amount, "phone-transfered-to-" .. reciever.PlayerData.citizenid)

            if PhoneItem ~= nil then
                TriggerClientEvent('qb-phone:client:TransferMoney', reciever.PlayerData.source, amount,
                    reciever.PlayerData.money.bank)
            end
        else
            local moneyInfo = json.decode(result[1].money)
            moneyInfo.bank = round((moneyInfo.bank + amount))
            exports.oxmysql:execute('UPDATE players SET money = ? WHERE citizenid = ?',
                {json.encode(moneyInfo), result[1].citizenid})
            sender.Functions.RemoveMoney('bank', amount, "phone-transfered")
        end
    else
        TriggerClientEvent('QBCore:Notify', src, "This account number doesn't exist!", "error")
    end
end)

RegisterNetEvent('qb-phone:server:EditContact', function(newName, newNumber, newIban, oldName, oldNumber, oldIban)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    exports.oxmysql:execute(
        'UPDATE player_contacts SET name = ?, number = ?, iban = ? WHERE citizenid = ? AND name = ? AND number = ?',
        {newName, newNumber, newIban, Player.PlayerData.citizenid, oldName, oldNumber})
end)

RegisterNetEvent('qb-phone:server:RemoveContact', function(Name, Number)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    exports.oxmysql:execute('DELETE FROM player_contacts WHERE name = ? AND number = ? AND citizenid = ?',
        {Name, Number, Player.PlayerData.citizenid})
end)

RegisterNetEvent('qb-phone:server:AddNewContact', function(name, number, iban)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    exports.oxmysql:insert('INSERT INTO player_contacts (citizenid, name, number, iban) VALUES (?, ?, ?, ?)', {Player.PlayerData.citizenid, tostring(name), tostring(number), tostring(iban)})
end)

RegisterNetEvent('qb-phone:server:UpdateMessages', function(ChatMessages, ChatNumber, New)
    local src = source
    local SenderData = QBCore.Functions.GetPlayer(src)
    local query = '%' .. ChatNumber .. '%'
    local Player = exports.oxmysql:executeSync('SELECT * FROM players WHERE charinfo LIKE ?', {query})
    if Player[1] ~= nil then
        local TargetData = QBCore.Functions.GetPlayerByCitizenId(Player[1].citizenid)
        if TargetData ~= nil then
            local Chat = exports.oxmysql:executeSync('SELECT * FROM phone_messages WHERE citizenid = ? AND number = ?', {SenderData.PlayerData.citizenid, ChatNumber})
            if Chat[1] ~= nil then
                -- Update for target
                exports.oxmysql:execute('UPDATE phone_messages SET messages = ? WHERE citizenid = ? AND number = ?', {json.encode(ChatMessages), TargetData.PlayerData.citizenid, SenderData.PlayerData.charinfo.phone})
                -- Update for sender
                exports.oxmysql:execute('UPDATE phone_messages SET messages = ? WHERE citizenid = ? AND number = ?', {json.encode(ChatMessages), SenderData.PlayerData.citizenid, TargetData.PlayerData.charinfo.phone})
                -- Send notification & Update messages for target
                TriggerClientEvent('qb-phone:client:UpdateMessages', TargetData.PlayerData.source, ChatMessages, SenderData.PlayerData.charinfo.phone, false)
            else
                -- Insert for target
                exports.oxmysql:insert('INSERT INTO phone_messages (citizenid, number, messages) VALUES (?, ?, ?)', {TargetData.PlayerData.citizenid, SenderData.PlayerData.charinfo.phone, json.encode(ChatMessages)})
                -- Insert for sender
                exports.oxmysql:insert('INSERT INTO phone_messages (citizenid, number, messages) VALUES (?, ?, ?)', {SenderData.PlayerData.citizenid, TargetData.PlayerData.charinfo.phone, json.encode(ChatMessages)})
                -- Send notification & Update messages for target
                TriggerClientEvent('qb-phone:client:UpdateMessages', TargetData.PlayerData.source, ChatMessages, SenderData.PlayerData.charinfo.phone, true)
            end
        else
            local Chat = exports.oxmysql:executeSync('SELECT * FROM phone_messages WHERE citizenid = ? AND number = ?', {SenderData.PlayerData.citizenid, ChatNumber})
            if Chat[1] ~= nil then
                -- Update for target
                exports.oxmysql:execute('UPDATE phone_messages SET messages = ? WHERE citizenid = ? AND number = ?', {json.encode(ChatMessages), Player[1].citizenid, SenderData.PlayerData.charinfo.phone})
                -- Update for sender
                Player[1].charinfo = json.decode(Player[1].charinfo)
                exports.oxmysql:execute('UPDATE phone_messages SET messages = ? WHERE citizenid = ? AND number = ?', {json.encode(ChatMessages), SenderData.PlayerData.citizenid, Player[1].charinfo.phone})
            else
                -- Insert for target
                exports.oxmysql:insert('INSERT INTO phone_messages (citizenid, number, messages) VALUES (?, ?, ?)', {Player[1].citizenid, SenderData.PlayerData.charinfo.phone, json.encode(ChatMessages)})
                -- Insert for sender
                Player[1].charinfo = json.decode(Player[1].charinfo)
                exports.oxmysql:insert('INSERT INTO phone_messages (citizenid, number, messages) VALUES (?, ?, ?)', {SenderData.PlayerData.citizenid, Player[1].charinfo.phone, json.encode(ChatMessages)})
            end
        end
    end
end)

RegisterNetEvent('qb-phone:server:AddRecentCall', function(type, data)
    local src = source
    local Ply = QBCore.Functions.GetPlayer(src)
    local Hour = os.date("%H")
    local Minute = os.date("%M")
    local label = Hour .. ":" .. Minute
    TriggerClientEvent('qb-phone:client:AddRecentCall', src, data, label, type)
    local Trgt = QBCore.Functions.GetPlayerByPhone(data.number)
    if Trgt ~= nil then
        TriggerClientEvent('qb-phone:client:AddRecentCall', Trgt.PlayerData.source, {
            name = Ply.PlayerData.charinfo.firstname .. " " .. Ply.PlayerData.charinfo.lastname,
            number = Ply.PlayerData.charinfo.phone,
            anonymous = data.anonymous
        }, label, "outgoing")
    end
end)

RegisterNetEvent('qb-phone:server:CancelCall', function(ContactData)
    local Ply = QBCore.Functions.GetPlayerByPhone(ContactData.TargetData.number)
    if Ply ~= nil then
        TriggerClientEvent('qb-phone:client:CancelCall', Ply.PlayerData.source)
    end
end)

RegisterNetEvent('qb-phone:server:AnswerCall', function(CallData)
    local Ply = QBCore.Functions.GetPlayerByPhone(CallData.TargetData.number)
    if Ply ~= nil then
        TriggerClientEvent('qb-phone:client:AnswerCall', Ply.PlayerData.source)
    end
end)

RegisterNetEvent('qb-phone:server:SaveMetaData', function(MData)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    local result = exports.oxmysql:executeSync('SELECT * FROM players WHERE citizenid = ?', {Player.PlayerData.citizenid})
    local MetaData = json.decode(result[1].metadata)
    MetaData.phone = MData
    exports.oxmysql:execute('UPDATE players SET metadata = ? WHERE citizenid = ?',
        {json.encode(MetaData), Player.PlayerData.citizenid})
    Player.Functions.SetMetaData("phone", MData)
end)

RegisterNetEvent('qb-phone:server:GiveContactDetails', function(PlayerId)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    local SuggestionData = {
        name = {
            [1] = Player.PlayerData.charinfo.firstname,
            [2] = Player.PlayerData.charinfo.lastname
        },
        number = Player.PlayerData.charinfo.phone,
        bank = Player.PlayerData.charinfo.account
    }

    TriggerClientEvent('qb-phone:client:AddNewSuggestion', PlayerId, SuggestionData)
end)

RegisterNetEvent('qb-phone:server:AddTransaction', function(data)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    exports.oxmysql:insert('INSERT INTO crypto_transactions (citizenid, title, message) VALUES (?, ?, ?)', {
        Player.PlayerData.citizenid,
        data.TransactionTitle,
        data.TransactionMessage
    })
end)

RegisterNetEvent('qb-phone:server:InstallApplication', function(ApplicationData)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    Player.PlayerData.metadata["phonedata"].InstalledApps[ApplicationData.app] = ApplicationData
    Player.Functions.SetMetaData("phonedata", Player.PlayerData.metadata["phonedata"])

    -- TriggerClientEvent('qb-phone:RefreshPhone', src)
end)

RegisterNetEvent('qb-phone:server:RemoveInstallation', function(App)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    Player.PlayerData.metadata["phonedata"].InstalledApps[App] = nil
    Player.Functions.SetMetaData("phonedata", Player.PlayerData.metadata["phonedata"])

    -- TriggerClientEvent('qb-phone:RefreshPhone', src)
end)

-- Command

QBCore.Commands.Add("setmetadata", "Set Player Metadata (God Only)", {}, false, function(source, args)
    local Player = QBCore.Functions.GetPlayer(source)
    if args[1] then
        if args[1] == "trucker" then
            if args[2] then
                local newrep = Player.PlayerData.metadata["jobrep"]
                newrep.trucker = tonumber(args[2])
                Player.Functions.SetMetaData("jobrep", newrep)
            end
        end
    end
end, "god")

QBCore.Commands.Add('bill', 'Bill A Player', {{name = 'id', help = 'Player ID'}, {name = 'amount', help = 'Fine Amount'}}, false, function(source, args)
    local biller = QBCore.Functions.GetPlayer(source)
    local billed = QBCore.Functions.GetPlayer(tonumber(args[1]))
    local amount = tonumber(args[2])
    if biller.PlayerData.job.name == "police" or biller.PlayerData.job.name == 'ambulance' or biller.PlayerData.job.name == 'mechanic' then
        if billed ~= nil then
            if biller.PlayerData.citizenid ~= billed.PlayerData.citizenid then
                if amount and amount > 0 then
                    exports.oxmysql:insert(
                        'INSERT INTO phone_invoices (citizenid, amount, society, sender, sendercitizenid) VALUES (?, ?, ?, ?, ?)',
                        {billed.PlayerData.citizenid, amount, biller.PlayerData.job.name,
                         biller.PlayerData.charinfo.firstname, biller.PlayerData.citizenid})
                    TriggerClientEvent('qb-phone:RefreshPhone', billed.PlayerData.source)
                    TriggerClientEvent('QBCore:Notify', source, 'Invoice Successfully Sent', 'success')
                    TriggerClientEvent('QBCore:Notify', billed.PlayerData.source, 'New Invoice Received')
                else
                    TriggerClientEvent('QBCore:Notify', source, 'Must Be A Valid Amount Above 0', 'error')
                end
            else
                TriggerClientEvent('QBCore:Notify', source, 'You Cannot Bill Yourself', 'error')
            end
        else
            TriggerClientEvent('QBCore:Notify', source, 'Player Not Online', 'error')
        end
    else
        TriggerClientEvent('QBCore:Notify', source, 'No Access', 'error')
    end
end)