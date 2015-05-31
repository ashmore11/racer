class @Client

	constructor: ->

		Tracker.autorun ->
			
			Meteor.subscribe 'user'
			Meteor.subscribe 'users'