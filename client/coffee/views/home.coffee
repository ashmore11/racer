class @HomeView

	constructor: ->

		location = do Geolocation.currentLocation

		Template.home.events
			
			'click #home': ->

				stats =
					time     : location?.timestamp
					accuracy : location?.coords.accuracy
					lat      : location?.coords.latitude
					lon      : location?.coords.longitude
					speed    : location?.coords.speed

				PlayerList.update @_id, $set: 'stats.lat': 5

				console.log PlayerList.findOne( id: @_id ).stats