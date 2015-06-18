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
		@route '/races',
			
			action: ->

				return unless @ready()

				@render 'races'

		### 
		@ROUTE RACE PREVIEW
		###
		@route '/races/:race_id',
			
			data: -> 

				RaceList.findOne _id: @params.race_id

			action: ->
			
				return unless @ready()

				Session.set 'current:race:id', @params.race_id

				@render 'race'

		### 
		@ROUTE RACE USER MAP
		###
		@route '/races/:raceId/:userId',
			
			data: -> 

				race: RaceList.findOne _id: @params.raceId

			action: ->
			
				return unless @ready()

				@render 'raceUser'

