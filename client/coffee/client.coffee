class @Client

	constructor: ->

		do @bindHeader
		do @generateViews

		GoogleMaps.load v: 3, libraries: 'geometry'


	generateViews: ->

		homeView  = new HomeView
		racesView = new RacesView
		raceView  = new RaceView


	bindHeader: ->

		Template.header.helpers

			active: => 

				if @navActive() then 'active' else ''

			routeIsHome: ->

				return Router.current().route.getName() is 'home'

			hasUsername: ->

				return Meteor.user().profile.username?

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

			'click .logout': =>

				do @setFalse

				Meteor.logout ( err ) ->

					if err then throw new Meteor.Error 'Logout failed'

	navActive: -> Session.get 'nav:active'
	setTrue: ->   Session.set 'nav:active', true
	setFalse: ->  Session.set 'nav:active', false

	
