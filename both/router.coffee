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

		### 
		@ROUTE HOME
		###
		@route 'home',
			path: '/'
			
			action: ->
				
				return unless @ready()
				
				@render 'home'

		### 
		@ROUTE RACES
		###
		@route 'races',
			path: '/races'
			
			action: ->

				return unless @ready()

				@render 'races'

		### 
		@ROUTE RACE
		###
		@route 'race',
			path: '/races/:race_id'
			
			data: -> 

				RaceList.findOne _id: @params.race_id
			
			onBeforeAction: ->
				
				do GoogleMaps.load
				
				do @next

			action: ->
			
				return unless @ready()

				Session.set 'current:race:id', @params.race_id

				@render 'race'

		### 
		@ROUTE RACE USER
		###
		@route 'race_user',
			path: '/races/:raceId/:userId'
			
			data: -> 

				race: RaceList.findOne _id: @params.raceId
			
			onBeforeAction: ->
				
				do GoogleMaps.load
				
				do @next

			action: ->
			
				return unless @ready()

				@render 'raceUser'

