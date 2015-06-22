class @RacesView

	constructor: ->

		countdownDep = new Deps.Dependency
		countdown    = null

		Date.prototype.addHours = ( h ) ->
					
			@setHours @getHours() + h
			
			return @				

		Template.races.helpers

			races: ->

				return RaceList.find live: $not: true

			hours: ->

				return if RaceList.findOne( @_id ).live is true

				index = 0
				id    = RaceList.findOne( @_id )._id

				for item, i in RaceList.find().fetch()

					if item._id is id

						index = i

						break

				hours = new Date().addHours index
				hours = do hours.getHours

				return hours

			countdown: ->

				index = 0
				id    = RaceList.findOne( @_id )._id

				for item, i in RaceList.find().fetch()

					if item._id is id

						index = i - 1

						break

				do countdownDep.depend

				if countdown

					if index > 0
						
						return index + 'h ' + countdown

					else

						return countdown

			competitors: ->

				return RaceList.findOne( @_id ).users.length

		Template.races.created = ->

			countdownInterval = _interval 1000, =>

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

				countdown = mins + 'm ' + secs + 's'

				do countdownDep.changed

		Template.races.rendered = =>

			$('ul.races').height ( $(window).height() - $('.top-bar').height() ) - 5

		Template.races.destroyed = ->

			Meteor.clearInterval countdownInterval

			countdownInterval = null

		Template.races.events

			'click .race': ( event ) ->

				Router.go '/races/' + @_id
