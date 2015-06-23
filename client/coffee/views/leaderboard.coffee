class @LeaderboardView

	constructor: ->

		Template.leaderboard.helpers

			users: ->

				Meteor.users.find {}, sort: 'profile.points': -1

			rank: ->

				for item, i in Meteor.users.find().fetch()

					if item._id is @_id

						index = i + 1

						break

				return index