//console.log('maps');
var autocomplete = [];
var geocoder = new google.maps.Geocoder();
var directionsDisplay = new google.maps.DirectionsRenderer();
var directionsService = new google.maps.DirectionsService();
var gmap_parent_ele_name = ".location-holder";
var gmap_origin_ele_name = "#ride_source";
var gmap_destination_ele_name = "#ride_destination";
var gmap_sub_routes_ele_name = ".sub-route-locations";
var gmap_longitude_ele_name = ".input-longitude";
var gmap_latitude_ele_name = ".input-latitude";
var gmap_distance_ele_name = "#ride_total_distance";
var gmap_time_ele_name = "#ride_total_time";
var gmap_distance_display_div = ".ride_total_distance";
var gmap_time_display_div = ".ride_total_time";

function gmapAutocompleteInitialize() {
    	
  // Create the autocomplete object, restricting the search
  // to geographical location types.
  


    if ($('.gmaps-input-address').length > 0){
		  var options = {
		      componentRestrictions: {
		        country: 'AU'
		      },
		      types: ['geocode']
		    };
		  	
    	$('.gmaps-input-address').each(function(index){
		    var $this = $(this);
		    var id = $this.attr('id');
		    var element = document.getElementById(id);
		    
		    $(this).bind('keydown', function (event) {
			    if (event.keyCode == 13) {
			      event.preventDefault();
			    }
			  });  
		    autocomplete[index] = new google.maps.places.Autocomplete(element, options);
		    

		    google.maps.event.addListener(autocomplete[index], 'place_changed', function() {
		    	window.bind_events_with_gmaps();
		      if ($('#gmaps-canvas').length) {
		        // fillInAddress(autocomplete[index]);
		        $this.fillInAddress(autocomplete[index]);
		        drawGMap();
		      }
		      else if($(gmap_longitude_ele_name).length > 0) {
		        $this.fillInAddress(autocomplete[index]);
		      };
		    });

		  });	
    };

}


// Query the Google geocode object
//
// type: 'address' for search by address
//       'latLng'  for search by latLng (reverse lookup)
//
// value: search query
//

function drawGMap() {
	calcRoute();
	var map_provider = {
		center: new google.maps.LatLng(-34.397, 150.644),
		zoom: 4
	};
	var handler = Gmaps.build('Google');
	handler.buildMap({
		provider: map_provider,
		internal: {id: 'gmaps-canvas'}
	}, function () {
		directionsDisplay.setMap(handler.getMap());
	});
}

