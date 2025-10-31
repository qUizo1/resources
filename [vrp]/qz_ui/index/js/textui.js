$(document).ready(function() {
    window.addEventListener('message', function(event) {
        if (event.data.action == 'ShowTextUI') {
            $("#TextUiContainer").fadeIn(400);
            $( ".TextUiText" ).text( "" + event.data.message + "" );
        }
        if (event.data.action == 'HideTextUI') {
            $("#TextUiContainer").fadeOut(400);
        }
    });
});