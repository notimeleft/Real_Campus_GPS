var mapHandler;
var line;
var markers = [];

function initMap() {
	var coordsArr = []
	for (i = 0; i < nodes.length; i++) {
		coordsArr.push(new google.maps.LatLng(nodes[i][0], nodes[i][1]));
	}
	var southWest = new google.maps.LatLng(42.358631, -71.277989);
	var northEast = new google.maps.LatLng(42.373986, -71.243614);
	var mapBound = new google.maps.LatLngBounds(southWest, northEast);
	mapHandler = new google.maps.Map(document.getElementById('map'), {
		center: {lat: 42.366426, lng: -71.258601},
		zoom: 16,
		maxZoom: 18,
		minZoom: 16,
		maxBounds: mapBound,
		mapTypeControl: false,
	});
	buildPath(coordsArr);
	google.maps.event.addListener(mapHandler, 'dragend', function(evt) {
		if(mapBound.contains(mapHandler.getCenter())) return;
		mapHandler.setCenter(new google.maps.LatLng(42.366426, -71.258601));
	});
	if(navigator.geolocation) {
		navigator.geolocation.getCurrentPosition(showCurrPosOnMap,function error(msg){alert('Please enable your GPS position feature.');
		}, {maximumAge:600000, timeout:8000, enableHighAccuracy: true});
		navigator.geolocation.getCurrentPosition(setGeoCookie);
	}
}
