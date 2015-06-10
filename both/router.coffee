class @AppRouter

	Router.configure

		loadingTemplate  : 'loading'
		layoutTemplate   : 'layout'
		notFoundTemplate : '404'

		waitOn: ->
			
			Meteor.subscribe 'user'
			Meteor.subscribe 'users'
			Meteor.subscribe 'races'

		onBeforeAction: ->

			if Meteor.userId()

				do @next

			else

				@redirect '/'

				do @next


	Router.map ->

		@route 'home',
			path   : '/'
			action : ->
				return unless @ready()
				
				@render 'home'


		@route 'settings',
			path   : '/settings'
			action : ->
				return unless @ready()

				@render 'settings'


		@route 'races',
			path   : '/races'
			action : ->
				return unless @ready()

				@render 'races'


		@route 'race',
			path   : '/races/:id'
			data   : -> RaceList.findOne _id: @params.id
			action : ->
				return unless @ready()

				@render 'race'