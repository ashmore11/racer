class @HomeView

	index: 0

	constructor: ->

		# do @login_with_facebook

		@options =
			enableHighAccuracy : true
			maximumAge         : 0
			timeout            : 10000

		@location = new ReactiveVar null
			
		# promise = new Promise ( resolve, reject ) ->

		# 	navigator.geolocation.watchPosition resolve, reject, options

		# promise.then ( position ) => 

		# 	@location.set position.coords

		# 	@init()

		@init()

	get_pos: ->

		do @startWatchingPosition

		return @location.get()

	startWatchingPosition: ->

		unless @watchingPosition && navigator.geolocation

			navigator.geolocation.watchPosition @onPosition, @onError, @options
			
			@watchingPosition = true


	onPosition: ( position ) =>

		@location.set position


	onError: ( error ) =>

		console.log error


	init: ( position ) ->

		# do @init_map

		Tracker.autorun () =>

			if @get_pos()

				@index++

				# do @update_map

				coords = @location.get().coords

				$('#stats').find('.accuracy').html( 'ACCURACY: ' + Math.floor( coords.accuracy ) + ' Meters' )
				$('#stats').find('.heading').html( 'HEADING: ' + ( coords.heading or 0 ) )
				$('#stats').find('.lat').html( 'LAT: ' + coords.latitude )
				$('#stats').find('.lon').html( 'LON: ' + coords.longitude )
				$('#stats').find('.speed').html( 'SPEED: ' + ( Math.floor( ( coords.speed or 0 ) * 3.6 ) ) + ' kph' )
				$('#stats').find('.distance').html( 'DISTANCE: ' + @get_distance( @lat_1, @lon_1, @lat_2, @lon_2 ) + ' km' )
				$('#stats').find('.index').html( 'INDEX: ' + @index )


	init_map: ->

		map_canvas  = document.getElementById 'map_canvas'
		map_options =
			mapTypeId        : google.maps.MapTypeId.MAP
			disableDefaultUI : true
			zoomControl      : true
			zoom             : 18

		@map = new google.maps.Map map_canvas, map_options

		@lat_1 = @location.get().latitude
		@lon_1 = @location.get().longitude

		@generate_marker_and_set_center @lat_1, @lon_1

		
	update_map: ->

		@lat_2 = @location.get().latitude
		@lon_2 = @location.get().longitude

		@generate_marker_and_set_center @lat_2, @lon_2


	generate_marker_and_set_center: ( lat, lon ) ->

		lat_lon = new google.maps.LatLng lat, lon

		marker = new google.maps.Marker
			position : lat_lon
			map      : @map

		@map.setCenter lat_lon


	get_distance: ( lat1, lon1, lat2, lon2 ) ->

		deg2rad = ( deg ) -> return deg * ( Math.PI / 180 )

		R = 6371
		
		dLat = deg2rad lat2 - lat1
		dLon = deg2rad lon2 - lon1
		
		a = Math.sin( dLat / 2 ) * Math.sin( dLat / 2 ) + 
				Math.cos( deg2rad( lat1 ) ) * Math.cos( deg2rad( lat2 ) ) * 
				Math.sin( dLon / 2 ) * Math.sin( dLon / 2 )

		c = 2 * Math.atan2( Math.sqrt( a ), Math.sqrt( 1 - a ) )
		d = R * c
		
		return d.toFixed 2


	login_with_facebook: ->

		Template.login.events
			
			'click .fa-facebook': ->

				do Meteor.loginWithFacebook
