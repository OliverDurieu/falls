$(document).ready(function(){   
  $(".car-maker-select").change(function () {
    var $this = $(this);
    $.ajax({
        type: 'GET',
        url: '/car_makers/' + $this.val() + '/car_models',
        dataType: 'html',
        success: function (data) {
            $('.car-model-select').html(data);
        }
    });
  });

  $("#car_image_tag").click(function() {
    $("input[id='car_photo_uploader_partial']").click();
  });

  $("#car_photo_uploader_partial").change(function(){
      readURL(this);
  });
  
});


function readURL(input) {
    if (input.files && input.files[0]) {
      var reader = new FileReader();
      
      reader.onload = function (e) {
          $('#car_image_tag').attr('src', e.target.result);
      }
      
      reader.readAsDataURL(input.files[0]);
    }
}

;
