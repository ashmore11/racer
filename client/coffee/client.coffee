class @Client

	constructor: ->

		Tracker.autorun () =>

			Meteor.subscribe 'user'
			Meteor.subscribe 'users'
			Meteor.subscribe 'races'

			do @updateUser

		do @bindHeader
		do @generateViews

		GoogleMaps.load v: 3, libraries: 'geometry'


	generateViews: ->

		homeView     = new HomeView
		racesView    = new RacesView
		raceView     = new RaceView
		raceUserView = new RaceUserView
		

	updateUser: ->

		if Meteor.userId()

			user      = Meteor.users.findOne Meteor.userId()
			firstName = user?.services?.facebook.first_name
			fbId      = user?.services?.facebook.id
			imgSrc    = "http://graph.facebook.com/" + fbId + "/picture/?type=large"

			Meteor.users.update Meteor.userId(), 
				$set: 
					'profile.image'      : imgSrc
					'profile.firstName'  : firstName
					'profile.racePoints' : 0


	bindHeader: ->

		Template.header.helpers

			active: => 

				if @navActive() then 'active' else ''

			routeIsHome: ->

				return Router.current().route.getName() is 'home'

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

				Session.set 'router:back', true

	navActive: -> Session.get 'nav:active'
	setTrue: ->   Session.set 'nav:active', true
	setFalse: ->  Session.set 'nav:active', false

	
