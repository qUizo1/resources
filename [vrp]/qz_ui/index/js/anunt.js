function showAdminAnnouncement(title, message, duration) {
    const announcement = $('#anuntc');
    
    announcement.find('.tit').text(title);
    announcement.find('.txt').text(message);
    
    announcement.removeClass('show');
    announcement.find('.ant-progress').css('transition', 'none').css('transform', 'scaleY(1)');

    try {
        const sound = new Audio('sounds/anunt.mp3');
        sound.volume = 0.3;
        sound.play();
    } catch(e) {
        console.error("Eroare sunet anunt:", e);
    }
    

    setTimeout(() => {
        announcement.addClass('show');
        

        setTimeout(() => {
            announcement.find('.ant-progress')
                .css('transition', `transform ${duration}ms linear`)
                .css('transform', 'scaleY(0)');
        }, 50);
        

        setTimeout(() => {
            announcement.removeClass('show');
        }, duration);
    }, 50);
}

$(document).ready(function() {

    window.addEventListener('message', function(event) {

    if (event.data.type === 'admin_announcement') {
        showAdminAnnouncement(
            event.data.title || "ADMIN ANNOUNCEMENT",
            event.data.message,
            event.data.duration || 10000
        );
    }
    });

});