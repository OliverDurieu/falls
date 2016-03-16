$(document).ready(function(){
  
  $("#user_image_holder").click(function() {
    $("input[id='profile_photo_uploader']").click();
  });

  $("#car_image_holder").click(function() {
    $("input[id='car_photo_uploader']").click();
  });

  $("#car_photo_uploader").change(function(){
      readURL(this);
  });

});

function readURL(input) {
  if (input.files && input.files[0]) {
      var reader = new FileReader();
      
      reader.onload = function (e) {
          $('#car_image_holder').attr('src', e.target.result);
      }
      
      reader.readAsDataURL(input.files[0]);
  }
}
    
;
