$(document).on('turbolinks:load', function() {

});

$(document).on('click', 'li a', function() {
	console.log($(this));
});

$(document).on('fields_added.nested_form_fields', function(event){
	// this field was just inserted into your form
	 $('.datepickerstart').pickadate({
	 format: 'yyyy/mm/dd',
	 selectMonths: true,
	 selectYears: 60,
	 });
	 $('.select-select').select2();
});
