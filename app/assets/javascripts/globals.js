$(document).ready(function(){

	$('.datepickerstart').pickadate({
		format: 'yyyy/mm/dd',
		selectMonths: true,
		selectYears: 60,
		});

	$('.datepickerend').pickadate({
		format: 'yyyy/mm/dd',
	});

	$('.timepickerstart').pickatime({

		});

	$('.timepickerend').pickatime({

	});

	$('.select-select').select2();

	// password edit form
	$('#password-edit-form').hide().removeClass('hide');
	$('#hide-password-settings').hide().removeClass('hide');

	$('#show-password-settings').click(function(){
   	$('#password-edit-form').slideToggle();
   	$('#show-password-settings').toggle();
   	$('#hide-password-settings').show();
   });
	$('#hide-password-settings').click(function() {
	 	$('#password-edit-form').slideToggle();
	 	$('#show-password-settings').show();
	 	$('#hide-password-settings').hide();
	 });
	 	// Address edit form

	$('#address-edit-form').hide().removeClass('hide');
	$('#show-address-settings').click(function() {
   	$('#address-edit-form').slideToggle();
    $('#leave-type-edit-form').hide();
    $('#company-leave-settings-edit-form').hide();
   });

		// Leave Type edit form

	$('#leave-type-edit-form').hide().removeClass('hide');
	$('#show-leave-type-settings').click(function() {
   	$('#leave-type-edit-form').slideToggle();
    $('#company-leave-settings-edit-form').hide();
    $('#address-edit-form').hide();
   });

	// Company Leave Settings form

	$('#company-leave-settings-edit-form').hide().removeClass('hide');
	$('#show-company-leave-settings').click(function() {
   	$('#company-leave-settings-edit-form').slideToggle();
    $('#leave-type-edit-form').hide();
    $('#address-edit-form').hide();
   });

	// Holiday settings

	$('.edit-holiday-form').hide().removeClass('hide');
	$('.hide-edit-holiday').hide().removeClass('hide');

	$('.show-edit-holiday', this).click(function() {
   	$(this).parent().siblings(".edit-holiday-form").slideToggle();
   	$(this).toggle();
   	$(this).siblings(".hide-edit-holiday").toggle();
   });

	$('.hide-edit-holiday', this).click(function() {
	 	$(this).parent().siblings(".edit-holiday-form").slideToggle();
	 	$(this).siblings(".show-edit-holiday").toggle();
	 	$(this).toggle();
	 });


});

$(document).on('click', 'li a', function() {
	console.log($(this));
});
