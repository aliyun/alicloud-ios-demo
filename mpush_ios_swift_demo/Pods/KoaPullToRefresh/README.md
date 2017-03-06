KoaPullToRefresh [![Build Status](https://travis-ci.org/sergigracia/KoaPullToRefresh.png)](https://travis-ci.org/sergigracia/KoaPullToRefresh)
================
KoaPullToRefresh is a minimal & easily customizable pull-to-refresh control. You can change the font, colors, size and even replace the spinning icon using FontAwesome. This library is very easy to add and customize. This pull to refresh control is developed for [Teambox](http://teambox.com) and is based on the [SVPullToRefresh](https://github.com/samvermette/SVPullToRefresh) and use [ios-fontawesome](https://github.com/alexdrone/ios-fontawesome) to work with font awesome icons.

![](https://raw.github.com/sergigracia/KoaPullToRefresh/master/Resources/animatedDemo.gif)

Installation
============
### From CocoaPods
1. Add ```pod 'KoaPullToRefresh'``` to your Podfile.
2. Edit your app's Info.plist to contain the key: ```"Fonts provided by application"``` (```UIAppFonts```). Then add ```FontAwesome.ttf``` to the list under that key.

### Manually
1. Drag the KoaPullToRefresh/KoaPullToRefresh folder into your project.
2. Add the ```QuartCore framework``` to your project.
3. Edit your app's Info.plist to contain the key: ```"Fonts provided by application"``` (```UIAppFonts```). Then add ```FontAwesome.ttf``` to the list under that key.
4. Import ```KoaPullToRefresh.h```.

Usage
=====
### Adding KoaPullToRefresh
Add this in your ```viewDidLoad```:

```objective-c
[tableView addPullToRefreshWithActionHandler:^{
	// Tasks to do on refresh. Update datasource, add rows, …
	// Call [tableView.pullToRefreshView stopAnimating] when done.
}];
```

Adding background color:

```objective-c
[tableView addPullToRefreshWithActionHandler:^{
	// Tasks to do on refresh. Update datasource, add rows, …
	// Call [tableView.pullToRefreshView stopAnimating] when done.
} withBackgroundColor:[UIColor blueColor]];
```

Adding the height of showed pixels:

```objective-c
[tableView addPullToRefreshWithActionHandler:^{
	// Tasks to do on refresh. Update datasource, add rows, …
	// Call [tableView.pullToRefreshView stopAnimating] when done.
} withBackgroundColor:[UIColor blueColor] withPullToRefreshHeightShowed:2];
```

### Customize KoaPullToRefresh

Set the color of fontAwesome icon and text:

```objective-c
[self.tableView.pullToRefreshView setTextColor:[UIColor whiteColor]];
```

Set the text font:

```objective-c
[self.tableView.pullToRefreshView setTextFont:[UIFont fontWithName:@"OpenSans-Bold" size:14]];
```

Set the font awesome icon:

```objective-c
[self.tableView.pullToRefreshView setFontAwesomeIcon:@"icon-refresh"];
```

Set titles:

```objective-c
[self.tableView.pullToRefreshView setTitle:@"Pull" forState:KoaPullToRefreshStateStopped];
[self.tableView.pullToRefreshView setTitle:@"Release" forState:KoaPullToRefreshStateTriggered];
[self.tableView.pullToRefreshView setTitle:@"Loading" forState:KoaPullToRefreshStateLoading];
```

### Manage KoaPullToRefresh

Start animating KoaPullToRefresh (```viewDidLoad```)

```objective-c
[self.tableView.pullToRefreshView startAnimating];
```

Stop animating KoaPullToRefresh

```objective-c
[self.tableView.pullToRefreshView stopAnimating];
```

Requirements
============
* iOS >= 5.0
* ARC

Contact
=======
* Sergi Gracia: sergigram@gmail.com
* Polina Flegontovna: polina.flegontovna@gmail.com

License
=======
KoaPullToRefresh is available under the MIT License. See the License file for more info.

[![githalytics.com alpha](https://cruel-carlota.pagodabox.com/a2cc0b866193ddfa6f06c859bc7ef2ec "githalytics.com")](http://githalytics.com/sergigracia/KoaPullToRefresh)
