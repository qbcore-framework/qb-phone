var CurrentTwitterTab = "twitter-home"
var HashtagOpen = false;
var MinimumTrending = 100;

$(document).on('click', '.twitter-header-tab', function(e){
    e.preventDefault();

    var PressedTwitterTab = $(this).data('twittertab');
    var PreviousTwitterTabObject = $('.twitter-header').find('[data-twittertab="'+CurrentTwitterTab+'"]');

    if (PressedTwitterTab !== CurrentTwitterTab) {
        $(this).addClass('selected-twitter-header-tab');
        $(PreviousTwitterTabObject).removeClass('selected-twitter-header-tab');

        $("."+CurrentTwitterTab+"-tab").css({"display":"none"});
        $("."+PressedTwitterTab+"-tab").css({"display":"block"});

        if (PressedTwitterTab === "twitter-mentions") {
            $.post('https://qb-phone/ClearMentions');
        }

        if (PressedTwitterTab == "twitter-home") {
            $.post('https://qb-phone/GetTweets', JSON.stringify({}), function(Tweets){
                QB.Phone.Notifications.LoadTweets(Tweets);
            });
        }

        CurrentTwitterTab = PressedTwitterTab;

        if (HashtagOpen) {
            event.preventDefault();

            $(".twitter-hashtag-tweets").css({"left": "30vh"});
            $(".twitter-hashtags").css({"left": "0vh"});
            $(".twitter-new-tweet").css({"display":"block"});
            $(".twitter-hashtags").css({"display":"block"});
            HashtagOpen = false;
        }
    } else if (CurrentTwitterTab == "twitter-hashtags" && PressedTwitterTab == "twitter-hashtags") {
        if (HashtagOpen) {
            event.preventDefault();

            $(".twitter-hashtags").css({"display":"block"});
            $(".twitter-hashtag-tweets").animate({
                left: 30+"vh"
            }, 150);
            $(".twitter-hashtags").animate({
                left: 0+"vh"
            }, 150);
            HashtagOpen = false;
        }
    } else if (CurrentTwitterTab == "twitter-home" && PressedTwitterTab == "twitter-home") {
        event.preventDefault();

        $.post('https://qb-phone/GetTweets', JSON.stringify({}), function(Tweets){
            QB.Phone.Notifications.LoadTweets(Tweets);
        });
    } else if (CurrentTwitterTab == "twitter-mentions" && PressedTwitterTab == "twitter-mentions") {
        event.preventDefault();

        $.post('https://qb-phone/GetMentionedTweets', JSON.stringify({}), function(MentionedTweets){
            QB.Phone.Notifications.LoadMentionedTweets(MentionedTweets)
        })
    }
});

$(document).on('click', '.twitter-new-tweet', function(e){
    e.preventDefault();

    QB.Phone.Animations.TopSlideDown(".twitter-new-tweet-tab", 450, 0);
});

QB.Phone.Notifications.LoadTweets = function(Tweets) {
    Tweets = Tweets.reverse();
    if (Tweets !== null && Tweets !== undefined && Tweets !== "" && Tweets.length > 0) {
        $(".twitter-home-tab").html("");
        $.each(Tweets, function(i, Tweet){
            var clean = DOMPurify.sanitize(Tweet.message , {
                ALLOWED_TAGS: [], 
                ALLOWED_ATTR: []
            });
            if (clean == '') clean = 'Hmm, I shouldn\'t be able to do this...'
            var TwtMessage = QB.Phone.Functions.FormatTwitterMessage(clean);
            var today = new Date();
            var TweetTime = new Date(Tweet.time);
            var diffMs = (today - TweetTime);
            var diffDays = Math.floor(diffMs / 86400000);
            var diffHrs = Math.floor((diffMs % 86400000) / 3600000);
            var diffMins = Math.round(((diffMs % 86400000) % 3600000) / 60000);
            var diffSeconds = Math.round(diffMs / 1000);
            var TimeAgo = diffSeconds + ' s';

            if (diffMins > 0) {
                TimeAgo = diffMins + ' m';
            } else if (diffHrs > 0) {
                TimeAgo = diffHrs + ' h';
            } else if (diffDays > 0) {
                TimeAgo = diffDays + ' d';
            }

            var TwitterHandle = Tweet.firstName + ' ' + Tweet.lastName
            var PictureUrl = "./img/default.png"
            if (Tweet.picture !== "default") {
                PictureUrl = Tweet.picture
            }
            
            var TweetElement = '<div class="twitter-tweet" data-twthandler="@'+TwitterHandle.replace(" ", "_")+'"><div class="tweet-reply"><i class="fas fa-reply"></i></div>'+
                '<div class="tweet-tweeter">'+Tweet.firstName+' '+Tweet.lastName+' &nbsp;<span>@'+TwitterHandle.replace(" ", "_")+' &middot; '+TimeAgo+'</span></div>'+
                '<div class="tweet-message">'+TwtMessage+'</div>'+
                '<div class="twt-img" style="top: 1vh;"><img src="'+PictureUrl+'" class="tweeter-image"></div>' +
            '</div>';


            $(".twitter-home-tab").append(TweetElement);
        });
    }
}

