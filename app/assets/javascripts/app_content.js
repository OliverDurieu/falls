$(document).ready(function () {
    $('input[type=file].upload-attachment').change(function (event) {
        var target = $(event.target);
        if (target.val() != '') {
            $(target.parents('form').get(0)).submit(); //better ways to do it

            event.stopPropagation();
            return false;
        }
    });

});