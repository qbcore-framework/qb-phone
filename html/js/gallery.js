//By JericoFX
let CurrentPhoto = null
let CitizenPhoto = null
function SetupGallery(Data) {
if (clean == '') clean = 'Hmm, I shouldn\'t be able to do this...'
	$(".menuheader").html("")
		let citizenid = QB.Phone.Data.PlayerData.citizenid
	  for(var i in Data){
			var clean = DOMPurify.sanitize(Data[i].url, {
				ALLOWED_TAGS: [],
				ALLOWED_ATTR: []
		});
			if (Data[i] !== null || Data[i] !== undefined ){
				if(Data[i].citizenid === citizenid){
					$(".menuheader").prepend('<div class="galleryapp" data-jerico="'+ Data[i].citizenid +'"> <img class="wppimage1" src='+ clean +'> </div>')
				}
			}
			
		}
	}

	$(document).on('click', '.galleryapp', function(e){
    e.preventDefault();
    let src = $('img', $(this)).attr('src');
		let citizenid = $(this).data('jerico')
		CurrentPhoto = src
		CitizenPhoto = citizenid
		QB.Phone.Animations.TopSlideDown(".background-custom1", 200, 13);
});
$("#accept-custom-background1").on('click', function (e) {
	QB.Phone.Animations.TopSlideUp(".background-custom1", 200, -23);
	QB.Screen.popUp(CurrentPhoto)
});
$('.closeback1').on('click', function (e) {
	e.preventDefault();
	QB.Phone.Animations.TopSlideUp(".background-custom1", 200, -23);
})
$('#cancel-custom-background1').on('click', function (e) {
	e.preventDefault();
	QB.Phone.Animations.TopSlideUp(".background-custom1", 200, -23);
})
$('#delete-custom-background1').on('click', function (e) {
	e.preventDefault();
	$.post("https://qb-phone/DeletePicture",JSON.stringify({url:CurrentPhoto, citizenid:CitizenPhoto}))

	window.addEventListener('message', function(event) {
		event.preventDefault();
			if(event.data.data == "Pictures"){
				SetupGallery(event.data.Photos)
			}
	})
	QB.Phone.Animations.TopSlideUp(".background-custom1", 200, -23);
})