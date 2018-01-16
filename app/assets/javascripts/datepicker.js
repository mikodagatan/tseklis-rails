$(document).on('turbolinks:load', function() {
  $('.datepickerstart').pickadate({
		format: 'mmmm dd, yyyy - dddd',
		selectMonths: true,
		selectYears: 300,
	});

	$('.datepickerend').pickadate({
		format: 'yyyy/mm/dd',
	});

	$('.timepickerstart').pickatime({

		});

	$('.timepickerend').pickatime({

	});

	$('.select-select').select2();
});
