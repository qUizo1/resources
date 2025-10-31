let currentLocation = null;

function updateLocationUI(area, street) {
    if (!currentLocation) {
        currentLocation = $('#location-ui .location-container');
    }
    
    currentLocation.find('.location-area').text(area || "Unknown Area");
    currentLocation.find('.location-street').text(street || "Unknown Street");
}



$(document).ready(function() {

    window.addEventListener('message', function(event) {

    if (event.data.type === 'update_location') {
        updateLocationUI(event.data.area, event.data.street);
    }
    });

    $.post(`https://${GetParentResourceName()}/request_location_update`, JSON.stringify({}));

    setInterval(() => {
        $.post(`https://${GetParentResourceName()}/request_location_update`, JSON.stringify({}));
    }, 2000);
});