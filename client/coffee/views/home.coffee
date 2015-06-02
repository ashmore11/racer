class @HomeView

	constructor: ->

		do @login_with_facebook

		Template.home.rendered = =>

			@index = 0

			Tracker.autorun () =>

				@index++

				geoloc = Geolocation.currentLocation()

				if geoloc

					@coords =
						accuracy  : geoloc.coords.accuracy
						heading   : geoloc.coords.heading or 0
						latitude  : geoloc.coords.latitude
						longitude : geoloc.coords.longitude
						speed     : geoloc.coords.speed or 0

					$('#stats').find('.accuracy').html( 'ACCURACY: ' + Math.floor( @coords.accuracy ) + ' Meters' )
					$('#stats').find('.lat').html( 'LAT: ' + @coords.latitude )
					$('#stats').find('.lon').html( 'LON: ' + @coords.longitude )
					$('#stats').find('.speed').html( 'SPEED: ' + ( Math.floor( @coords.speed * 3.6 ) ) + ' kph' )
					$('#stats').find('.index').html( 'INDEX: ' + @index )

					if @coords.heading > 315 and @coords.heading < 45
						compass = 'NORTH'

					if @coords.heading > 45 and @coords.heading < 135
						compass = 'EAST'

					if @coords.heading > 135 and @coords.heading < 225
						compass = 'SOUTH'

					if @coords.heading > 225 and @coords.heading < 315
						compass = 'WEST'

					$('#stats').find('.heading').html( 'HEADING: ' + compass )

					$('#stats').find('.distance').html( 'DISTANCE: ' + @get_distance( @lat_1?, @lon_1?, @lat_2?, @lon_2? ) + ' km' )

					do @update_map if @map


			height = 320
			width  = $( window ).width()

			$( '#map_canvas' ).height( height ).width( width )

			google.maps.event.addDomListener window, 'load', do @init_map


	login_with_facebook: ->

		Template.login.events
			
			'click .fa-facebook': ->

				do Meteor.loginWithFacebook


	init_map: ->

		map_canvas  = document.getElementById 'map_canvas'
		map_options =
			mapTypeId        : google.maps.MapTypeId.MAP
			disableDefaultUI : true
			zoomControl      : true
			zoom             : 18

		@map = new google.maps.Map map_canvas, map_options

		@lat_1 = @coords?.latitude
		@lon_1 = @coords?.longitude

		lat_lon = new google.maps.LatLng @lat_1, @lon_1

		marker = new google.maps.Marker
			position : lat_lon
			map      : @map

		@map.setCenter lat_lon

		
	update_map: ->

		@lat_2 = @coords.latitude
		@lon_2 = @coords.longitude

		lat_lon = new google.maps.LatLng @lat_2, @lon_2

		marker = new google.maps.Marker
			position : lat_lon
			map      : @map

		@map.setCenter lat_lon


	get_distance: ( lat1 = 0, lon1 = 0, lat2 = 0, lon2 = 0 ) ->

		R = 6371
		
		dLat = @deg2rad( lat2 - lat1 )
		dLon = @deg2rad( lon2 - lon1 ) 
		
		a = 
			Math.sin( dLat / 2 ) * Math.sin( dLat / 2 ) +
			Math.cos( @deg2rad( lat1 ) ) * Math.cos( @deg2rad( lat2 ) ) * 
			Math.sin( dLon / 2 ) * Math.sin( dLon / 2 )

		c = 2 * Math.atan2( Math.sqrt( a ), Math.sqrt( 1 - a ) )
		d = R * c
		
		return d
		

	deg2rad: ( deg ) ->

		return deg * ( Math.PI / 180 )



