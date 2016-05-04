function buildPath(coordsArr) {
	var lineSymbol = {
		path: google.maps.SymbolPath.FORWARD_CLOSED_ARROW,
		scale: 4,
		strokeColor: '#393',
		fillColor: '#00FF00',
		fillOpacity: 1.0,
	};
	line = new google.maps.Polyline({
		path: coordsArr,
		strokeColor: '#006400',
		strokeOpacity: 0.5,
		icons: [{
			icon: lineSymbol,
			offset: '100%'
		}],
		map: mapHandler,
	});
	if(coordsArr.length > 1){
		showSendEmail();
		var image_end = 'https://developers.google.com/maps/documentation/javascript/examples/full/images/beachflag.png';
		var image_start = 'https://mt.googleapis.com/vt/icon/name=icons/onion/22-blue-dot.png&scale=1.0';
		var start_loc = new google.maps.Marker({
			position: coordsArr[0],
			map: mapHandler,
			icon: image_start,
			animation: google.maps.Animation.DROP
		});
		var destination_loc = new google.maps.Marker({
			position: coordsArr[coordsArr.length - 1],
			map: mapHandler,
			icon: image_end,
			animation: google.maps.Animation.DROP
		});
		markers.push(start_loc);
		markers.push(destination_loc);
	}
	animateCircle(line)
};

function animateCircle(line) {
	var count = 0;
	window.setInterval(function() {
		count = (count + 1) % 200;

		var icons = line.get('icons');
		icons[0].offset = (count / 2) + '%';
		line.set('icons', icons);
	}, 20);
};

function setGeoCookie(position) {
	var cookie_val = position.coords.latitude + "|" + position.coords.longitude;
	document.cookie = "lat_lng=" + escape(cookie_val);
};

function showCurrPosOnMap(position){
	var lat = position.coords.latitude;
	var lng = position.coords.longitude;
	var infowindow =  new google.maps.InfoWindow({
		content: 'You are here!',
		map: mapHandler
	});
	var marker = new google.maps.Marker({
		position: new google.maps.LatLng(lat, lng),
		map: mapHandler,
		animation: google.maps.Animation.DROP
	});
	infowindow.open(mapHandler, marker);
};

function reloadMap() {
	mapHandler.setCenter(new google.maps.LatLng(42.366426, -71.258601));
	line.setMap(null);
	for(i = 0; i < markers.length; i++) {
		markers[i].setMap(null);
	}
};

function showSendEmail(){
	if(nodes.length > 0){
		 document.getElementById("emailSend").className = "enabled";
		  document.getElementById("sendEmailLink").setAttribute("data-toggle", "modal");
		  document.getElementById("sendEmailLink").setAttribute("data-target", "#sendEmail");
		  document.getElementById("sendEmailLink").setAttribute("href", "#sendEmail");
	  }
};
