function updateHUD(data) {
    updateHUDItem('health', data.health);
    updateHUDItem('armor', data.armor);
    updateHUDItem('hunger', data.hunger);
    updateHUDItem('thirst', data.thirst);
    updateHUDItem('stamina', data.stamina);
}

function updateHUDItem(type, value) {
    const percent = Math.max(0, Math.min(100, Math.floor(value)));
    const bar = $(`#${type}-bar`);
    const percentElement = $(`#${type}-percent`);
    const item = $(`#${type}-item`);
    
    
    bar.css('width', percent + '%');
    percentElement.text(percent + '%');
    item.attr('data-value', percent);
    
    if (type === 'armor') {
        if (percent < 1) {
            item.hide();
        } else {
            item.show();
        }
    }
}

function updateHUDPosition(inVehicle) {
    const hudContainer = document.getElementById('hud-container');
    if (inVehicle) {
        hudContainer.classList.add('in-vehicle');
    } else {
        hudContainer.classList.remove('in-vehicle');
    }
}

$(document).ready(function() {

    window.addEventListener('message', function(event) {

    if (event.data.type === 'hud_update') {
        updateHUD(event.data);
    }
    });

    $.post('https://' + GetParentResourceName() + '/get_hud_data', JSON.stringify({}));
});
