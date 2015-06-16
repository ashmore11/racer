# Root path
@base_path = Meteor.absoluteUrl replaceLocalhost: true

# Timers
@_delay    = ( delay, func ) -> Meteor.setTimeout  func, delay
@_interval = ( delay, func ) -> Meteor.setInterval func, delay

# Start the app
Meteor.startup ->
	
	if Meteor.isServer

		new Server
	
	if Meteor.isClient

		@PathCoords = new Meteor.Collection null

		new Client