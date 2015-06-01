class @Client

	constructor: ->

		Tracker.autorun ->
			Meteor.subscribe 'user'
			Meteor.subscribe 'users'

		do @set_false
		do @bind_header
		do @update_user


	update_user: ->

		geoloc = Geolocation.currentLocation()

		if Meteor.userId() and geoloc

			coords =
				accuracy  : geoloc.coords.accuracy
				heading   : geoloc.coords.heading
				latitude  : geoloc.coords.latitude
				longitude : geoloc.coords.longitude
				speed     : geoloc.coords.speed

			fb_id   = Meteor.users.findOne( Meteor.userId() ).services.facebook.id
			img_src = "http://graph.facebook.com/" + fb_id + "/picture/?type=large"

			Meteor.users.update Meteor.userId(), $set:
				'profile.coords' : coords
				'profile.image'  : img_src


	bind_header: ->

		Template.header.helpers

			active: => if Session.equals 'nav_active', true then 'active' else ''

		Template.header.events

			'touchstart .nav_cta, click .nav_cta': =>
				event.preventDefault()

				if Session.equals 'nav_active', true then @set_false() else @set_true()

			'touchstart a, click a': =>
				event.preventDefault()

				Router.go event.target.attributes[0].value

				@set_false()


	set_true: ->

		Session.set 'nav_active', true
	
	
	set_false: -> 

		Session.set 'nav_active', false