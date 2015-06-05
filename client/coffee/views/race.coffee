class @RaceView

	coords: null
	updates: 0
	map: null

	constructor: ( @id ) ->

		if RaceList.find( users: $elemMatch: _id: Meteor.userId() ).fetch().length > 0
			
			Session.set 'in_race', true
		
		else
		
			Session.set 'in_race', false

		Template.race.helpers

			in_race: =>

				return @user_in_race()

		Template.race.events

			'touchstart .join-race-btn, click .join-race-btn': ( event ) =>

				do event.preventDefault
				do event.stopPropagation

				if @user_in_race()

					RaceList.update @id, $pull: users: Meteor.user()

				else

					RaceList.update @id, $push: users: Meteor.user()

		Template.race.rendered = =>

			Tracker.autorun () =>

				@geoloc = do Geolocation.currentLocation

				do @init if @geoloc


	user_in_race: -> Session.equals 'in_race', true

	init: ->

		@updates++

		@coords =
			accuracy  : Math.floor @geoloc.coords.accuracy
			latitude  : @geoloc.coords.latitude
			longitude : @geoloc.coords.longitude
			speed     : Math.floor( @geoloc.coords.speed * 3.6 ) or 0
			date      : new Date @geoloc.timestamp

		if @map
		
			do @update_map 
			do @update_distance
		
		else

			google.maps.event.addDomListener window, 'load', do @init_map


	update_distance: ->

		Meteor.users.update Meteor.userId(),
			$set: 
				'profile.distance': ( @distance or '0.00' ) + ' km'


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
