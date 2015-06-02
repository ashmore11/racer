class @HomeView

	constructor: ->

		do @login_with_facebook

		Template.home.rendered = ->

			@index = 0

			Tracker.autorun () =>

				@index++

				geoloc = Geolocation.currentLocation()

				if geoloc

					coords =
						accuracy  : geoloc.coords.accuracy
						heading   : geoloc.coords.heading or 0
						latitude  : geoloc.coords.latitude
						longitude : geoloc.coords.longitude
						speed     : geoloc.coords.speed or 0

					$('#stats').find('.accuracy').html( 'acc: ' + coords.accuracy )
					$('#stats').find('.lat').html( 'lat: ' + coords.latitude )
					$('#stats').find('.lon').html( 'lon: ' + coords.longitude )
					$('#stats').find('.speed').html( 'speed: ' + ( Math.floor( coords.speed * 3.6 ) ) + ' KPH' )
					$('#stats').find('.index').html( 'index: ' + @index )

					if coords.heading > 315 and coords.heading < 45
						compass = 'NORTH'

					if coords.heading > 45 and coords.heading < 135
						compass = 'EAST'

					if coords.heading > 135 and coords.heading < 225
						compass = 'SOUTH'

					if coords.heading > 225 and coords.heading < 315
						compass = 'WEST'

					$('#stats').find('.heading').html( 'heading: ' + compass )


	login_with_facebook: ->

		Template.login.events
			
			'click .fa-facebook': ->

				do Meteor.loginWithFacebook