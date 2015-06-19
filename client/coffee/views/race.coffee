class @RaceView

	map           : null
	path          : null
	templateActive: false

	constructor: ->

		do @helpers
		do @events
		do @created


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

			userIsMoving: ->

				return Meteor.users.findOne( @_id ).profile.distance > 0

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


	events: ->

		Template.race.events

			'click .join-race-btn': ( event ) ->

				Meteor.call 'updateUsersArray', @_id

			'click li.currentUser': ( event ) =>

				$('.map-container').addClass 'active'

				Session.set 'map:active', true


	created: ->

		Template.race.created = =>

			GoogleMaps.ready 'userMap', ( map ) =>

				@pathCoords = Meteor.users.findOne( Meteor.userId() ).profile.raceCoords

				coordsExist = _interval 500, =>
					
					if @pathCoords?.length > 0

						@map = map.instance

						do @createPath

						Meteor.clearInterval coordsExist

			Tracker.autorun () =>

				if Geolocation.currentLocation()

					lat = Geolocation.currentLocation().coords.latitude
					lon = Geolocation.currentLocation().coords.longitude
						
					Meteor.call 'updateCoords', lat, lon

					do @updateMap if @map


	createPath: ->

		@polyline = new google.maps.Polyline
			path          : do @getPath
			clickable     : false
			geodesic      : true
			strokeColor   : '#ADFF2F'
			strokeOpacity : 1
			strokeWeight  : 7

		@polyline.setMap @map


	getPath: ->

		path = []

		for item in @pathCoords

			pathCoord = new google.maps.LatLng item.lat, item.lon
		
			path.push pathCoord

		return path

		
	updateMap: ->

		path = do @getPath

		@polyline.setPath path

		@map.panTo _.last path

		distance = google.maps.geometry.spherical.computeLength( path )
		distance = Number ( distance * 0.001 ).toFixed 2

		Meteor.call 'updateDistance', distance

