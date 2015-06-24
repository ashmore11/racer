App.info({
  id: 'com.example.scott.racer',
  name: 'racer',
  description: 'Multiplayer racing app',
  author: 'Scott Ashmore',
  email: 'contact@example.com',
  website: 'http://example.com'
});

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

App.setPreference('BackgroundColor', '0xff0000ff');
App.setPreference('HideKeyboardFormAccessoryBar', true);
App.setPreference('StatusBarOverlaysWebView', 'false');
App.setPreference('StatusBarStyle', 'lightcontent');
App.setPreference('StatusBarBackgroundColor', '#111111');

App.configurePlugin('com.phonegap.plugins.facebookconnect', {
  APP_ID: '1603566783252297',
  APP_NAME: 'racer'
});

App.accessRule('*');
App.accessRule('https://*.googleapis.com/*');
App.accessRule('https://*.google.com/*');
App.accessRule('https://*.gstatic.com/*');
App.accessRule('http://*.facebook.com/*');