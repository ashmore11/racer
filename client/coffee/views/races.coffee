class @RacesView

	constructor: ->

		Template.races.helpers

			races: ->

				return RaceList.find().fetch()

		Template.races.events

			'click .race': ( event ) ->

				do event.preventDefault
				do event.stopPropagation

				Router.go '/races/' + @_id