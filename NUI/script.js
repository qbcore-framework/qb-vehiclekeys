
window.onload = function () {
    var eventCallback = {
        setText: function(data) {
            var key = document.querySelector('#'+data.id+' span');
            var html = data.value;
            saferInnerHTML(key, html);
        },
    };
}
$(function()
{
    $('.container').hide();
    window.addEventListener('message', function(event)
    {
        var cdata = event.data;
        if (cdata.casemenue == 'open')
        {
            $('.container').show();
        }   
    }, false);

    document.onkeyup = function (data) {
        if (data.which == 27) { // Escape key
            $.post('https://qb-vehiclekeys/closui', JSON.stringify({ message: null }));
            $('.container').hide();
        }
    };

    document.getElementById("unlock-button").addEventListener("click", function(){
        $.post('https://qb-vehiclekeys/unlock', JSON.stringify({}))
        $('.container').hide();   
    });

    document.getElementById("lock-button").addEventListener("click", function(){
        $.post('https://qb-vehiclekeys/lock', JSON.stringify({}))
        $('.container').hide();   
    });

    document.getElementById("trunk-button").addEventListener("click", function(){
        $.post('https://qb-vehiclekeys/trunk', JSON.stringify({}))
        $('.container').hide();   
    });

    document.getElementById("engine-button").addEventListener("click", function(){
        $.post('https://qb-vehiclekeys/engine', JSON.stringify({}))
        $('.container').hide();   
    });
});