$(document).on('click', '.tweet-reply', function(e){
    e.preventDefault();
    var TwtName = $(this).parent().data('twthandler');

    $("#tweet-new-message").val(TwtName + " ");
    QB.Phone.Animations.TopSlideDown(".twitter-new-tweet-tab", 450, 0);
});

QB.Phone.Notifications.LoadMentionedTweets = function(Tweets) {
    Tweets = Tweets.reverse();
    if (Tweets.length > 0) {
        $(".twitter-mentions-tab").html("");
        $.each(Tweets, function(i, Tweet){
            var clean = DOMPurify.sanitize(Tweet.message , {
                ALLOWED_TAGS: [], 
                ALLOWED_ATTR: []
            });
            if (clean == '') clean = 'Hmm, I shouldn\'t be able to do this...'
            var TwtMessage = QB.Phone.Functions.FormatTwitterMessage(clean);
            var today = new Date();
            var TweetTime = new Date(Tweet.time);
            var diffMs = (today - TweetTime);
            var diffDays = Math.floor(diffMs / 86400000);
            var diffHrs = Math.floor((diffMs % 86400000) / 3600000);
            var diffMins = Math.round(((diffMs % 86400000) % 3600000) / 60000);
            var diffSeconds = Math.round(diffMs / 1000);
            var TimeAgo = diffSeconds + ' s';

            if (diffSeconds > 60) {
                TimeAgo = diffMins + ' m';
            } else if (diffMins > 60) {
                TimeAgo = diffHrs + ' h';
            } else if (diffHrs > 24) {
                TimeAgo = diffDays + ' d';
            }
    
            var TwitterHandle = Tweet.firstName + ' ' + Tweet.lastName
            var PictureUrl = "./img/default.png";
            if (Tweet.picture !== "default") {
                PictureUrl = Tweet.picture
            }
    
            var TweetElement = 
            '<div class="twitter-tweet">'+
                '<div class="tweet-tweeter">'+Tweet.firstName+' '+Tweet.lastName+' &nbsp;<span>@'+TwitterHandle.replace(" ", "_")+' &middot; '+TimeAgo+'</span></div>'+
                '<div class="tweet-message">'+TwtMessage+'</div>'+
            '<div class="twt-img" style="top: 1vh;"><img src="'+PictureUrl+'" class="tweeter-image"></div></div>';

            $(".twitter-mentioned-tweet").css({"background-color":"#F5F8FA"});
            $(".twitter-mentions-tab").append(TweetElement);
        });
    }
}

