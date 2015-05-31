# Root path
@base_path = Meteor.absoluteUrl replaceLocalhost: true

# Timers
@delay = ( delay, func ) -> setTimeout  func, delay
@loop  = ( delay, func ) -> setInterval func, delay

# Start the app
Meteor.startup ->
	if Meteor.isServer then new Server
	if Meteor.isClient then new Client