class @Client

	constructor: ->

		window.pathCoords = [] 

		Tracker.autorun =>

			Meteor.subscribe 'user'
			Meteor.subscribe 'users'
			Meteor.subscribe 'races'

			do @updateUser
			do @updateCoords if Geolocation.currentLocation()

		do @setFalse
		do @bindHeader
		do @generateViews

		Session.set 'map:loaded', false

		GoogleMaps.load v: 3, libraries: 'geometry'


	generateViews: ->

		homeView     = new HomeView
		settingsView = new SettingsView
		racesView    = new RacesView
		raceView     = new RaceView
		raceUserView = new RaceUserView
		

	updateUser: ->

		if Meteor.userId()

			user   = Meteor.users.findOne Meteor.userId()
			fbId   = user?.services?.facebook.id
			imgSrc = "http://graph.facebook.com/" + fbId + "/picture/?type=large"

			Meteor.users.update Meteor.userId(), $set: 'profile.image': imgSrc


	updateCoords: ->

		lat = Geolocation.currentLocation().coords.latitude
		lon = Geolocation.currentLocation().coords.longitude

		coord = [ lat, lon ]

		window.pathCoords.push coord


	bindHeader: ->

		Template.header.helpers

			active: => if @navActive() then 'active' else ''

		Template.header.events

			'click .nav_cta': =>

				if @navActive() then @setFalse() else @setTrue()

			'click a': =>
				
				do event.preventDefault

				Router.go event.target.attributes[0].value

				do @setFalse

			'click .back': =>

				do history.back
				do @setFalse

	navActive: -> Session.equals 'nav_active', true
	setTrue: ->   Session.set 'nav_active',    true
	setFalse: ->  Session.set 'nav_active',    false