class @AppRouter

	Router.configure

		loadingTemplate  : 'loading'
		layoutTemplate   : 'layout'
		notFoundTemplate : '404'

		waitOn: ->

			Meteor.subscribe 'players'

	Router.map ->

		@route 'home',
			path   : '/'
			action : ->
				return unless @ready()

				view = new HomeView
				
				@render 'home'


		@route 'players',
			path   : '/players'
			data   : -> players: PlayerList.find().fetch()
			action : ->
				return unless @ready()
				
				view = new PlayerListView

				@render 'players'