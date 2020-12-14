$(function () {
    window.addEventListener('message', function (event) {
        var item = event.data;
        var buf = $('#wrap');
        if (item.meta && item.meta == 'close') {
            document.getElementById("cop_data").innerHTML = "";
            document.getElementById("crook_data").innerHTML = "";
            document.getElementById("lobby_data").innerHTML = "";
            document.getElementById("cop_score").innerHTML = "";
            document.getElementById("crook_score").innerHTML = "";
            $('#wrap').hide();
            return;
        }

        var Score = item["Score"];
        var PlayerInfos = item["PlayerInfos"];

        document.getElementById("cop_score").innerHTML = Score['cop'];
        document.getElementById("crook_score").innerHTML = Score['crook'];

        for (let i = 0; i < PlayerInfos.length; i++) {
            const element = PlayerInfos[i];

            switch (element['team']) {
                case 'cop':
                    buf.find('#cop_data').append("<tr><td colspan='2'>" + element["playerName"] + "</td></tr>");
                    break;

                case 'crook':
                    if (element["isBoss"] == true) {
                        buf.find('#crook_data').append("<tr><td colspan='2'>👑 " + element["playerName"] + "</td></tr>");

                    } else {

                        buf.find('#crook_data').append("<tr><td colspan='2'>" + element["playerName"] + "</td></tr>");
                    }
                    break;

                case 'lobby':
                    buf.find('#lobby_data').append("<tr><td colspan='2'>" + element["playerName"] + "</td></tr>");
                    break;

                default:
                    break;
            }
        }

        $('#wrap').show();
    }, false);
});