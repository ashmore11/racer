class @HomeView

	constructor: ->

		do @events
		do @helpers

		Date.prototype.addHours = ( h ) ->
					
			@setHours @getHours() + h
			
			return @


	helpers: ->

		Template.home.helpers

			active_users: ->

				return Meteor.users.find().count()

			noUsername: ->

				return !Meteor.user().profile.username?

			userIsInRaces: ->

				return RaceList.find( users: Meteor.userId() ).count() > 0

			usersRaces: ->

				return RaceList.find users: Meteor.userId()

			raceTime: ->

				index = 0
				id    = RaceList.findOne( @_id )._id

				for item, i in RaceList.find().fetch()

					if item._id is id

						index = i

						break

				hours = new Date().addHours index
				hours = do hours.getHours

				return hours

			rank: ->

				rank = 0

				for user, i in Meteor.users.find( {}, sort: 'profile.points': -1 ).fetch()

					if user._id is Meteor.userId()

						rank = i + 1

						break

				return rank


	events: ->

		Template.home.events
			
			###
			FACEBOOK LOGIN
			###
			'click .login': ->

				Meteor.loginWithFacebook {}, ( err, result ) ->

					if err then throw new Meteor.Error 'Facebook login failed'

					firstName = Meteor.user().services.facebook.first_name
					fbId      = Meteor.user().services.facebook.id
					imgSrc    = "http://graph.facebook.com/" + fbId + "/picture/?type=large"

					Meteor.call 'updateUser', imgSrc, firstName

			###
			TEST USERNAME LENGTH
			###
			'keyup input': ( event ) ->

				if $('input').val().length >= 6

					$('button').removeClass 'disabled'

				else

					$('button').addClass 'disabled'

			###
			USERNAME VALIDATION
			###
			'submit .username': ( event ) =>

				event.preventDefault()

				name       = event.target.text.value.toUpperCase()
				nameExists = Meteor.users.find( 'profile.username' : name ).fetch().length > 0

				if $('button').hasClass 'disabled'

					charToGo = 6 - name.length 

					alert = "Your username must be at least 6 characters. Only another #{charToGo} character(s) to go!"

					@animateAlertBox alert

				else

					if nameExists

						alert = 'This name is already taken. <br> Please choose another.'

						@animateAlertBox alert

					else

						Meteor.call 'updateUsername', name


	animateAlertBox: ( alert ) ->

		el = $ '.alert-box'

		el.html alert

		TweenMax.set el, top: '45%'

		params =
			top      : '42%'
			autoAlpha: 1
			ease     : Power4.easeOut

		TweenMax.to el, 0.75, params

		_delay 3000, ->

			TweenMax.to el, 0.5, autoAlpha: 0
