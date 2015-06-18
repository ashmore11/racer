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

				do Meteor.loginWithFacebook

			'keyup input': ( event ) ->

				name = $('input').val()

				if name.length >= 6

					$('button').removeClass 'disabled'

				else

					$('button').addClass 'disabled'

			'submit .nickname': ( event ) ->

				event.preventDefault()

				name = event.target.text.value

				unless $('input').hasClass 'disabled'

					Meteor.call 'updateNickname', name