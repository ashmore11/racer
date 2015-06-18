class @RacesView

	constructor: ->

		countdownDep = new Deps.Dependency
		countdown    = null

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

			countdown: ->

				race = RaceList.findOne @_id

				do countdownDep.depend

				if countdown

					if race.index > 0
						
						return race.index + 'h ' + countdown

					else

						return countdown

			competitors: ->

				return RaceList.findOne( @_id ).users.length

		Template.races.created = ->

			countdownInterval = Meteor.setInterval( =>

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

			, 1000 )

		Template.races.rendered = =>

			$(window).on 'resize', => do @on_resize

			do @on_resize

		Template.races.destroyed = ->

			Meteor.clearInterval countdownInterval

			countdownInterval = null

		Template.races.events

			'click .race': ( event ) ->

				Router.go '/races/' + @_id


	on_resize: =>

		height = ( $(window).height() - $('.top-bar').height() ) / ( RaceList.find().fetch().length - 1 )
		height = height - 4

		$('.race').height height

		$( $('.race')[$('.race').length - 1] ).height height + 2