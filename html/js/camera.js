function SetupCamera(){
   $.post('https://qb-phone/GetImage',JSON.stringify({}),function(url){
    if(url){
      $.post('https://qb-phone/GetUrlData',JSON.stringify({citizenid:QB.Phone.Data.PlayerData.citizenid,
      url:url}),function(){
        $.post('https://qb-phone/GetPhotos',JSON.stringify({}),function(edata){
          if (edata){
            SetupGallery(edata)
          }
        })
      })
    }
  })
  QB.Phone.Functions.Close();
}