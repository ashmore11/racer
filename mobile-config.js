App.info({
  id: 'com.example.scott.racer',
  name: 'racer',
  description: 'Multiplayer racing app',
  author: 'Scott Ashmore',
  email: 'contact@example.com',
  website: 'http://example.com'
});

App.icons({
  // iOS
  'iphone'    : 'resources/icons/iPhone4s@2x.png',
  'iphone_2x' : 'resources/icons/iPhone6&5@2x.png',
  'iphone_3x' : 'resources/icons/iPhone6Plus@3x.png',
  'ipad'      : 'resources/icons/iPad2&iPadMini@1x.png',
  'ipad_2x'   : 'resources/icons/iPad&iPadMini@2x.png' //,

  // Android
  // 'android_ldpi': 'resources/icons/icon-36x36.png',
  // 'android_mdpi': 'resources/icons/icon-48x48.png',
  // 'android_hdpi': 'resources/icons/icon-72x72.png',
  // 'android_xhdpi': 'resources/icons/icon-96x96.png'
});

// App.launchScreens({
//   // iOS
//   'iphone': 'resources/splash/splash-320x480.png',
//   'iphone_2x': 'resources/splash/splash-320x480@2x.png',
//   'iphone5': 'resources/splash/splash-320x568@2x.png',
//   'iphone6': 'resources/splash/splash-375x667@2x.png',
//   'iphone6p_portrait': 'resources/splash/splash-414x736@3x.png',
//   'iphone6p_landscape': 'resources/splash/splash-736x414@3x.png',

//   'ipad_portrait': 'resources/splash/splash-768x1024.png',
//   'ipad_portrait_2x': 'resources/splash/splash-768x1024@2x.png',
//   'ipad_landscape': 'resources/splash/splash-1024x768.png',
//   'ipad_landscape_2x': 'resources/splash/splash-1024x768@2x.png',

//   // Android
//   'android_ldpi_portrait': 'resources/splash/splash-200x320.png',
//   'android_ldpi_landscape': 'resources/splash/splash-320x200.png',
//   'android_mdpi_portrait': 'resources/splash/splash-320x480.png',
//   'android_mdpi_landscape': 'resources/splash/splash-480x320.png',
//   'android_hdpi_portrait': 'resources/splash/splash-480x800.png',
//   'android_hdpi_landscape': 'resources/splash/splash-800x480.png',
//   'android_xhdpi_portrait': 'resources/splash/splash-720x1280.png',
//   'android_xhdpi_landscape': 'resources/splash/splash-1280x720.png'
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