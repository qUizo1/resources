const notifications = [];
const NOTIFICATION_HEIGHT = 95;
const MAX_NOTIFICATIONS = 5;

function updatePositions() {
    notifications.forEach((notif, index) => {
        notif.element.style.top = `${index * NOTIFICATION_HEIGHT}px`;
    });
}

window.addEventListener('message', function(event) {

    if (event.data.action === 'open') {
        const duration = event.data.duration || 5000;
        const notificationId = Date.now();


        const notification = document.createElement('div');
        notification.className = 'nbody';
        notification.id = `notif-${notificationId}`;
        notification.innerHTML = `
            <div class="min-level"></div>
            <div class="titlu">${event.data.title}</div>
            <div class="text">${event.data.info}</div>
            <div class="duration-bar">
                <div class="duration-progress"></div>
            </div>
        `;

        document.getElementById('notifications-container').appendChild(notification);


        try {
            const sound = new Audio('sounds/notify.mp3');
            sound.volume = 0.7;
            const playPromise = sound.play();
            if (playPromise !== undefined) {
                playPromise.then(() => {
                }).catch(e => {
                    console.log("Sound play prevented by browser:", e);
                });
            }
        } catch(e) {
            console.error("Sound setup failed:", e);
        }


        notifications.unshift({
            id: notificationId,
            element: notification
        });

        updatePositions();

        setTimeout(() => {
            notification.classList.add('show');

            const progressBar = notification.querySelector('.duration-progress');
            progressBar.style.transitionDuration = `${duration}ms`;
            setTimeout(() => {
                progressBar.style.transform = 'scaleY(0)';
            }, 10);
        }, 10);

        if (notifications.length > MAX_NOTIFICATIONS) {
            const toRemove = notifications.pop();
            toRemove.element.remove();
            updatePositions();
        }

        setTimeout(() => {
            notification.classList.add('hide');

            setTimeout(() => {
                notification.remove();

                const index = notifications.findIndex(n => n.id === notificationId);
                if (index !== -1) {
                    notifications.splice(index, 1);
                    updatePositions();
                }
            }, 400);
        }, duration);
    }
});