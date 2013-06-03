// rename to map.js

google.maps.visualRefresh = true;

var map;
var infowindow = new google.maps.InfoWindow();

function addProperty(property) {
  var contentString = '<div id="content">'+
      '<div id="siteNotice"></div>'+
      '<h1 id="firstHeading" class="firstHeading">' +
      property.name +
      '</h1>'+
      '<div id="bodyContent">'+
      '<ul><li>Bedrooms :' +
      property.bedroom_count +
      '<li>Price : £123' +
      '</ul>' +
      '<p>More info: <a href="http://rentify.com/123">'+
      'http://rentify.com/123</a> '+
      '</p>'+
      '</div>'+
      '</div>';

  var pos = new google.maps.LatLng(property.latitude, property.longitude);

  var marker = new google.maps.Marker({
      position: pos,
      map: map,
      title: property.name
  });

  google.maps.event.addListener(marker, 'click', function() {
    infowindow.setContent(contentString);
    infowindow.open(map, marker);
    addCircle(pos, 20000);
  });
}

function addCircle(pos, r) {
  if (typeof(circle) != "undefined") {
    circle.setMap(null);
  }
  var options = {
      strokeColor: '#FF0000',
      strokeOpacity: 0.8,
      strokeWeight: 2,
      fillColor: '#FF0000',
      fillOpacity: 0.35,
      map: map,
      center: pos,
      radius: r
    };
  // global! bad
  circle = new google.maps.Circle(options);
}

function initialize() {
  var center_pos = new google.maps.LatLng(51.501000, -0.142000);

  var mapOptions = {
    zoom: 13,
    center: center_pos,
    mapTypeId: google.maps.MapTypeId.ROADMAP
  };

  map = new google.maps.Map(document.getElementById('map-canvas'), mapOptions);

  if(navigator.geolocation) {
    navigator.geolocation.getCurrentPosition(function(position) {
      var found_pos = new google.maps.LatLng(position.coords.latitude,
                                             position.coords.longitude);

      map.setCenter(found_pos);
    }, function() {
      handleNoGeolocation(true);
    });
  }
}

function handleNoGeolocation(errorFlag) {
  if (errorFlag) {
    var content = 'Error: The Geolocation service failed.';
  } else {
    var content = 'Error: Your browser doesn\'t support geolocation.';
  }
  map.setCenter(options.position);
}

// google.maps.event.addDomListener(window, 'load', initialize);

