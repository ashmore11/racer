class @SettingsView

	coords: null
	updates: 0
	map: null

	constructor: ->

		Template.settings.events

			'touchstart .logout': ->

				do Meteor.logout

		Template.settings.rendered = =>

			Tracker.autorun () =>

				@geoloc = do Geolocation.currentLocation

				do @init if @geoloc


	init: ->

		@updates++

		@coords =
			accuracy  : Math.floor @geoloc.coords.accuracy
			latitude  : @geoloc.coords.latitude
			longitude : @geoloc.coords.longitude
			speed     : Math.floor( @geoloc.coords.speed * 3.6 ) or 0
			date      : new Date @geoloc.timestamp

		do @update_stats

		if @map
		
			do @update_map 
		
		else

			google.maps.event.addDomListener window, 'load', do @init_map


	update_stats: ->

		stats       = $ '#stats'
		accuracy    = 'ACCURACY: '    + @coords.accuracy + ' Meters'
		speed       = 'SPEED: '       + @coords.speed + ' kph'
		distance    = 'DISTANCE: '    + ( @distance or '0.00' ) + ' km'
		last_update = 'LAST UPDATE: ' + @get_date_and_time().time
		updates     = 'UPDATES: '     + @updates

		stats.find('.accuracy').html accuracy
		stats.find('.speed').html speed
		stats.find('.distance').html distance
		stats.find('.last_update').html last_update
		stats.find('.updates').html updates


	init_map: ->

		map_canvas = document.getElementById 'map_canvas'

		map_options =
			mapTypeId        : google.maps.MapTypeId.MAP
			disableDefaultUI : true
			zoomControl      : true
			zoom             : 16

		@map = new google.maps.Map map_canvas, map_options

		do @create_path


	create_path: ->

		path_coord = new google.maps.LatLng @coords.latitude, @coords.longitude

		@path = new google.maps.Polyline
			path          : [ path_coord ]
			clickable     : false
			geodesic      : true
			strokeColor   : '#00FF00'
			strokeOpacity : 0.75
			strokeWeight  : 7

		@path.setMap @map

		@map.setCenter path_coord

		
	update_map: ->

		path = do @path.getPath

		new_path_coord = new google.maps.LatLng @coords.latitude, @coords.longitude
		
		path.push new_path_coord

		@path.setPath path

		@map.panTo new_path_coord

		distance  = google.maps.geometry.spherical.computeLength( path )
		@distance = ( distance * 0.001 ).toFixed 2


	get_date_and_time: ->

		months = [ "January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December" ]
		date   = @coords.date.getDay() + ' ' + months[@coords.date.getMonth()] + ' ' + @coords.date.getFullYear()
		
		if @coords.date.getMinutes() < 10
			minutes = '0' + @coords.date.getMinutes()
		else
			minutes = @coords.date.getMinutes()

		if @coords.date.getSeconds() < 10
			seconds = '0' + @coords.date.getSeconds()
		else
			seconds = @coords.date.getSeconds()

		time   = @coords.date.getHours() + ':' + minutes + ':' + seconds

		return {
			date: date
			time: time
		}
