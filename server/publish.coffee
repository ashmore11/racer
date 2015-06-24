Meteor.publish 'user',  -> return Meteor.users.find @userId
Meteor.publish 'users', -> return Meteor.users.find {}, fields: username: 1, profile: 1
Meteor.publish 'races', -> return RaceList.find {}, sort: createdAt: 1