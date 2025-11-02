window.addEventListener('message', function(e) {
    const data = e.data;

    if (data.action === 'bankingUI') {
        $('#banking-ui').fadeIn(600);
        $('.balance-amount').text("$" + (data.balance || "0"));
        $('.name').text(data.name || "Neidentificat");
    }
});

function withdraw(amount) {
    $('.bankingContainer2').fadeOut();
    $('.bankingContainer2').hide();
    $.post(`https://${GetParentResourceName()}/bank`, JSON.stringify({
        type: 'withdraw',
        amount: amount
    }));
    updateInfo();
}

function deposit(amount) {
    $('.bankingContainer2').fadeOut();
    $('.bankingContainer2').hide();
    $.post(`https://${GetParentResourceName()}/bank`, JSON.stringify({
        type: 'deposit',
        amount: amount
    }));
    updateInfo();
}

const titles = {
    withdraw: {
        title: 'Withdraw',
        desc: 'Enter the amount you want to withdraw.'
    },
    deposit: {
        title: 'Deposit',
        desc: 'Enter the amount you want to deposit.'
    },
    transfer: {
        title: 'Transfer',
        desc: 'Enter the amount you want to transfer.'
    }
}

let actMenu = null;

function closeSecondMenu() {
    actMenu = null;
    $("#iban").hide();
    $('.bankingContainer2').fadeOut();
    $('.bankingContainer2').hide();
    $('#banking-ui').show();
}

function cont() {
    $.post(`https://${GetParentResourceName()}/bank`, JSON.stringify({
        type: actMenu,
        amount: $("#amt").val(),
        id: $("#iban").val()
    }));
    closeSecondMenu();
    actMenu = null;
    $("#iban").hide();
    updateInfo();
    $('#banking-ui').show();
}

function closeMenu() {
    $.post(`https://${GetParentResourceName()}/close`);
    $('#banking-ui').fadeOut(600);
    $('.bankingContainer2').fadeOut(600);
    $('.bankingContainer2').hide();
}

function updateInfo() {
    $.post(`https://${GetParentResourceName()}/getBalance`, "{}", function(balance) {
        if (balance) {
            $(".balance-amount").text("$" + balance);
        }
    });
}

function openReq(req) {
    actMenu = req;
    $('#banking-ui').hide();
    if (req == 'transfer') {
        $("#iban").show()
    }
    $("#title").text(titles[req].title)
    $("#desc").text(titles[req].desc)
    $('.bankingContainer2').fadeIn();
    $('.bankingContainer2').show();
}


document.onkeyup = function(data) {
    if (data.which == 27) {
        closeMenu();
    }
};