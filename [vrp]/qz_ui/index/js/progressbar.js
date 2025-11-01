let currentProgressTimer = null;

function showProgress(title, duration) {
    const progressContainer = $('#progress-container');
    const progressTitle = progressContainer.find('.progress-title');
    const progressBarFill = progressContainer.find('.progress-bar-fill');

    if (currentProgressTimer) {
        clearTimeout(currentProgressTimer);
    }

    progressBarFill.css('transition', 'none');
    progressBarFill.css('width', '0%');
    progressTitle.text(title);
    progressContainer.removeClass('hidden');

    setTimeout(() => {
        progressBarFill.css('transition', `width ${duration}ms linear`);
        progressBarFill.css('width', '100%');
    }, 50);

    currentProgressTimer = setTimeout(() => {
        progressContainer.addClass('hidden');
        setTimeout(() => {
            progressBarFill.css('transition', 'none');
            progressBarFill.css('width', '0%');
        }, 300);
    }, duration);
}
$(document).ready(function() {
    window.addEventListener('message', function(event) {
        if (event.data.action === 'showProgress') {
            showProgress(event.data.title, event.data.duration);
        } else if (event.data.action === 'hideProgress') {
            const progressContainer = document.getElementById('progress-container');
            const progressBarFill = document.querySelector('.progress-bar-fill');
            progressContainer.classList.add('hidden');
            progressBarFill.style.transition = 'none';
            progressBarFill.style.width = '0%';
        }
    });
});