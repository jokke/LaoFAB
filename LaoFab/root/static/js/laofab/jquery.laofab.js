$(function(){ // document ready
	if (!!$('.sticky').offset()) { // make sure ".sticky" element exists
		var stickyTop = $('.sticky').offset().top; // returns number 
		$(window).scroll(function(){ // scroll event
			var windowTop = $(window).scrollTop(); // returns number 
			if (stickyTop < windowTop){
				$('.sticky').css({ position: 'fixed', top: 0 });
			} else {
				$('.sticky').css('position','static');
			}
		});
	}

	$('table.folder-listing tr:odd').addClass('odd');
	//$('table.alt tr:even').addClass('even');
});
