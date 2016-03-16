# $(window).load ->
#   if document.cookie.indexOf('visited=true') == -1
#     $('#welcomeModal').modal 'show'
#   return
# $(document).ready ->
#   $('#subscribe_email').click ->
#     days = 1000 * 60 * 60 * 24 * 8000
#     expires = new Date((new Date).valueOf() + days)
#     document.cookie = 'visited=true;expires=' + expires.toUTCString()
#     return
#   return
