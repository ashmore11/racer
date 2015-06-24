class @HeaderComponent

	constructor: ->

		do @helpers
		do @events


	helpers: ->

		Template.header.helpers

			active: => 

				if Session.get 'nav:active'
				
					return 'active'

				else 

					return ''

			routeIsHome: ->

				return Router.current().route.getName() is 'home'

			hasUsername: ->

				return Meteor.user().profile.username?


	events: ->

		Template.header.events

			'click .nav_cta': =>

				if Session.get 'nav:active'

					Session.set 'nav:active', false

				else

					Session.set 'nav:active', true

			'click a': =>
				
				do event.preventDefault

				Router.go event.target.attributes[0].value

				Session.set 'nav:active', false

			'click .back': =>

				if Session.get 'map:active'
					
					$('.map-container').removeClass 'active'

					Session.set 'map:active', false

				else

					do history.back

					Session.set 'nav:active', false
					Session.set 'router:back', true

			'click .logout': =>

				Session.set 'nav:active', false

				Meteor.logout ( err ) ->

					if err

						throw new Meteor.Error 'Logout failed'