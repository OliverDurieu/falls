$(document).ready(function () {

	$(document).on('change', '#phone_fill_phone_regionCode', function () {
		$this = $(this)
		code = $(this).find(":selected").data("code");
		format = $(this).find(":selected").data("format");
		var html =
			' ' + code + ' <input name="phone_number" id="phone_number" placeholder="' + format + '" >'
		$("#country_code").val(code);
		$("#extension_phon_number").html(html);
	});

	$(document).on('click', '#verify_phone_number', function () {
		var code = $("#country_code").val();
		var number = $("#phone_number").val();
		if (code.length == 0 || number.length == 0) {
			$("#invalid_phone_error").show();
			$("#invalid_phone_error").html('This number is not valid');
		}
		else {
			$.ajax({
				url: "/verify_phone_number",
				dataType: "json",
				async: false,
				data: {
					"country_code": code,
					"phone_number": number,
					"country_id": $('#phone_fill_phone_regionCode').val()
				},
				success: function (response) {
					if (response == false) {
						$("#invalid_phone_error").show();
						$("#invalid_phone_error").html("This number is not valid");
					} else {
						window.location.href = "/confirmation_phone"
					}
				}
			});
		}
	});
	$(document).on('click', '#phone_confirmation_code_submit', function () {
		var code = $("#verification_code").val();
		if (code.length == 0) {
			$("#invalid_phone_code").show();
			$("#invalid_phone_code").html('Please Enter your 4 digit code');
		}
		else {
			$.ajax({
				url: "/confirm_phone",
				dataType: "json",
				async: false,
				data: {
					"code": code
				},
				success: function (response) {
					if (response == false) {
						$("#invalid_phone_code").show();
						$("#invalid_phone_code").html('Invalid 4 digit code');
					} else {
						window.location.href = "/complete_registration_proccess"
					}
				}
			});
		}
	});
});