QB.Phone.Functions.FormatTwitterMessage = function(TwitterMessage) {
    var TwtMessage = TwitterMessage;
    var res = TwtMessage.split("@");
    var tags = TwtMessage.split("#");
    var InvalidSymbols = [
        "[",
        "?",
        "!",
        "@",
        "#",
        "]",
    ]

    for(i = 1; i < res.length; i++) {
        var MentionTag = res[i].split(" ")[0];
        if (MentionTag !== null && MentionTag !== undefined && MentionTag !== "") {
            TwtMessage = TwtMessage.replace("@"+MentionTag, "<span class='mentioned-tag' data-mentiontag='@"+MentionTag+"' style='color: rgb(27, 149, 224);'>@"+MentionTag+"</span>");
        }
    }

    for(i = 1; i < tags.length; i++) {
        var Hashtag = tags[i].split(" ")[0];

        for(i = 1; i < InvalidSymbols.length; i++){
            var symbol = InvalidSymbols[i];
            var res = Hashtag.indexOf(symbol);

            if (res > -1) {
                Hashtag = Hashtag.replace(symbol, "");
            }
        }

        if (Hashtag !== null && Hashtag !== undefined && Hashtag !== "") {
            TwtMessage = TwtMessage.replace("#"+Hashtag, "<span class='hashtag-tag-text' data-hashtag='"+Hashtag+"' style='color: rgb(27, 149, 224);'>#"+Hashtag+"</span>");
        }
    }

    return TwtMessage
}

$(document).on('click', '#send-tweet', function(e){
    e.preventDefault();

    var TweetMessage = $("#tweet-new-message").val();

    if (TweetMessage != "") {
        var CurrentDate = new Date();
        $.post('https://qb-phone/PostNewTweet', JSON.stringify({
            Message: TweetMessage,
            Date: CurrentDate,
            Picture: QB.Phone.Data.MetaData.profilepicture
        }), function(Tweets){
            QB.Phone.Notifications.LoadTweets(Tweets);
        });
        $.post('https://qb-phone/GetHashtags', JSON.stringify({}), function(Hashtags){
            QB.Phone.Notifications.LoadHashtags(Hashtags)
        })
        QB.Phone.Animations.TopSlideUp(".twitter-new-tweet-tab", 450, -120);
    } else {
        QB.Phone.Notifications.Add("fab fa-twitter", "Twitter", "Fill a message!", "#1DA1F2");
    }
});

$(document).on('click', '#cancel-tweet', function(e){
    e.preventDefault();

    QB.Phone.Animations.TopSlideUp(".twitter-new-tweet-tab", 450, -120);
});

$(document).on('click', '.mentioned-tag', function(e){
    e.preventDefault();
    CopyMentionTag(this);
});

$(document).on('click', '.hashtag-tag-text', function(e){
    e.preventDefault();
    if (!HashtagOpen) {
        var Hashtag = $(this).data('hashtag');
        var PreviousTwitterTabObject = $('.twitter-header').find('[data-twittertab="'+CurrentTwitterTab+'"]');
    
        $("#twitter-hashtags").addClass('selected-twitter-header-tab');
        $(PreviousTwitterTabObject).removeClass('selected-twitter-header-tab');
    
        $("."+CurrentTwitterTab+"-tab").css({"display":"none"});
        $(".twitter-hashtags-tab").css({"display":"block"});
    
        $.post('https://qb-phone/GetHashtagMessages', JSON.stringify({hashtag: Hashtag}), function(HashtagData){
            QB.Phone.Notifications.LoadHashtagMessages(HashtagData.messages);
        });
    
        $(".twitter-hashtag-tweets").css({"display":"block", "left":"30vh"});
        $(".twitter-hashtag-tweets").css({"left": "0vh"});
        $(".twitter-hashtags").css({"left": "-30vh"});
        $(".twitter-hashtags").css({"display":"none"});
        HashtagOpen = true;
    
        CurrentTwitterTab = "twitter-hashtags";
    }
});

function CopyMentionTag(elem) {
    var $temp = $("<input>");
    $("body").append($temp);
    $temp.val($(elem).data('mentiontag')).select();
    QB.Phone.Notifications.Add("fab fa-twitter", "Twitter", $(elem).data('mentiontag')+ " copied!", "rgb(27, 149, 224)", 1250);
    document.execCommand("copy");
    $temp.remove();
}

