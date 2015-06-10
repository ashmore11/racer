class @RaceView

	geoloc: null
	coords: null
	map   : null
	path  : null

	constructor: ( @id ) ->

		do @set_user_in_race

		Template.race.helpers

			in_race: =>

				return @user_in_race()

		Template.race.events

			'click .join-race-btn': ( event ) =>

				event.stopPropagation()

				if @user_in_race()

					RaceList.update @id, $pull: users: Meteor.user()

					Session.set @id, false

					console.log '[ USER NOT IN RACE ] ~> ', @id

				else

					RaceList.update @id, $push: users: Meteor.user()

					Session.set @id, true

					# console.log '[ USER IN RACE ] ~> ( join-race-btn ) ~> ', @id

		Template.race.rendered = =>

			Tracker.autorun () =>

				@geoloc = do Geolocation.currentLocation

				do @init if @geoloc and @user_in_race()


	set_user_in_race: ->

		if RaceList.find( _id: @id, users: $elemMatch: _id: Meteor.userId() ).fetch().length > 0

			# console.log '[ USER IN RACE ]'
			
			Session.set @id, true
		
		else

			# console.log '[ USER NOT IN RACE ]'
		
			Session.set @id, false


	user_in_race: ->

		return Session.get @id


	init: ->

		@coords =
			accuracy  : Math.floor @geoloc.coords.accuracy
			latitude  : @geoloc.coords.latitude
			longitude : @geoloc.coords.longitude
			speed     : Math.floor( @geoloc.coords.speed * 3.6 ) or 0
			date      : new Date @geoloc.timestamp

		# if @map
		
		# 	do @update_map 
		# 	do @update_distance
		
		# else

		# 	google.maps.event.addDomListener window, 'load', do @init_map


	update_distance: ->

		Meteor.call 'update_distance', @id, Meteor.userId(), @distance


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