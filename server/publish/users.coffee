Meteor.publish 'user',  -> Meteor.users.find @userId
Meteor.publish 'users', -> Meteor.users.find {}, fields: profile: 1