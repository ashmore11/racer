class @RaceView

	map  : null
	path : null

	constructor: ->

		do @helpers
		do @events
		do @templateCRD

		Date.prototype.addHours = ( h ) ->
					
			@setHours @getHours() + h
			
			return @


	helpers: ->

		Template.race.helpers

			title: ->

				index = 0
				id    = RaceList.findOne( @_id )?._id

				for item, i in RaceList.find().fetch()

					if item._id is id

						index = i

						break

				hours = new Date().addHours index
				hours = do hours.getHours

				return hours

			userInRace: ->

				race = RaceList.findOne @_id

				return _.contains race?.users, Meteor.userId()

			noUsers: ->

				return RaceList.findOne( @_id )?.users.length is 0

			raceLive: ->

				return RaceList.findOne( Session.get 'current:race:id' )?.live

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
				users = RaceList.findOne( @_id )?.users

				return unless users

				query =
					sort: 'profile.distance': -1

				# Fetch the users using the array of id's and sort by greatest distance
				users = Meteor.users.find( _id: $in: users, query ).fetch()

				return users

			avatar: ->

				id = Meteor.users.findOne( @_id ).profile.id

				return "https://graph.facebook.com/" + id + "/picture/?type=large"

			userIsMoving: ->

				return Meteor.user().profile.distance > 0

			friends: ->

				friends = Meteor.user().profile.friends

				return Meteor.users.find( 'profile.id': $in: friends ).fetch()

			mapOptions: ->

				if GoogleMaps.loaded() and Geolocation.currentLocation()

					lat = Geolocation.currentLocation().coords.latitude
					lon = Geolocation.currentLocation().coords.longitude

					return {
						mapTypeId        : google.maps.MapTypeId.MAP
						disableDefaultUI : true
						zoomControl      : true
						zoom             : 16
						center           : new google.maps.LatLng lat, lon
					}


	events: ->

		Template.race.events

			'click .join-race-btn': ( event ) ->

				Meteor.call 'updateUsersArray', @_id

			'click .invite-friends-btn': ( event ) ->

				return

			'click li.currentUser': ( event ) =>

				if RaceList.findOne( Session.get 'current:race:id' ).live

					$('.map-container').addClass 'active'

					Session.set 'map:active', true


	templateCRD: ->

		Template.race.created = =>

			do @setupMap
			do @updateCoordsAndMap

		# Template.race.rendered = ->
		# Template.race.destroyed = ->


	setupMap: ->

		GoogleMaps.ready 'userMap', ( map ) =>

			coordsExist = _interval 1000, =>
				
				if Meteor.user().profile.raceCoords?.length > 0

					Meteor.clearInterval coordsExist

					@map = map.instance

					do @createPath


	updateCoordsAndMap: ->

		Tracker.autorun () =>

			raceId = Session.get 'current:race:id'
			race   = RaceList.findOne raceId

			return unless race

			userInRace = _.contains race.users, Meteor.userId()

			if userInRace and race.live

				if Geolocation.currentLocation()

					lat = Geolocation.currentLocation().coords.latitude
					lon = Geolocation.currentLocation().coords.longitude
						
					Meteor.call 'updateCoords', lat, lon

					do @updateMap if @map


	createPath: ->

		@polyline = new google.maps.Polyline
			path          : do @getPath
			clickable     : false
			geodesic      : false
			strokeColor   : '#ADFF2F'
			strokeOpacity : 1
			strokeWeight  : 8

		@polyline.setMap @map


	getPath: ->

		path = []

		for item in Meteor.user().profile.raceCoords

			pathCoord = new google.maps.LatLng item.lat, item.lon
		
			path.push pathCoord

		return path

		
	updateMap: ->

		path = do @getPath

		@polyline.setPath path

		@map.panTo _.last path

		distance = google.maps.geometry.spherical.computeLength path

		distance = Number ( distance * 0.001 ).toFixed 2

		Meteor.call 'updateDistance', distance

