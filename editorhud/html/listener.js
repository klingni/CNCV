$(function()
{
    window.addEventListener('message', function(event)
    {
        var item = event.data;
        var buf = $('#wrap');
        document.getElementById("mapName").innerHTML = item.map;
        $('#wrap').show();
    }, false);
});