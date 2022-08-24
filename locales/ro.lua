local Translations = {
    notify = {
        no_phone = "Nu ai un telefon... Se poate cumpara de la magazin",
        no_action = "Aceasta actiune nu este momentan disponibila..",
        track_vehicle = "Vehiculul tau a fost marcat pe GPS...",
        cant_track = "Nu pot localizat acest vehicul",
        gps_set_to = "Pozitia GPS setata pe: %{value}",
        race_to_far = "Esti prea departe de traseul cursei, GPS-ul a fost repozitionat",
        house_gps = "GPS a fost setat pe %{value} !",
        gps_was_set = "Coordonatele GPS au fost setate!",
        ping_id = "Trebuie sa introduci ID-ul unui cetatean",
        no_nearby = "Nu este nimeni langa tine!",
        no_veh_near = "Nu este niciun vehicul langa tine",
        failed_number = "Acest cont nu exista!",
        ping_yourself = "Nu-ti poti trimite singur ping!",
        invoice_sent = "Factura a fost trimisa cu succes",
        invoice_received = "Ai primit o factura noua!",
        amont_abovez = "Suma trebuie sa fie mai mare ca 0",
        cant_bill_yourself = "Nu-ti poti trimite singur o factura!",
        player_not_online = "Cetateanul nu este in stat!",
        no_access = "Nu ai acces",
    },
    inf_mapping = {
        phone = "Foloseste telefonul",
    },
    label = {
        nui_title = "Telefon",
        text_messg = "Apel telefonic terminat",
        no_call = "Nu te suna nimeni...",
        whatsup_msg = "Locatia a fost setata!",
        invalid_tweet = "Tweet invalid",
        del_contact = "Ai sters un contact",
        bank = "Banca",
        account_issue = "Contul nu exista!",
        shared_location = "Ai distribuit locatia",
        photo = "Poza",
        new_tweet = "Tweet nou (@%{value1} %{value2})",
        new_tweet_posted = "A fost postat un nou Tweet.",
        tweet_deteled = "Tweetul a fost sters!",
        racing_title = "Curse masini",
        mail_label = "Mail",
        mail_from = "Ai primit un mail de la %{value}",
        ad_label = "Reclame",
        ad_message = "O noua reclama a fost postat de %{value}",
        billing_label = "Sistem facturare",
        billing_title = "Achitare factura",
        billing_info = "A fost achitata factura pentru %{value1} in valoare de $%{value2}",
        bill_dep = "Facturi Neachitate",
        bill_dep_title = "Factura respinsa",
        bill_dep_message = "Factura anulata pentru %{value1} cu suma de $%{value2}",
        anon_caller = "Anonim",
        ws_message = "Mesaj primit de la %{value}!",
        ws_message_yourself = "Messaged yourself",
        bank_ammount = "Suma de $%{value} a fost retrasa din contul tau!",
        crypto_label = "Cripto Monede",
        new_contact = "Ai primit date noi de contact!",
        no_new_call = "Nu ai primit niciun apel...",
        tweet_mention = "Ai fost mentionat(a) intr-un Tweet!",
        commision_received = "Comision primit",
        comission_message = "Ai primit un comision de $%{value1} cand %{value2} %{value3} a platit o factura in valoare de $%{value4}.",
        bill_payed = "Factura achitata",
        bill_payed_message = "%{value1} %{value2} a platit o factura in valoare de $%{value3}",
        name_notfound = "Numele nu a fost gasit..",
        brand_unkanown = "Brand necunoscut..",
        set_metadata = "Setezi metadata pentru un jucator (God Only)",


    },
    command = {
        bill = {
            help = 'Trimite o factura unui cetatean',
            params = {
                id = { name = 'ID', help = 'ID-ul cetateanului' },
                amont = { name = 'Suma', help = 'Suma pe care se emite factura' },
            },
        },
    }

}
Lang = Locale:new({
    phrases = Translations,
    warnOnMissing = true
})
