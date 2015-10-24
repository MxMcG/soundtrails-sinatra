$(document).ready(function() {


// login & registration buttons


  var showLoginForm = function(){
    $('button:first-child a').on('click', function(e){
      e.preventDefault();

      var path = $(this).attr('href');

      $.ajax({
        url: path,
        method: 'get',
        dataType: 'html'
      })
      .done(function(response){
        console.log(response);
        $('#register-login-wrapper').children().hide();
        $('#register-login-wrapper').append(response);
      })
    })
  };

  var showSignupForm = function(){
    $('button:nth-child(2) a').on('click', function(e){
      e.preventDefault();
      var path = $(this).attr('href');

      $.ajax({
        url: path,
        method: 'get',
        dataType: 'html'
      })
      .done(function(response){
        $('#register-login-wrapper').children().hide();
        $('#register-login-wrapper').append(response);
      })
    })
  };

// create a map form

  var showMapForm = function(){
    $('#create-map-btn').on("click", function(e){
      e.preventDefault();
      var path = $(this).attr('href');
      $.ajax({
        url: path,
        method: 'get'
      }).done(function(response){
        $(".create-map-wrapper form").remove()
        $(".create-map-wrapper").append(response);
      })
    })
  };

  showLoginForm();
  showSignupForm();
  showMapForm();

// Google maps API

  // types of mapTypeId
  var roadMap = google.maps.MapTypeId.ROADMAP
  var satelliteMap = google.maps.MapTypeId.SATELLITE
  var hybridMap = google.maps.MapTypeId.HYBRID
  var terrainMap = google.maps.MapTypeId.TERRAIN
  //

  var createMap = function(center, zoom, mapTypeId, tour_stop_location, title){
    var map = new google.maps.Map(document.getElementById('map'), {
      center: center,
      zoom: zoom,
      mapTypeId: mapTypeId
    });
    var marker = new google.maps.Marker({
      position: tour_stop_location,
      map: map,
      title: title
    });
  }

  // load map for view page

    var path = $(".view-map-link").attr("href");

    $.ajax({
      url: path,
      method: 'get',
      dataType: 'json'
    }).done(function(data){

      var artistTitle = data.artist
      var mapCenter = {lat: data.center_lat, lng: data.center_lng}
      createMap(mapCenter, 4, roadMap, mapCenter, artistTitle)
    })



  // determining center of map
  $('.create-map-wrapper').on("submit", "form" ,function(e){
      e.preventDefault();

      $(".create-map-wrapper").prepend("<p>creating map...</p>");
      $(".create-map-form").hide();

    navigator.geolocation.getCurrentPosition(function(geo){
      var location = {
        lat: geo.coords.latitude,
        lng: geo.coords.longitude
      }

    var path = $(this).attr('action');
    var mapTitle = $(".create-map-form input[name=band]").val();
    var mapCenterLat = location.lat
    var mapCenterLong = location.lng

    // send user location and artist name to route to create new map, new markers
    $.ajax({
      url: path,
      method: "post",
      data: {map_lat: mapCenterLat, map_lng: mapCenterLong, map_title: mapTitle},
      dataType: "html"
    }).done(function(data){
    // add new band link to profile page
      $('#map-list-wrapper').prepend(data);
    })

      $('.create-map-wrapper p').html("map created. thank you!")

    }) //end getposition

  }) //end get coordinates and artist






// Connecting pins on the map

// var lineCoordinates = [
//   new google.maps.LatLng(30.055487, 31.279766),
//   new google.maps.LatLng(30.223356, 31.324345),
//   new google.maps.LatLng(30.345656, 31.567677),
//   new google.maps.LatLng(30.565678, 31.676887)
// ];
// createPolyline(map, lineCoordinates, lineSymbol);

// var linePath;
// function createPolyline(map,lineCoordinates,lineSymbol){
//   linePath = new google.maps.Polyline({
//     path: lineCoordinates,
//     geodesic: true,
//     strokeColor: '#FF0000',
//     strokeOpacity: 1.0,
//     strokeWeight: 2
//    });
//  linePath.setMap(map);
// }



// user creates map with a band name.
// save maps labeled by a band name, and info that markers need when called.
// user goes to index, sees as many bands as he has created, each having its own set of markers.






});