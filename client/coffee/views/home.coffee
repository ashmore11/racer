class @HomeView

	constructor: ->

		do @events
		do @helpers

		Date.prototype.addHours = ( h ) ->
					
			@setHours @getHours() + h
			
			return @


	helpers: ->

		Template.home.helpers

			noUsername: ->

				return !Meteor.user().profile.username?

			userIsInRaces: ->

				return RaceList.find( users: Meteor.userId() ).count() > 0

			usersRaces: ->

				return RaceList.find users: Meteor.userId()

			raceTime: ->

				id = RaceList.findOne( @_id )._id

				for item, i in RaceList.find().fetch()

					if item._id is id

						index = i

						break

				hours = new Date().addHours index
				hours = do hours.getHours

				return hours

			rank: ->

				query =
					sort: 'profile.points': -1

				for user, i in Meteor.users.find( {}, query ).fetch()

					if user._id is Meteor.userId()

						rank = i + 1

						break

				return rank

			avatar: ->

				return "https://graph.facebook.com/" + Meteor.user().profile.id + "/picture/?type=large"


	events: ->

		Template.home.events
			
			###
			FACEBOOK LOGIN
			###
			'click .login-btn': =>

				if Meteor.isCordova

					do @nativeLogin

				else

					Meteor.loginWithFacebook {}, ( err, result ) ->

						if err then throw new Meteor.Error 'Facebook login failed'

						firstName = Meteor.user().services.facebook.first_name
						fbId      = Meteor.user().services.facebook.id
						imgSrc    = "https://graph.facebook.com/" + fbId + "/picture/?type=large"

						Meteor.call 'updateUser', imgSrc, firstName

			###
			SHARE ON FACEBOOK
			###
			'click .share-btn': ( event ) ->

				do event.preventDefault

				if Meteor.isCordova

					message = 'Check out the racer app. Race me in real time!'
					img     = null
					link    = "https://geo.itunes.apple.com/gb/app/nike+-running/id387771637?mt=8&uo=6"
					success = -> console.log '[ SHARE SUCCESS ]'
					error   = ( err ) -> console.log '[ SHARE ERROR ] ~>', err

					plugins.socialsharing.shareViaFacebook message, img, link, success, error

				else

					console.log '[ NOT CORDOVA ]'

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
				nameExists = Meteor.users.find( 'profile.username': name ).fetch().length > 0

				if $('button').hasClass 'disabled'

					charToGo = 6 - name.length 

					alert = "Your username must be at least 6 characters. Only another #{charToGo} character(s) to go!"

					@animateAlertBox alert

				else

					if nameExists

						alert = 'This name is already taken. <br> Please choose another.'

						@animateAlertBox alert

					else

						Meteor.call 'setUsernameAndPoints', name


	nativeLogin: ->

		options = {}

		if Accounts.ui._options.requestPermissions[ 'facebook' ]

			permissions = Accounts.ui._options.requestPermissions[ 'facebook' ]
		
			options.requestPermissions = permissions

		if Accounts.ui._options.requestOfflineToken[ 'facebook' ]

			token = Accounts.ui._options.requestOfflineToken[ 'facebook' ]
		
			options.requestOfflineToken = token

		Meteor.loginWithFacebook options, ( err, result ) ->

			if err then throw new Meteor.Error 'Facebook login failed'

			Meteor.call 'getFriends'


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
