@PlayerList = new Meteor.Collection 'players'

stats =
	time     : null
	accuracy : null
	lat      : null
	lon      : null
	speed    : null

@PlayerList.insert
	stats: stats