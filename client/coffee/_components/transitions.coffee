class @Transitions

	constructor: ->

		hooks =

			transitioning: false

			insertElement: ( node, next ) ->

				insert = ->

					console.log 'insert', node, next
					
					$( node ).addClass 'slideInRight'
					
					$( node ).insertBefore next
					
					Meteor.setTimeout finish, 1000

				finish = ->

					$( node ).removeClass 'slideInRight'

				if @transitioning
					Meteor.setTimeout insert, 1000
				else
					insert()

			removeElement: ( node ) ->

				console.log node

				remove = =>

					@transitioning = false

					$( node ).remove()

				$( node ).addClass 'slideOutRight'

				@transitioning = true

				Meteor.setTimeout remove, 1000

		Template.transition.rendered = ->

			@firstNode.parentNode._uihooks = hooks