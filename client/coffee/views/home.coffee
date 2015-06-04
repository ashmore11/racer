class @HomeView

	constructor: ->

		do @login_with_facebook

	login_with_facebook: ->

		Template.login.events
			
			'click .login': ->

				do Meteor.loginWithFacebook
