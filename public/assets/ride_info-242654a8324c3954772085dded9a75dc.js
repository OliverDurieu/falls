(function() {
  var Map_marker;

  $(document).ready(function() {
    return $('#other_date').trigger('click');
  });

  $(document).ready(function() {
    var autocomplete, options;
    autocomplete = [];
    if ($('.gmaps-input-address').length > 0) {
      options = {
        componentRestrictions: {
          country: 'AU'
        },
        types: ['geocode']
      };
      return $('.gmaps-input-address').each(function(index) {
        var $this, element, id;
        $this = $(this);
        id = $this.attr('id');
        element = document.getElementById(id);
        $(this).bind('keydown', function(event) {
          if (event.keyCode === 13) {
            event.preventDefault();
          }
        });
        return autocomplete[index] = new google.maps.places.Autocomplete(element, options);
      });
    }
  });

  $('#map_link').click(function() {
    var latitude_arry, latitudes, longitude_arry, longitudes, prices, prices_arry;
    longitudes = document.getElementsByName('ride_source_longitude_arry');
    longitude_arry = longitudes[0].value.split(' ');
    latitudes = document.getElementsByName('ride_source_latitude_arry');
    latitude_arry = latitudes[0].value.split(' ');
    prices = document.getElementsByName('ride_price_arry');
    prices_arry = prices[0].value.split(' ');
    Map_marker(longitude_arry, latitude_arry, prices_arry);
  });

  $('#other_date').click(function() {
    var latitude_arry, latitudes, longitude_arry, longitudes, prices, prices_arry;
    longitudes = document.getElementsByName('o_ride_source_longitude_arry');
    longitude_arry = longitudes[0].value.split(' ');
    latitudes = document.getElementsByName('o_ride_source_latitude_arry');
    latitude_arry = latitudes[0].value.split(' ');
    prices = document.getElementsByName('o_ride_price_arry');
    prices_arry = prices[0].value.split(' ');
    Map_marker(longitude_arry, latitude_arry, prices_arry);
  });

  Map_marker = function(longitude_arry, latitude_arry, prices_arry) {
    var homeLatLng, i, map, marker, _results;
    map = new google.maps.Map(document.getElementById('pointers_map'), {
      zoom: 10,
      center: new google.maps.LatLng(parseFloat(latitude_arry[0]), parseFloat(longitude_arry[0])),
      mapTypeId: google.maps.MapTypeId.ROADMAP
    });
    i = 0;
    _results = [];
    while (i < longitude_arry.length) {
      homeLatLng = new google.maps.LatLng(parseFloat(latitude_arry[i]), parseFloat(longitude_arry[i]));
      marker = new MarkerWithLabel({
        position: homeLatLng,
        draggable: false,
        raiseOnDrag: false,
        visible: true,
        icon: {
          path: google.maps.SymbolPath.FORWARD_CLOSED_ARROW,
          strokeColor: 'red',
          scale: 0
        },
        map: map,
        labelContent: '$' + parseFloat(prices_arry[i]) + 'AUD',
        labelAnchor: new google.maps.Point(32, 32),
        labelClass: 'marker_labels'
      });
      _results.push(i++);
    }
    return _results;
  };

}).call(this);
