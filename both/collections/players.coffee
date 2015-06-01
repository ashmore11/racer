@PlayerList = new Meteor.Collection 'players'

@PlayerList.insert 
	location: null