class @RaceView

	geoloc  : null
	coords  : null
	map     : null
	path    : null

	constructor: ->

		do @template_rendered
		do @template_helpers
		do @template_events


	template_helpers: ->

		Template.join_race.helpers

			user_in_race: ->

				return RaceList.find( _id: @_id, users: $elemMatch: _id: Meteor.userId() ).fetch().length > 0

		Template.race.helpers

			accuracy: =>

				return Geolocation.currentLocation()?.coords.accuracy or 0

			speed: =>

				return Math.floor( Geolocation.currentLocation()?.coords.speed * 3.6 ) or 0


	template_events: ->

		Template.join_race.events

			'click .join-race-btn': ( event ) ->

				do event.stopPropagation

				if RaceList.find( _id: @_id, users: $elemMatch: _id: Meteor.userId() ).fetch().length > 0

					RaceList.update @_id, $pull: users: Meteor.user()

				else

					RaceList.update @_id, $push: users: Meteor.user()


	template_rendered: ->

		Template.race.rendered = =>

			Tracker.autorun () =>

				@geoloc = do Geolocation.currentLocation

				do @init if @geoloc


	init: ->

		@coords =
			accuracy  : Math.floor @geoloc.coords.accuracy
			latitude  : @geoloc.coords.latitude
			longitude : @geoloc.coords.longitude
			speed     : Math.floor( @geoloc.coords.speed * 3.6 ) or 0

		if @map
		
			do @update_map 
			
		else

			google.maps.event.addDomListener window, 'load', do @init_map


	init_map: ->

		map_canvas = document.getElementById 'map_canvas'

		map_options =
			mapTypeId        : google.maps.MapTypeId.MAP
			disableDefaultUI : true
			zoomControl      : false
			zoom             : 16

		@map = new google.maps.Map map_canvas, map_options

		google.maps.event.addListenerOnce @map, 'tilesloaded', ->

			$('.map').addClass 'loaded'

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

		distance = google.maps.geometry.spherical.computeLength( path )
		distance = ( distance * 0.001 ).toFixed 2

		Meteor.call 'update_distance', Session.get('race_id'), Meteor.userId(), distance
