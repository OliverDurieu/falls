$(document).ready(function(){
	$('#b1').click(function(){
    $("html, body").animate({ scrollTop: $(window).height()}, 1000);
    return false;
	});
	$(window).scroll(function() {
    if ($(this).scrollTop() > 40) {
        $( ".header #background" ).fadeIn();
    } else {
        $( ".header #background" ).fadeOut();
    }
	});
});