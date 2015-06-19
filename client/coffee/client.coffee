class @Client

	constructor: ->

		Tracker.autorun () =>

			# Meteor.subscribe 'user'
			# Meteor.subscribe 'users'
			# Meteor.subscribe 'races'

			do @updateUser

		do @bindHeader
		do @generateViews

		GoogleMaps.load v: 3, libraries: 'geometry'


	generateViews: ->

		homeView  = new HomeView
		racesView = new RacesView
		raceView  = new RaceView
		

	updateUser: ->

		if Meteor.userId()

			user      = Meteor.users.findOne Meteor.userId()
			firstName = user?.services?.facebook.first_name
			fbId      = user?.services?.facebook.id
			imgSrc    = "http://graph.facebook.com/" + fbId + "/picture/?type=large"

			Meteor.users.update Meteor.userId(), 
				$set: 
					'profile.image'     : imgSrc
					'profile.firstName' : firstName


	bindHeader: ->

		Template.header.helpers

			active: => 

				if @navActive() then 'active' else ''

			routeIsHome: ->

				return Router.current().route.getName() is 'home'

			hasNickname: ->

				return Meteor.user().profile.nickname?

		Template.header.events

			'click .nav_cta': =>

				if @navActive() then @setFalse() else @setTrue()

			'click a': =>
				
				do event.preventDefault

				Router.go event.target.attributes[0].value

				do @setFalse

			'click .back': =>

				if Session.get 'map:active'
					
					$('.map-container').removeClass 'active'

					Session.set 'map:active', false

				else

					do history.back
					do @setFalse

					Session.set 'router:back', true

			'click .logout': ->

				Meteor.logout ( err ) ->

					if err
						
						throw new Meteor.Error 'Logout failed'

	navActive: -> Session.get 'nav:active'
	setTrue: ->   Session.set 'nav:active', true
	setFalse: ->  Session.set 'nav:active', false

	
