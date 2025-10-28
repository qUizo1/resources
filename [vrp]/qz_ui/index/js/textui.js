window.addEventListener('message', function(event) {
    if (event.data.action == 'ShowTextUI') {
		$("#tTextUiContainer").fadeIn(400);
		$( ".TextUiText" ).text( "" + event.data.message + "" );
    }
    if (event.data.action == 'HideTextUI') {

		$("#tTextUiContainer").fadeOut(400);
	}
});