QB.Phone.Notifications.LoadHashtags = function(hashtags) {
    if (hashtags !== null) {
        $(".twitter-hashtags").html("");
        console.log(JSON.stringify(hashtags));
        $.each(hashtags, function(i, hashtag){
            var Elem = '';
            var TweetHandle = "Tweet";
            if (hashtag.messages.length > 1 ) {
               TweetHandle = "Tweets";
            }
            if (hashtag.messages.length >= MinimumTrending) {
                Elem = '<div class="twitter-hashtag" id="tag-'+hashtag.hashtag+'"><div class="twitter-hashtag-status">Trending in City</div> <div class="twitter-hashtag-tag">#'+hashtag.hashtag+'</div> <div class="twitter-hashtag-messages">'+hashtag.messages.length+' '+TweetHandle+'</div> </div>';
            } else {
                Elem = '<div class="twitter-hashtag" id="tag-'+hashtag.hashtag+'"><div class="twitter-hashtag-status">Not trending in City</div> <div class="twitter-hashtag-tag">#'+hashtag.hashtag+'</div> <div class="twitter-hashtag-messages">'+hashtag.messages.length+' '+TweetHandle+'</div> </div>';
            }
        
            $(".twitter-hashtags").append(Elem);
            $("#tag-"+hashtag.hashtag).data('tagData', hashtag);
        });
    }
}

QB.Phone.Notifications.LoadHashtagMessages = function(Tweets) {
    Tweets = Tweets.reverse();
    if (Tweets !== null && Tweets !== undefined && Tweets !== "" && Tweets.length > 0) {
        $(".twitter-hashtag-tweets").html("");
        $.each(Tweets, function(i, Tweet){
            var clean = DOMPurify.sanitize(Tweet.message , {
                ALLOWED_TAGS: [], 
                ALLOWED_ATTR: []
            });
            if (clean == '') clean = 'Hmm, I shouldn\'t be able to do this...'
            var TwtMessage = QB.Phone.Functions.FormatTwitterMessage(clean);
            var today = new Date();
            var TweetTime = new Date(Tweet.time);
            var diffMs = (today - TweetTime);
            var diffDays = Math.floor(diffMs / 86400000);
            var diffHrs = Math.floor((diffMs % 86400000) / 3600000);
            var diffMins = Math.round(((diffMs % 86400000) % 3600000) / 60000);
            var diffSeconds = Math.round(diffMs / 1000);
            var TimeAgo = diffSeconds + ' s';

            if (diffSeconds > 60) {
                TimeAgo = diffMins + ' m';
            } else if (diffMins > 60) {
                TimeAgo = diffHrs + ' h';
            } else if (diffHrs > 24) {
                TimeAgo = diffDays + ' d';
            }

            var TwitterHandle = Tweet.firstName + ' ' + Tweet.lastName
            var PictureUrl = "./img/default.png"
            if (Tweet.picture !== "default") {
                PictureUrl = Tweet.picture
            }
    
            var TweetElement = 
            '<div class="twitter-tweet">'+
                '<div class="tweet-tweeter">'+Tweet.firstName+' '+Tweet.lastName+' &nbsp;<span>@'+TwitterHandle.replace(" ", "_")+' &middot; '+TimeAgo+'</span></div>'+
                '<div class="tweet-message">'+TwtMessage+'</div>'+
            '<div class="twt-img" style="top: 1vh;"><img src="'+PictureUrl+'" class="tweeter-image"></div></div>';
                    
            $(".twitter-hashtag-tweets").append(TweetElement);
        });
    }
}


$(document).on('click', '.twitter-hashtag', function(event){
    event.preventDefault();

    var TweetId = $(this).attr('id');
    var TweetData = $("#"+TweetId).data('tagData');

    QB.Phone.Notifications.LoadHashtagMessages(TweetData.messages);

    $(".twitter-hashtag-tweets").css({"display":"block", "left":"30vh"});
    $(".twitter-hashtag-tweets").animate({
        left: 0+"vh"
    }, 150);
    $(".twitter-hashtags").animate({
        left: -30+"vh"
    }, 150, function(){
        $(".twitter-hashtags").css({"display":"none"});
    });
    HashtagOpen = true;
});
