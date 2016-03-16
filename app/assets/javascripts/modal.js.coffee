$(document).ready ->
  $('#button_next_modal').click (e) ->
    e.preventDefault()
    $('#intial_signup_modal').modal('hide').on 'hidden.bs.modal', (e) ->
      $('#registration_modal').modal 'show'
      $(this).off 'hidden.bs.modal'
      # Remove the 'on' event binding
      return
    return
  return
  
$(document).ready ->
  $('#button2_next_modal').click (e) ->
    e.preventDefault()
    $('#myModal').modal('hide').on 'hidden.bs.modal', (e) ->
      $('#intial_signup_modal').modal 'show'
      $(this).off 'hidden.bs.modal'
      # Remove the 'on' event binding
      return
    return
  return
