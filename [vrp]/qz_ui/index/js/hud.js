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

let currentSpeed = 0;
let isInVehicle = false;
let currentFuel = 100;

function updateSpeedometer(speed, inVehicle, fuel) {
    speed = Math.round(speed);
    
    if (inVehicle !== isInVehicle) {
        isInVehicle = inVehicle;
        $('#speedometer').toggleClass('visible', isInVehicle);
    }

    if (speed !== currentSpeed && isInVehicle) {
        currentSpeed = speed;
        $('.speed-value').text(speed);

        const filledBars = Math.min(15, Math.floor(speed / 10));
        

        $('.speed-bar').css({
            'height': '5px',
            'background-color': 'rgba(255, 255, 255, 0.1)'
        });
        

        $('.speed-bar').each(function(index) {
            if (index < filledBars) {
                const height = 5 + (index * 2.33);
                let color;
                if (index < 10) color = '#ffae00';     
                else if (index < 13) color = '#ff6a00'; 
                else color = '#ff5a5a';                 
                
                $(this).css({
                    'height': `${height}px`,
                    'background-color': color,
                    'box-shadow': `0 0 8px ${color}80`
                });
            }
        });
    }

if (fuel !== undefined && fuel !== currentFuel) {
    currentFuel = Math.max(0, Math.min(100, fuel));
    $('.fuel-bar').css('width', currentFuel + '%');

    if (currentFuel < 15) {
        $('.fuel-bar').css({
            'background-color': currentFuel < 5 ? '#ff0000' : '#ff3333',
            'box-shadow': '0 0 8px rgba(255, 51, 51, 0.6)'
        });
        $('.fuel-icon').css('color', '#ff3333');

        if (currentFuel < 5) {
            $('.fuel-section').addClass('fuel-container-critical');
        } else {
            $('.fuel-section').removeClass('fuel-container-critical');
        }
    } else {
        $('.fuel-bar').css({
            'background-color': '#ff8800',
            'box-shadow': '0 0 8px rgba(255, 136, 0, 0.6)'
        });
        $('.fuel-icon').css('color', '#ff8800');

        $('.fuel-bar').removeClass('fuel-warning');
        $('.fuel-section').removeClass('fuel-container-critical');
    }
}
}

$(document).ready(function() {

    window.addEventListener('message', function(event) {

        if (event.data.type === 'hud_update') {
            updateHUD(event.data);
        }

        if (event.data.type === 'update_speed') {
            updateSpeedometer(event.data.speed, event.data.inVehicle, event.data.fuel);
            updateHUDPosition(event.data.inVehicle);
        }

        if (event.data.type === 'update_vehicle_state') {
            updateHUDPosition(event.data.inVehicle);
        }
    });

    $.post('https://' + GetParentResourceName() + '/get_hud_data', JSON.stringify({}));
});
