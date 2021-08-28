var SelectedTruckerTab = "trucker-general-tab";
var IsWorking = false;

SetupTruckerInfo = function(data) {
    SelectedTruckerTab = "trucker-general-tab";
    var DivideAmount = (100 / QB.Phone.Data.Tiers[data.jobtier])
    var ProgressPercentage = data.jobrep * DivideAmount;

    $("#trucker-name").html(QB.Phone.Data.PlayerData.charinfo.firstname + " " + QB.Phone.Data.PlayerData.charinfo.lastname);
    $("#trucker-header-progress-current").html("Current: " + data.jobrep + " REP");
    $("#trucker-header-tier").html("Tier " + data.jobtier);
    if (data.jobrep == QB.Phone.Data.Tiers[data.jobtier]) {
        $("#trucker-header-progress-next").html("Next: MAX");
    } else {
        $("#trucker-header-progress-next").html("Next: " + (QB.Phone.Data.Tiers[data.jobtier] - data.jobrep) + " REP");
    }
    $(".trucker-header-progress-fill").css("width", ProgressPercentage + "%");

    $.post('http://qb-phone/IsWorkingAsTrucker', JSON.stringify({}), function(data){
        $("#trucker-general-tab").removeClass("trucker-jobinfo-tab-selected");
        $("#trucker-work-tab").removeClass("trucker-jobinfo-tab-selected");
    
        $(".trucker-general-tab").css("display", "none");
        $(".trucker-work-tab").css("display", "none");
    
        $("#"+SelectedTruckerTab).addClass("trucker-jobinfo-tab-selected");
        $("."+SelectedTruckerTab).css("display", "block");

        $("#outstandingamount").html("&dollar;"+data.JobInfo.payslips || 0);
        $("#outstandingamount").data('amount', data.JobInfo.payslips || 0);

        if (data.Working) {
            IsWorking = true;
            $(".trucker-work-tab-locations").html("");
            $.each(data.JobInfo.Locations, function(i, location){
                var LocationId = (i + 1);
                if(Object.values(data.JobInfo.WorkingLocations).includes(LocationId)) return;
                var IconId = "fas fa-times-circle";
                var Info = '';
                var checkColor = "color: red;";
                if (Object.values(data.JobInfo.LocationsDone).includes(LocationId)) {
                    IconId = "fas fa-check-circle";
                    checkColor = "color: green;";
                    Info = '<div class="trucker-work-tab-location-count">' + LocationId + '</div> <div class="trucker-work-tab-location-title">'+location.name+'</div> <div class="trucker-work-tab-location-done">Done</div>' ;
                } else {
                    Info = '<div class="trucker-work-tab-location-count">' + LocationId + '</div> <div class="trucker-work-tab-location-title">'+location.name+'</div> <div class="trucker-work-tab-location-gps">GPS</div>' ;
                }
                var elem = '<div class="trucker-work-tab-location" id="trucker-work-tab-location-' + LocationId + '">'+Info+' <i class="'+IconId+' trucker-work-tab-location-jobdoneicon" style="'+checkColor+'"></i> </div>';
                $(".trucker-work-tab-locations").append(elem);
                $("#trucker-work-tab-location-"+LocationId).data('LocationId', LocationId);
                $("#trucker-work-tab-location-"+LocationId).data('LocationData', location);
            });
        } else {
            IsWorking = false;
        }
    });
}

