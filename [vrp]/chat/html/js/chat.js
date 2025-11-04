
async function post(url, data = {}) {
    const response = await fetch(`https://${GetParentResourceName()}/${url}`, {
        method: 'POST',
        mode: 'no-cors',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify(data)
    });
  
    return await response.json();
  }
  
  const truncateText = (text, max) => {
    return text.substr(0,max-1)+(text.length>max?'...':''); 
  }
  
  
  const chat = {
    container: $('.chat-posts'),
    input: $(".chat-hud-input"),
    hiddenActions: $('.chat-actions-hidden'),
    fastActionsBtn: $("#main-action"),
  
    size: 0,
    direction: "upToDown", // upToDown, downToUp
    active: false,
    forcedToHide: false,
    timer: null,
    timerPush: null,
    oldMessages: [],
    oldMessagesIndex: -1,
  
    build(hideInput) {
        this.active = true;
        clearTimeout(this.timer);
        clearTimeout(this.timerPush);
  
        if (!this.forcedToHide) {
            $("#chat").animate({opacity: 1}, 500);
            $(".chat-posts").css("overflow",'overlay');
        }
  
        if (!hideInput) {
            this.showFooter();
            this.input.focus();
        } else {
            this.hideFooter();
        }
    },
  
    queueHide() {
      clearTimeout(this.timer);
      clearTimeout(this.timerPush);
        
        this.timerPush = setTimeout(function () {
            chat.hide();
            $(".chat-posts").css("overflow",'hidden');
        }, 10000);
    },
  
    escape(unsafe) {
        return String(unsafe)
                .replace(/&/g, '&amp;')
                .replace(/</g, '&lt;')
                .replace(/>/g, '&gt;')
                .replace(/"/g, '&quot;')
                .replace(/'/g, '&#039;')
                .replace(/\n/g, '\\n');
    },
  
    colorize(str) {
  
        str = this.escape(str);
  
  
        let s = "<strong>" + (str.replace(/\^([0-9a-z])/g, (str, color) => `</strong><strong class="color-${color}">`)) + "</strong>";
  
        // Detect HEX colors in the format "#{hex}"
        s = "<strong>" + (s.replace(/#\{(\w+)\}/g, (str, color) => `</strong><strong style="color:#${color};">`)) + "</strong>";
  
        // Detect RGB colors in the format "#rgb[r,g,b]"
        s = "<strong>" + (s.replace(/#rgb\[(\d+,\d+,\d+)\]/g, (str, color) => `</strong><strong style="color:rgb(${color});">`)) + "</strong>";
  
        const elementsDict = {
            '*': 'strong',
        };
    
        const emtsRegex = /\^(\_|\*|\=|\~|\/|r)(.*?)(?=$|\^r|<\/em>)/;
        while (s.match(emtsRegex)) {
            s = s.replace(emtsRegex, (str, foundEm, inner) => `<${elementsDict[foundEm]}>${inner}</${elementsDict[foundEm]}>`)
        }
  
        s = s.replace(/\\n/g, "<br>");
  
        s = s.replace(/<strong[^>]*><\/strong[^>]*>/g, '');
        
        return s;
    },
  
    moveOldMessageIndex(up) {
        if (up && this.oldMessages.length > this.oldMessagesIndex + 1) {
          this.oldMessagesIndex += 1;
          this.input.val(this.oldMessages[this.oldMessagesIndex])
        } else if (!up && this.oldMessagesIndex - 1 >= 0) {
          this.oldMessagesIndex -= 1;
          this.input.val(this.oldMessages[this.oldMessagesIndex])
        } else if (!up && this.oldMessagesIndex - 1 === -1) {
          this.oldMessagesIndex = -1;
          this.input.val("");
        }
    },
  
    clear() {
        this.container.find(".chat-post").remove();
        this.oldMessages = [];
        this.oldMessagesIndex = -1;
    },
  
    hideFooter() {
        $(".chat-hidden").hide();
    },
  
    showFooter() {
        $(".chat-hidden").show();
    },
  
    addMessage(msg, type = "msg") {
        if (!this.active) {
            this.build(true);
            this.queueHide();
        }
    
        if (type == "msg") {
            msg = this.colorize(msg);
    
            let now = new Date();
            let timeString = now.getHours().toString().padStart(2, '0') + ":" +
                             now.getMinutes().toString().padStart(2, '0') + ":" +
                             now.getSeconds().toString().padStart(2, '0');
    
            let staffRoles = {
                "Fondator": "fondator-box",
                "Administrator": "admin-box",
                "Jucator": "jucator-box"
            };
    
            Object.keys(staffRoles).forEach(role => {
                let regex = new RegExp(`(${role})`, "g");
                msg = msg.replace(regex, `<span class="staff-box ${staffRoles[role]}" style="font-family: 'grotesksemi'">$1</span>`);
            });
            
            msg = `<span style="font-family: 'groteskregular'">${msg}</span>`;
            
            msg = msg.replace(/([\w]+) \((\d+)\):/, 
                `<span class="name-box" style="font-family: 'groteskregular'">$1($2)</span>:`);
            
            this.container[this.direction == "upToDown" ? "append" : "prepend"](` 
                <div class="chat-post">
                    <span class="time-box" style="font-family: 'grotesksemi'">${timeString}</span>
                    <span class="msg-box">${msg}</span>
                </div>
            `);
        } else if (type == "info") {
            this.container[this.direction == "upToDown" ? "append" : "prepend"](` 
                <div class="chat-post smi-ad heart">
                    <i style="color: white; font-size: 20px;" class="fa-solid fa-megaphone"></i>
                    <div class="chat-smi-wrap">
                        <span>Electro</span>
                        <span>${msg}</span>
                    </div>
                </div>
            `);
        }
    
        this.container.animate({ scrollTop: this.container.prop("scrollHeight")}, 1000);
    },
    
  
    destroy() {
        this.active = false;
        this.hideFooter();
        clearTimeout(this.timer);
        clearTimeout(this.timerPush);
        
        this.timer = setTimeout(function () {
            chat.hide();
            $(".chat-posts").css("overflow",'hidden');
        }, 10000);
  
        post("setFocus", [false]);
    },
  
    hide() {
        this.active = false;
        $("#chat").animate({ opacity: 0}, 1000)
    },
  
    ready() {
        var $this = this;
  
        $this.input.on('keydown', function (e) {
            if (e.key === 'Enter' || e.keyCode === 13) {
                
                var message = $this.input.val();
    
                if (message.trim().length == 0)
                    return $this.destroy();
                
                $this.input.val("");
                $('#chat-me').prop('checked', true);
  
                post("chatResult", [message]);
  
                $this.oldMessages.unshift(message);
                $this.oldMessagesIndex = -1;
  
                $this.destroy();
  
            } else if (e.which === 38 || e.which === 40) {
                e.preventDefault();
                $this.moveOldMessageIndex(e.which === 38);
            }
        });
  
        // this.clear();
        this.hideFooter();
        this.destroy();
        this.hide();
    }
    
  }
  
  chat.ready();
  
  var minimumWidth = 1920;
  var minimumHeigh = 1080;
  window.onload = function(){
    changeSizeWidth();
    $(window).resize(changeSizeWidth);
  }
  function changeSizeWidth() 
  {
    
    var zoomCountOne = $(window).width() / minimumWidth;
    var zoomCountTwo = $(window).height() / minimumHeigh;
    
    if(zoomCountOne < zoomCountTwo) 
    {
        $('.main-chat-wrap').css('zoom', zoomCountOne);
    }
    else {
        $('.main-chat-wrap').css('zoom', zoomCountTwo);
    }
  }
  
  // $( "#main-action" ).click(function() {
  //     if($(".chat-actions-hidden" ).is(':visible')) {
  //         chat.hiddenActions.fadeOut();
  //         chat.fastActionsBtn.removeClass("opacity");
  //     }
  //     else 
  //     {
  //         chat.hiddenActions.fadeIn();
  //         chat.fastActionsBtn.addClass("opacity");
  //     }
  // });
  
  $(".chat-hud-action").on('click', 'input', function(event) {
    event.preventDefault();
  
    let autoTexts = {
        "chat-me": "/a "
    };
  
    var btn = $(this).val();
    if (!autoTexts[btn]) return;
  
    chat.input.val(autoTexts[btn]);
    chat.input.focus();
  });
  
  $("#chat-hud-action").on('click', function(event) {
    event.preventDefault();
    
    var e = $.Event('keydown');
    e.keyCode = 13;
    e.which = 13;
    $('.chat-hud-input').trigger(e);
  });
  
  window.addEventListener("keydown", function(event) {
    if (event.code == "Escape" && chat.active){
        chat.destroy();
        chat.input.val("");
    }
  })
  
  window.addEventListener("message", function(event) {
    event.preventDefault();
    const data = event.data;
  
    if (data.act == "build") {
        chat.build();
    } else if (data.act == "clear") {
        chat.clear();
    } else if (data.act == "onMessage") {
        chat.addMessage(data.msg, data.type);
    } else if (data.act == "onComponentDisplaySet") {
        chat.forcedToHide = !data.tog;
  
        if (chat.forcedToHide) chat.hide();
    }
  })

  