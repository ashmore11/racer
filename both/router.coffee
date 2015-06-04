class @AppRouter

	Router.configure

		loadingTemplate  : 'loading'
		layoutTemplate   : 'layout'
		notFoundTemplate : '404'

		waitOn: ->
			
			Meteor.subscribe 'user'
			Meteor.subscribe 'users'

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