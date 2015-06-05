class @HomeView

	constructor: ->

		do @login

		Template.home.helpers

			active_users: ->

				return Meteor.users.find().fetch().length


	login: ->

		Template.login.events
			
			'touchstart .login, click .login': ->

				do Meteor.loginWithFacebook