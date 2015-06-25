Meteor.publish 'user',  -> return Meteor.users.find @userId
Meteor.publish 'users', -> return Meteor.users.find {}, fields: profile: 1
Meteor.publish 'races', -> return RaceList.find {}, sort: createdAt: 1