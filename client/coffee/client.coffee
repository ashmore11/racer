class @Client

	constructor: ->

		Tracker.autorun =>

			Meteor.subscribe 'user'
			Meteor.subscribe 'users'
			Meteor.subscribe 'races'

			do @update_user

		do @set_false
		do @bind_header
		do @generate_views


	generate_views: ->

		window.home_view     = new HomeView
		window.settings_view = new SettingsView
		window.races_view    = new RacesView
		window.race_view     = new RaceView
		

	update_user: ->

		if Meteor.userId()

			user    = Meteor.users.findOne Meteor.userId()
			fb_id   = user.services?.facebook.id
			img_src = "http://graph.facebook.com/" + fb_id + "/picture/?type=large"

			Meteor.users.update Meteor.userId(), $set: 'profile.image': img_src

	bind_header: ->

		Template.header.helpers

			active: => if @nav_active() then 'active' else ''

		Template.header.events

			'click .nav_cta': =>
				
				do event.preventDefault
				do event.stopPropagation

				if @nav_active() then @set_false() else @set_true()

			'click a' : =>
				
				do event.preventDefault
				do event.stopPropagation

				Router.go event.target.attributes[0].value

				do @set_false

	nav_active: -> Session.equals 'nav_active', true
	set_true: ->   Session.set 'nav_active',    true
	set_false: ->  Session.set 'nav_active',    false