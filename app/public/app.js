var map;

function getLocation() {
  if (navigator.geolocation) {
    navigator.geolocation.getCurrentPosition(
      function showPosition(position) {
        return position.coords
      })
  }
  else {
    return ""
  }
}


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

  var infowindow = new google.maps.InfoWindow({
      content: contentString
  });

  var marker = new google.maps.Marker({
      position: new google.maps.LatLng(property.latitude, property.longitude),
      map: map,
      title: property.name
  });

  google.maps.event.addListener(marker, 'click', function() {
    infowindow.open(map, marker);
  });
}

function initialize() {
  // var pos = getLocation();
  // console.log(pos);

  // var center = new google.maps.LatLng(pos.latitude, pos.longitude);
  var center_pos = new google.maps.LatLng(51.501000, -0.142000);

  var mapOptions = {
    zoom: 14,
    center: center_pos,
    mapTypeId: google.maps.MapTypeId.ROADMAP
  };

  map = new google.maps.Map(document.getElementById('map-canvas'), mapOptions);
}

// google.maps.event.addDomListener(window, 'load', initialize);
