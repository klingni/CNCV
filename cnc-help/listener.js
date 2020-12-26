$(function () {
    window.addEventListener('message', function (event) {
        var item = event.data;
        var buf = $('#wrap');
        if (item.action == 'close') {
            $('#wrap').hide();
            return;
        }
        if(item.action == 'show') {
            $('#wrap').show();
            $('#playerCount').html(item["playerCount"]);
        }
        // if(item.action == 'update') {
        //     $('#playerCount').html(item["playerCount"]);
        // }
    }, false);

    $("#start").click(function(){
        $.post('http://cnc-help/start', JSON.stringify());
        return;
    });

    $("#close").click(function () {
        $.post('http://cnc-help/exit', JSON.stringify({}));
        return
    })
});

