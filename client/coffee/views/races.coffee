class @RacesView

	constructor: ->

		Template.races.helpers

			races: ->

				return RaceList.find( live: $not: true ).fetch()

			hours: ->

				race = RaceList.findOne @_id

				Date.prototype.addHours = ( h ) ->
					
					@setHours @getHours() + h
					
					return @

				hours = new Date().addHours ( race.index + 1 )
				hours = do hours.getHours

				return hours

		Template.races.events

			'click .race': ( event ) ->

				Router.go '/races/' + @_id