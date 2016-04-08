###Flickr-Images by Romit M

Flickr images is program to load images using Flickr web service. I have write category of UIImageView to load image from given ur. Also i have used UICollectionView to display multiple images. you can check ViewTransition class to open animation of details screen from UICollectionView.

Before you run Project change FlickrAPIKey. You can find in WebService class.
```objective-c
NSString *const FlickrAPIKey = FLICKR_API_KEY_HERE;
```

[Get Flickr api key](https://www.flickr.com/services/api/misc.api_keys.html)

###Classes
===========
AppDelegate
WebService
ViewController    		-> First Root Controller in Navigation Controller.
DetailsViewController 	-> Open with you touch any image in the list
ViewTransition 			-> Perform to zoom animation. 
PhotoCell				-> Used as Collection photo cell
Photo					-> Model pbject to store photo details like image url, title, id.
UIImageView+Url			-> category to donload image from url & cache to local disk to load fast.

###What you can improve.
=====================
You can add pull to refresh
Load more if user scroll down

Note:This  prject does not have dynamic values. because of testing purpose only. 
