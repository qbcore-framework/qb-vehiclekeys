
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

});
document.onreadystatechange = () => {
    if (document.readyState === 'complete') {
        $(document).keyup(function(event) {
            if (event.key === 'x') {
                $.post('https://qb-vehiclekeys/closui', JSON.stringify({ message: null }));
                $('.container').hide();
            }
        });
    }
}
function unlock()
{
    $.post('https://qb-vehiclekeys/unlock', JSON.stringify({ 
       
     }))
    $('.container').hide();
}
function lock()
{
    $.post('https://qb-vehiclekeys/lock', JSON.stringify({ 
       
     }))
    $('.container').hide();
}
function trunk()
{
    $.post('https://qb-vehiclekeys/trunk', JSON.stringify({ 
       
     }))
    $('.container').hide();
}
function engine()
{
    $.post('https://qb-vehiclekeys/engine', JSON.stringify({ 
       
     }))
    $('.container').hide();
}

