class @RaceView

	map           : null
	path          : null
	templateActive: false

	constructor: ->

		do @initHelpers
		do @initEvents
		do @rendered


	initHelpers: ->

		Template.race.helpers

			title: ->

				race = RaceList.findOne @_id

				Date.prototype.addHours = ( h ) ->
					
					@setHours @getHours() + h
					
					return @

				hours = new Date().addHours ( race.index + 1 )
				hours = do hours.getHours

				return hours

			userInRace: ->

				race = RaceList.findOne @_id

				return _.contains race.users, Meteor.userId()

			noUsers: ->

				return RaceList.findOne( @_id ).users.length is 0

			raceLive: ->

				# return RaceList.findOne( Session.get 'current:race:id' ).live

				return true

			isUser: ->

				@_id is Meteor.userId()

			userUrl: ->

				url = "/races/#{Session.get('current:race:id')}/#{@_id}"

			accuracy: =>

				return Geolocation.currentLocation()?.coords.accuracy or 0

			speed: =>

				return Math.floor( Geolocation.currentLocation()?.coords.speed * 3.6 ) or 0

			competitors: ->

				# Get the array of user id's from the current race 
				ids = RaceList.findOne( @_id ).users

				# Fetch the users using the array of id's and sort by greatest distance
				users = Meteor.users.find( { _id: { $in: ids } }, { sort: { 'profile.distance': -1 } } ).fetch()

				return users

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

			mapReady: ->

				loaded = if Session.get('map:loaded') is true then 'loaded' else ''

				return loaded


	initEvents: ->

		Template.race.events

			'click .join-race-btn': ( event ) ->

				Meteor.call 'updateUsersArray', @_id


	rendered: ->

		Template.race.created = =>

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
			

		Template.race.destroyed = =>

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

