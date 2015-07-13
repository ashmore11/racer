class @LeaderboardView

	constructor: ->

		Template.leaderboard.helpers

			users: ->

				query =
					sort: 'profile.points': -1

				Meteor.users.find {}, query

			rank: ->

				query =
					sort: 'profile.points': -1

				for item, i in Meteor.users.find( {}, query ).fetch()

					if item._id is @_id

						index = i + 1

						break

				return index