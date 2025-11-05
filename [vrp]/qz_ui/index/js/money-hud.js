const Hud = new Vue({
    el: ".money-hud",

    data: {
        loaded: false,
        player: {
            wallet: 0
        },
        showMoney: false
    },

    methods: {
        messageHandler: function (event) {
            const data = event.data
            if (data.target === "money-hud") {
                switch (data.action) {
                    case "load":
                        eval(data.code)
                        break
                    case "display":
                        this.showMoney = data.code === true
                        break
                }
            }
        }
    },

    mounted() {
        window.addEventListener('message', this.messageHandler)
    },

    beforeDestroy() {
        window.removeEventListener('message', this.messageHandler)
    }
})