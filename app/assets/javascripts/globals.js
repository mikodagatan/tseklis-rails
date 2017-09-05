$(document).ready(function(){

	$('.datepickerstart').pickadate({
		format: 'yyyy/mm/dd',
		selectMonths: true,
		selectYears: 60,
		max: true,
		});

	$('.datepickerend').pickadate({
		format: 'yyyy/mm/dd',
		min: true
	});

	$('.timepickerstart').pickatime({

		});

	$('.timepickerend').pickatime({

	});

	$('.select-select').select2();

	// password edit form
	$('#password-edit-form').hide();
	$('#hide-password-settings').hide();

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

	$('#address-edit-form').hide();
	$('#show-address-settings').click(function() {
   	$('#address-edit-form').slideToggle();
    $('#leave-type-edit-form').hide();
    $('#company-leave-settings-edit-form').hide();
   });

		// Leave Type edit form

	$('#leave-type-edit-form').hide();
	$('#show-leave-type-settings').click(function() {
   	$('#leave-type-edit-form').slideToggle();
    $('#company-leave-settings-edit-form').hide();
    $('#address-edit-form').hide();
   });

	// Company Leave Settings form

	$('#company-leave-settings-edit-form').hide();
	$('#show-company-leave-settings').click(function() {
   	$('#company-leave-settings-edit-form').slideToggle();
    $('#leave-type-edit-form').hide();
    $('#address-edit-form').hide();
   });

	// Holiday settings


	$('.edit-holiday-form').hide();
	$('.hide-edit-holiday').hide();

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
