$(document).ready ->
  $('#other_date').trigger 'click'
#  $('#map_link').trigger 'click'
  
$(document).ready ->
  # initializing gmaps autocomplete
  autocomplete = []
  # Create the autocomplete object, restricting the search
  # to geographical location types.
  if $('.gmaps-input-address').length > 0
    options = 
      componentRestrictions: country: 'AU'
      types: [ 'geocode' ]
    $('.gmaps-input-address').each (index) ->
      $this = $(this)
      id = $this.attr('id')
      element = document.getElementById(id)
      $(this).bind 'keydown', (event) ->
        if event.keyCode == 13
          event.preventDefault()
        return
      autocomplete[index] = new (google.maps.places.Autocomplete)(element, options)
      # google.maps.event.addListener autocomplete[index], 'place_changed', ->
      #   window.bind_events_with_gmaps()
      #   if $('#gmaps-canvas').length
      #     # fillInAddress(autocomplete[index]);
      #     $this.fillInAddress autocomplete[index]
      #     drawGMap()
      #   else if $(gmap_longitude_ele_name).length > 0
      #     $this.fillInAddress autocomplete[index]
      #   return
      # return

 
$('#map_link').click ->
  longitudes = document.getElementsByName('ride_source_longitude_arry')
  longitude_arry = longitudes[0].value.split(' ')
  latitudes = document.getElementsByName('ride_source_latitude_arry')
  latitude_arry = latitudes[0].value.split(' ')
  prices = document.getElementsByName('ride_price_arry')
  prices_arry = prices[0].value.split(' ')
#  console.log 'today'
  Map_marker longitude_arry, latitude_arry, prices_arry
  return


# window.onload = (e) ->
#   longitudes = document.getElementsByName('ride_source_longitude_arry')
#   longitude_arry = longitudes[0].value.split(' ')
#   latitudes = document.getElementsByName('ride_source_latitude_arry')
#   latitude_arry = latitudes[0].value.split(' ')
#   prices = document.getElementsByName('ride_price_arry')
#   prices_arry = prices[0].value.split(' ')
#   # console.log 'today'
#   Map_marker longitude_arry, latitude_arry, prices_arry
#   return


$('#other_date').click ->
  longitudes = document.getElementsByName('o_ride_source_longitude_arry')
  longitude_arry = longitudes[0].value.split(' ')
  latitudes = document.getElementsByName('o_ride_source_latitude_arry')
  latitude_arry = latitudes[0].value.split(' ')
  prices = document.getElementsByName('o_ride_price_arry')
  prices_arry = prices[0].value.split(' ')
  Map_marker longitude_arry, latitude_arry, prices_arry
  return


 Map_marker = (longitude_arry, latitude_arry, prices_arry) ->
  map = new (google.maps.Map)(document.getElementById('pointers_map'),
    zoom: 10
    center: new (google.maps.LatLng)(parseFloat(latitude_arry[0]), parseFloat(longitude_arry[0]))
    mapTypeId: google.maps.MapTypeId.ROADMAP)
  i = 0
  while i < longitude_arry.length
    homeLatLng = new (google.maps.LatLng)(parseFloat(latitude_arry[i]) , parseFloat(longitude_arry[i]))
    marker = new MarkerWithLabel(
      position: homeLatLng
      draggable: false      
      raiseOnDrag: false
      visible: true
      icon:
        path: google.maps.SymbolPath.FORWARD_CLOSED_ARROW
        strokeColor: 'red'
        scale: 0
      map: map
      labelContent: '$' + parseFloat(prices_arry[i]) + 'AUD' 
      labelAnchor: new (google.maps.Point)(32, 32)
      labelClass: 'marker_labels')
    i++