function calcRoute() {
	var origin = $(gmap_origin_ele_name).val();
	var destination = $(gmap_destination_ele_name).val();
	var waypoints_arr = []
	$(gmap_sub_routes_ele_name).each(function () {
		if ($(this).val() != "") {
			waypoints_arr.push({
				location: $(this).val(),
				stopover: true
			});
		}

	});
	// var origin      = new google.maps.LatLng(41.850033, -87.6500523);
	// var destination = new google.maps.LatLng(42.850033, -85.6500523);
	var request = {
		origin: origin,
		destination: destination,
		// origin: "Chicago, IL",
		//  destination: "Los Angeles, CA",
		//way point: New York, NY, United States
		waypoints: waypoints_arr,
		travelMode: google.maps.TravelMode.DRIVING
	};

	directionsService.route(request, function (response, status) {
		if (status == google.maps.DirectionsStatus.OK) {
			$('#gmaps-error').hide();
			directionsDisplay.setDirections(response);
		}
		else if (status == google.maps.DirectionsStatus.NOT_FOUND) {
			if ($(gmap_origin_ele_name) && $(gmap_origin_ele_name).val() != "" && $(gmap_destination_ele_name) && $(gmap_destination_ele_name).val() != "") {
				$('#gmaps-error').html("at least one of the locations specified in the request origin, destination, or way points could not be geocoded.");
				$('#gmaps-error').show();
			}

		}
		else if (status == google.maps.DirectionsStatus.ZERO_RESULTS) {
			$('#gmaps-error').html("Sorry! no route could be found between the origin and destination.");
			$('#gmaps-error').show();
		}
		else if (status == google.maps.DirectionsStatus.MAX_WAYPOINTS_EXCEEDED) {
			$('#gmaps-error').html("Too many DirectionsWaypoints were provided in the DirectionsRequest. The maximum allowed waypoints is 8, plus the origin, and destination. Maps API for Business customers are allowed 23 waypoints, plus the origin, and destination. Waypoints are not supported for transit directions.");
			$('#gmaps-error').show();
		}
		else if (status == google.maps.DirectionsStatus.INVALID_REQUEST) {
			$('#gmaps-error').html("The provided DirectionsRequest was invalid. The most common causes of this error code are requests that are missing either an origin or destination, or a transit request that includes waypoints.");
			$('#gmaps-error').show();
		}
		else if (status == google.maps.DirectionsStatus.OVER_QUERY_LIMIT) {
			$('#gmaps-error').html("The web page has sent too many requests within the allowed time period.");
			$('#gmaps-error').show();
		}
		else if (status == google.maps.DirectionsStatus.REQUEST_DENIED) {
			$('#gmaps-error').html("The web page is not allowed to use the directions service.");
			$('#gmaps-error').show();
		}
		else if (status == google.maps.DirectionsStatus.UNKNOWN_ERROR) {
			$('#gmaps-error').html("A directions request could not be processed due to a server error. The request may succeed if you try again.");
			$('#gmaps-error').show();
		}
	});
}


function getGMapDistance() {

	// var origin = new google.maps.LatLng(parseFloat($("#ride_source_latitude").val(), 10), parseFloat($("#ride_source_longitude").val(), 10));
	var origin = $(gmap_origin_ele_name).val();
	// var destination = new google.maps.LatLng(parseFloat($("#ride_destination_latitude").val(), 10), parseFloat($("#ride_destination_longitude").val(), 10));
	var destination = $(gmap_destination_ele_name).val();
	var service = new google.maps.DistanceMatrixService();
	service.getDistanceMatrix(
		{
			origins: [origin],
			destinations: [destination],
			travelMode: google.maps.TravelMode.DRIVING,
			// unitSystem: UnitSystem,
			avoidHighways: false,
			avoidTolls: false
		},
		distanceCallback
	);
}

function distanceCallback(response, status) {

	if (status == google.maps.DistanceMatrixStatus.OK) {
		var origins = response.originAddresses;
		var destinations = response.destinationAddresses;

		for (var i = 0; i < origins.length; i++) {
			var results = response.rows[i].elements;
				for (var j = 0; j < results.length; j++) {
				var element = results[j];
				if(element.distance.text != null)
				{
					var distance = element.distance.text;					
				}
				var duration = element.duration.text;
				var from = origins[i];
				var to = destinations[j];
				$(gmap_distance_ele_name).val(distance);
				$(gmap_time_ele_name).val(duration);
				$(gmap_distance_display_div).text(distance);
				$(gmap_time_display_div).text(duration);
			}
		}
	}
}

jQuery.fn.locationHolder = function () {
	return $(this).parents(gmap_parent_ele_name);
}

jQuery.fn.longitude = function () {
	var parent_ele = $(this).locationHolder();
	return parseFloat(parent_ele.find(gmap_longitude_ele_name).val(), 10);
}

jQuery.fn.latitude = function () {
	var parent_ele = $(this).locationHolder();
	return parseFloat(parent_ele.find(gmap_latitude_ele_name).val(), 10);
}




// // [START region_fillform]
jQuery.fn.fillInAddress = function(aut) {
  // Get the place details from the autocomplete object.
  
  var place = aut.getPlace();
  var location = place.geometry.location;
  var parent_ele = $(this).locationHolder();
	parent_ele.find(gmap_longitude_ele_name).val(location.lng()); // location vars
	parent_ele.find(gmap_latitude_ele_name).val(location.lat());


}
