class @AppRouter

	Router.configure

		loadingTemplate  : 'loading'
		layoutTemplate   : 'layout'
		notFoundTemplate : '404'

		waitOn: ->
			
			Meteor.subscribe 'user'
			Meteor.subscribe 'users'
			Meteor.subscribe 'races'

	Router.map ->

		@route 'home',
			path   : '/'
			action : ->
				return unless @ready()

				view = new HomeView
				
				@render 'home'


		@route 'settings',
			path   : '/settings'
			action : ->
				return unless @ready()
				
				view = new SettingsView

				@render 'settings'


		@route 'races',
			path   : '/races'
			action : ->
				return unless @ready()
				
				view = new RacesView

				@render 'races'


		@route 'race',
			path   : '/races/:id'
			action : ->
				return unless @ready()
				
				view = new RaceView @params.id

				@render 'race'	