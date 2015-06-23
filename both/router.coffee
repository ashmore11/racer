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

		onAfterAction: ->

			# if Session.get 'router:back'
			
			# 	animationClass = 'slideInRight'
			
			# 	Session.set 'router:back', false
			
			# else

			# 	animationClass = 'slideInLeft'

			# $('.container').addClass animationClass

			# Meteor.setTimeout( ->

			# 	$('.container').removeClass animationClass

			# , 1000 )


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
		@ROUTE RACE LIST
		###
		@route 'races',
			path: '/races'
			
			action: ->

				return unless @ready()

				@render 'races'

		### 
		@ROUTE RACE PREVIEW
		###
		@route 'race',
			path: '/races/:race_id'
			
			data: -> 

				RaceList.findOne _id: @params.race_id

			onBeforeAction: ->

				if RaceList.findOne( _id: @params.race_id )?

					do @next

				else

					do @stop

					@redirect '/'

			action: ->
			
				return unless @ready()

				GoogleMaps.load v: 3, libraries: 'geometry'

				Session.set 'current:race:id', @params.race_id

				@render 'race'

		### 
		@ROUTE LEADERBOARD
		###
		@route 'leaderboard',
			path: '/leaderboard'
			
			action: ->

				return unless @ready()

				@render 'leaderboard'

					

