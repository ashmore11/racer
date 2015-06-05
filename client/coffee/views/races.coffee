class @RacesView

	constructor: ->

		Template.races.helpers

			race_id: ->

				return do Random.id

		Template.races.events

			'click .race': ->

				race_id = event.target.id

				Router.go '/races/' + race_id