class @HomeView

	constructor: ->

		do @events
		do @helpers
		do @rendered


	helpers: ->

		Template.home.helpers

			active_users: ->

				return Meteor.users.find().fetch().length


	events: ->

		Template.login.events
			
			'click .login': ->

				do Meteor.loginWithFacebook


	rendered: ->

		Template.home.rendered = ->

			#