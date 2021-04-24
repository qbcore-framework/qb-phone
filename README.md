# qb-phone
Advanced Phone for QB-Core Framework :iphone:

## Dependencies
- [qb-core](https://github.com/qbcore-framework/qb-core)
- [qb-policejob](https://github.com/qbcore-framework/qb-policejob) - MEOS, handcuff check etc. 
- [qb-crypto](https://github.com/qbcore-framework/qb-crypto) - Crypto currency trading 
- [qb-lapraces](https://github.com/qbcore-framework/qb-lapraces) - Creating routes and racing 
- [qb-houses](https://github.com/qbcore-framework/qb-houses) - House and key management 
- [qb-garages](https://github.com/qbcore-framework/qb-garages) - 
- [qb-banking](https://github.com/qbcore-framework/qb-banking) - For banking


## Screenshots
![Home](https://imgur.com/ceEIvEk.png)
![Bank](https://imgur.com/tArcik2.png)
![Whatsapp](https://imgur.com/C9aIinK.png)
![Phone](https://imgur.com/ic2zySK.png)
![Settings](https://imgur.com/jqC5Y8C.png)
![MEOS](https://imgur.com/VP7gQBf.png)
![Vehicles](https://imgur.com/NUTcfwr.png)
![Email](https://imgur.com/zTD33N1.png)
![Advertisements](https://imgur.com/QtQxJLz.png)
![Houses](https://imgur.com/n6ocF7b.png)
![App Store](https://imgur.com/mpBOgfN.png)
![Lawyers](https://imgur.com/SzIRpsI.png)
![Racing](https://imgur.com/cqj1JBP.png)
![Crypto](https://imgur.com/Mvv6IZ4.png)

## Features
- Garages app to see your vehicle details
- Mails to inform the player
- Banking app to see balance and transfer money
- Racing app to create races
- App Store to download apps
- MEOS app for polices to search
- Houses app for house details and management

## Installation
### Manual
- Download the script and put it in the `[qb]` directory.
- Import `qb-phone.sql` in your database
- Add the following code to your server.cfg/resouces.cfg
```
ensure qb-core
ensure qb-phone
ensure qb-policejob
ensure qb-crypto
ensure qb-lapraces
ensure qb-houses
ensure qb-garages
ensure qb-banking
```

## Configuration
```

Config = Config or {}

Config.RepeatTimeout = 2000 -- Timeout for unanswered call notification
Config.CallRepeats = 10 -- Repeats for unanswered call notification
Config.OpenPhone = 244 -- Key to open phone display
Config.PhoneApplications = {
    ["phone"] = { -- Needs to be unique
        app = "phone", -- App route
        color = "#04b543", -- App icon color
        icon = "fa fa-phone-alt", -- App icon
        tooltipText = "Phone", -- App name
        tooltipPos = "top",
        job = false, -- Job requirement
        blockedjobs = {}, -- Jobs cannot use this app
        slot = 1, -- App position
        Alerts = 0, -- Alert count
    },
}
```
