class @RaceView

	map           : null
	path          : null
	templateActive: false

	constructor: ->

		do @helpers
		do @events
		do @rendered


	helpers: ->

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

			isCurrentUser: ->

				if @_id is Meteor.userId() then 'currentUser' else ''

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


	events: ->

		Template.race.events

			'click .join-race-btn': ( event ) ->

				Meteor.call 'updateUsersArray', @_id

			'click li.currentUser': ( event ) ->

				$('.map-container').addClass 'active'

				Session.set 'map:active', true


	rendered: ->

		Template.race.created = =>

			# Meteor.call 'resetCoords'

			GoogleMaps.ready 'userMap', ( map ) =>

				@map        = map.instance
				@pathCoords = Meteor.users.findOne( Meteor.userId() ).raceCoords

				do @createPath

			Tracker.autorun () =>

				if Geolocation.currentLocation() and @map

					lat = Geolocation.currentLocation().coords.latitude
					lon = Geolocation.currentLocation().coords.longitude

					Tracker.nonreactive =>
						
						Meteor.call 'updateCoords', lat, lon

						do @updateMap


	createPath: ->

		pathCoord = new google.maps.LatLng @pathCoords[0].lat, @pathCoords[0].lon

		@path = new google.maps.Polyline
			path          : [ pathCoord ]
			clickable     : false
			geodesic      : true
			strokeColor   : '#ADFF2F'
			strokeOpacity : 1
			strokeWeight  : 7

		@path.setMap @map

		@map.setCenter pathCoord

		
	updateMap: ->

		path = []

		for item in Meteor.users.findOne( Meteor.userId() ).raceCoords

			pathCoord = new google.maps.LatLng item.lat, item.lon
		
			path.push pathCoord

		@path.setPath path

		@map.panTo _.last path

		@setDistance path


	setDistance: ( path ) ->

		distance = google.maps.geometry.spherical.computeLength( path )
		distance = ( distance * 0.001 ).toFixed 2

		Meteor.call 'updateDistance', distance

