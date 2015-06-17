// This section sets up some basic app metadata,
// the entire section is optional.
App.info({
  id: 'com.example.scott.racer',
  name: 'racer',
  description: 'Multiplayer racing app',
  author: 'Scott Ashmore',
  email: 'contact@example.com',
  website: 'http://example.com'
});

// // Set up resources such as icons and launch screens.
// App.icons({
//   'iphone': 'icons/icon-60.png',
//   'iphone_2x': 'icons/icon-60@2x.png',
//   // ... more screen sizes and platforms ...
// });

// App.launchScreens({
//   'iphone': 'splash/Default~iphone.png',
//   'iphone_2x': 'splash/Default@2x~iphone.png',
//   // ... more screen sizes and platforms ...
// });

// Set PhoneGap/Cordova preferences
App.setPreference('BackgroundColor', '0xff0000ff');
App.setPreference('HideKeyboardFormAccessoryBar', true);

// Pass preferences for a particular PhoneGap/Cordova plugin
App.configurePlugin('com.phonegap.plugins.facebookconnect', {
  APP_ID: '1603566783252297',
  API_KEY: '745ab6b368130965d6c7dd2aa4530a49',
  APP_NAME: 'racer'
});

App.accessRule('https://*.googleapis.com/*');
App.accessRule('https://*.google.com/*');
App.accessRule('https://*.gstatic.com/*');