UpdateLocations = function(JobInfo, onlyShow){
    $(".trucker-work-tab-locations").html("");
    if(onlyShow){
        var i = LocationId - 1
        var LocationId = onlyShow;
        var location = JobInfo.Locations[LocationId];
        var IconId = "fas fa-times-circle";
        var Info = '';
        var checkColor = "color: red;";
        if (Object.values(JobInfo.LocationsDone).includes(LocationId)) {
            IconId = "fas fa-check-circle";
            checkColor = "color: green;";
            Info = '<div class="trucker-work-tab-location-count">' + LocationId + '</div> <div class="trucker-work-tab-location-title">'+location.name+'</div> <div class="trucker-work-tab-location-done">Done</div>' ;
        } else {
            Info = '<div class="trucker-work-tab-location-count">' + LocationId + '</div> <div class="trucker-work-tab-location-title">'+location.name+'</div> <div class="trucker-work-tab-location-gps">GPS</div>' ;
        }
        var elem = '<div class="trucker-work-tab-location" id="trucker-work-tab-location-' + LocationId + '">'+Info+' <i class="'+IconId+' trucker-work-tab-location-jobdoneicon" style="'+checkColor+'"></i> </div>';
        $(".trucker-work-tab-locations").append(elem);
        $("#trucker-work-tab-location-"+LocationId).data('LocationId', LocationId);
        $("#trucker-work-tab-location-"+LocationId).data('LocationData', location);

    } else {
        $.each(JobInfo.Locations, function(i, location){
        var LocationId = (i + 1);
        if(Object.values(JobInfo.WorkingLocations).includes(LocationId)) return;
        var IconId = "fas fa-times-circle";
        var Info = '';
        var checkColor = "color: red;";
        if (Object.values(JobInfo.LocationsDone).includes(LocationId)) {
            IconId = "fas fa-check-circle";
            checkColor = "color: green;";
            Info = '<div class="trucker-work-tab-location-count">' + LocationId + '</div> <div class="trucker-work-tab-location-title">'+location.name+'</div> <div class="trucker-work-tab-location-done">Done</div>' ;
        } else {
            Info = '<div class="trucker-work-tab-location-count">' + LocationId + '</div> <div class="trucker-work-tab-location-title">'+location.name+'</div> <div class="trucker-work-tab-location-gps">GPS</div>' ;
        }
        var elem = '<div class="trucker-work-tab-location" id="trucker-work-tab-location-' + LocationId + '">'+Info+' <i class="'+IconId+' trucker-work-tab-location-jobdoneicon" style="'+checkColor+'"></i> </div>';
        $(".trucker-work-tab-locations").append(elem);
        $("#trucker-work-tab-location-"+LocationId).data('LocationId', LocationId);
        $("#trucker-work-tab-location-"+LocationId).data('LocationData', location);
    });
    }
   
}
$(document).on('click', '.trucker-work-tab-canceljob', function(e){
    e.preventDefault();

    $.post('http://qb-phone/CancelTruckerJob', JSON.stringify({}), function(data){
        $("#"+SelectedTruckerTab).removeClass("trucker-jobinfo-tab-selected");
        $("."+SelectedTruckerTab).css("display", "none");

        SelectedTruckerTab = "trucker-general-tab";
    
        $("#"+SelectedTruckerTab).addClass("trucker-jobinfo-tab-selected");
        $("."+SelectedTruckerTab).css("display", "block");

        IsWorking = false;
    });
});

$(document).on('click', '.trucker-work-tab-location-gps', function(e){
    e.preventDefault();
    
    var LocationId = $(this).parent().data('LocationId');

    $.post('http://qb-phone/SetTruckerRoute', JSON.stringify({
        location: LocationId
    }))
});

$(document).on('click', '.trucker-jobinfo-tab', function(e){
    e.preventDefault();

    var NewTab = $(this).attr('id');

    if (NewTab == "trucker-work-tab") {
        if (!IsWorking) {
            QB.Phone.Notifications.Add("fas fa-truck-moving", "Dumbo", "You are not currently working", "#cccc33", 3500);
            return;
        }
    }

    $("#"+SelectedTruckerTab).removeClass("trucker-jobinfo-tab-selected");
    $("."+SelectedTruckerTab).css("display", "none");
    
    SelectedTruckerTab = $(this).attr('id');
    $("#"+SelectedTruckerTab).addClass("trucker-jobinfo-tab-selected");
    $("."+SelectedTruckerTab).css("display", "block");
});

$(document).on('click', '.trucker-general-tab-payslip-outstandingamount-payout', function(e){
    e.preventDefault();

    var amount = $("#outstandingamount").data('amount');

    if (amount > 0) {
        $.post('http://qb-phone/PayoutPayslip');
    } else {
        QB.Phone.Notifications.Add("fas fa-truck-moving", "Dumbo", "You have &dollar;0,- on your payslip!", "#cccc33", 2500);
    }
});
