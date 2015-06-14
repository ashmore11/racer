class @RaceUserView

	map           : null
	path          : null
	templateActive: false

	constructor: ->

		do @initHelpers
		do @rendered


	initHelpers: ->

		Template.raceUser.helpers

			mapOptions: ->

				if GoogleMaps.loaded() and Geolocation.currentLocation()

					lat = Geolocation.currentLocation().coords.latitude
					lon = Geolocation.currentLocation().coords.longitude

					return {
						mapTypeId        : google.maps.MapTypeId.MAP
						disableDefaultUI : true
						zoomControl      : false
						zoom             : 16
						center           : new google.maps.LatLng lat, lon
					}


	rendered: ->

		Template.raceUser.rendered = =>

			@templateActive = true

			GoogleMaps.ready 'userMap', ( map ) =>

				Session.set 'map:loaded', true

				@map = map.instance

				do @setPath
				do @createPath

			Tracker.autorun () =>

				if Geolocation.currentLocation() and @map

					if @templateActive

						do @updateCoords
						
						Tracker.nonreactive =>
							
							do @updateMap

		Template.raceUser.destroyed = =>

			@templateActive = false


	updateCoords: ->

		lat = Geolocation.currentLocation().coords.latitude
		lon = Geolocation.currentLocation().coords.longitude

		PathCoords.insert
			coord: { lat: lat, lon: lon }


	setPath: ->

		if PathCoords.find().fetch().length is 0
			
			do @updateCoords

			pathCoord = PathCoords.find().fetch()[0].coord

			@pathCoords = [ new google.maps.LatLng pathCoord.lat, pathCoord.lon ]

		else

			@pathCoords = []

			for item in PathCoords.find().fetch()

				pathCoord = new google.maps.LatLng item.coord.lat, item.coord.lon
		
				@pathCoords.push pathCoord


	createPath: ->

		@path = new google.maps.Polyline
			path          : @pathCoords
			clickable     : false
			geodesic      : true
			strokeColor   : '#ADFF2F'
			strokeOpacity : 1
			strokeWeight  : 7

		@path.setMap @map

		@map.setCenter _.last @pathCoords

		
	updateMap: ->

		path = @path.getPath()

		for item in PathCoords.find().fetch()

			pathCoord = new google.maps.LatLng item.coord.lat, item.coord.lon
		
			path.push pathCoord

		@path.setPath path

		@map.panTo pathCoord

		@setDistance path


	setDistance: ( path ) ->

		distance = google.maps.geometry.spherical.computeLength( path )
		distance = ( distance * 0.001 ).toFixed 2

		Meteor.call 'updateDistance', distance

