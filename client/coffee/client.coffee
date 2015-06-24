class @Client

	constructor: ->

		do @createComponents
		do @createViews


	createComponents: ->

		headerComponent = new HeaderComponent


	createViews: ->

		homeView        = new HomeView
		racesView       = new RacesView
		raceView        = new RaceView
		leaderboardView = new LeaderboardView

	
