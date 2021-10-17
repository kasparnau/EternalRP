var cancelledTimer = null;

$('document').ready(function() {
    MythicProgBar = {};

    MythicProgBar.Progress = function(data) {
        clearTimeout(cancelledTimer);
        $("#progress-label").text(data.label);

        $(".progress-container").fadeIn(1)
        $("#progress-bar").stop().css({"width": 0, "background-color": "rgba(26, 34, 111, 0.45)"}).animate({
            width: '100%'
        }, {
            duration: parseInt(data.duration),
            complete: function() {
                $(".progress-container").fadeOut('fast')
                $('#progress-bar').removeClass('cancellable');
                $("#progress-bar").css("width", 0);
                $.post('http://progress/actionFinish', JSON.stringify({
                    })
                );
            }
        });
    };

    MythicProgBar.ProgressCancel = function() {
        $("#progress-label").text("CANCELLED");
        $("#progress-bar").stop().css( {"width": "100%", "background-color": "rgba(71, 0, 0, 0.8)"});
        $('#progress-bar').removeClass('cancellable');

        cancelledTimer = setTimeout(function () {
            $(".progress-container").fadeOut('fast', function() {
                $("#progress-bar").css("width", 0);
                $.post('http://progress/actionCancel', JSON.stringify({
                    })
                );
            });
        }, 10);
    };

    MythicProgBar.CloseUI = function() {
        $('.main-container').fadeOut('fast');
    };
    
    window.addEventListener('message', function(event) {
        switch(event.data.action) {
            case 'progress':
                MythicProgBar.Progress(event.data);
                break;
            case 'progress_cancel':
                MythicProgBar.ProgressCancel();
                break;
        }
    });
});