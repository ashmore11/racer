class @HomeView

	constructor: ->

		do @events
		do @helpers


	helpers: ->

		Template.home.helpers

			active_users: ->

				return Meteor.users.find().fetch().length

			noNickname: ->

				return !Meteor.user().profile.nickname?


	events: ->

		Template.home.events
			
			'click .login': ->

				Meteor.loginWithFacebook {}, ( err ) ->

					if err then throw new Meteor.Error 'Facebook login failed'

			'keyup input': ( event ) ->

				name = $('input').val()

				if name.length >= 6

					$('button').removeClass 'disabled'

				else

					$('button').addClass 'disabled'

			'submit .nickname': ( event ) =>

				event.preventDefault()

				name       = event.target.text.value.toUpperCase()
				nameExists = Meteor.users.find( 'profile.nickname' : name ).fetch().length > 0

				if $('button').hasClass 'disabled'

					charToGo = 6 - name.length 

					alert = "Your username must be at least 6 characters. Please add at least another #{charToGo} character(s)."

					@animateAlertBox alert

				else

					if nameExists

						alert = 'This name is already taken. <br> Please choose another.'

						@animateAlertBox alert

					else

						Meteor.call 'updateNickname', name


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