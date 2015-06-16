class @RacesView

	constructor: ->

		@countdownDep = new Deps.Dependency

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

			countdown: =>

				# race = RaceList.findOne @_id

				do @countdownDep.depend

				return '1hr ' + @countdown

		
		Template.races.created = =>

			do @updateCountdown

			@countdownInterval = Meteor.setInterval @updateCountdown, 1000

		Template.races.destroyed = =>

			Meteor.clearInterval @countdownInterval


		Template.races.events

			'click .race': ( event ) ->

				Router.go '/races/' + @_id


	updateCountdown: =>

		time = new Date

		mins = do time.getMinutes
		mins = ( 59 - mins ) % 60
		mins = '0' + mins if mins < 10

		secs = do time.getSeconds

		if secs != 60
			secs = ( 59 - secs ) % 60
		else
			secs = 0

		secs = '0' + secs if secs < 10

		@countdown = mins + 'm ' + secs + 's'

		do @countdownDep.changed