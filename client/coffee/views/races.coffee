class @RacesView

	constructor: ->

		Template.races.events

			'click .race': ->

				exists = Race.find( 'user._id': Meteor.userId() ).fetch().length > 0

				i = 0

				if exists

					console.log 'your already in the race'

					Router.go '/races/' + Race.find().fetch()[i]._id

				else

					Race.insert

						user: Meteor.users.findOne Meteor.userId()

					Router.go '/races/' + Race.find().fetch()[i]._id