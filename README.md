CLImageViewer
======================

A light weight, easy to use and cool image viewer for iOS.  
It provides:  

- Support both local and web image.  
- Double tap and pinch to zoom, single tap to dismiss.  
- Support two kinds of animation to dismiss image back to the original location.  

## Screenshot

![](demogif/example1.gif) ![](demogif/example2.gif)  

## How To Use?

Usage is simple. Here's what your simplest implementation might look like:   

```objc
    - (void)onSomeImageClicked:(id)sender {
        NSMutableArray* imageUrls = [NSMutableArray new];
        NSMutableArray* placeHoldeImages = [NSMutableArray new];
        NSMutableArray* referenceRects = [NSMutableArray new];
        NSUInteger imageIndex = 0;
        UIView* referenceView = nil;
        
        //configure your imageUrls, placeHoldeImages, referenceRects, imageIndex and referenceView
        //...
        
        CLImageViewer* imagesViewer = [CLImageViewer new];
        CLImageInfo* imagesInfo = [CLImageInfo new];
        imagesInfo.imageURLs = imageUrls;
        imagesInfo.placeholderImages = placeHoldeImages;
        imagesInfo.referenceView = referenceView;
        imagesInfo.referenceRects = referenceRects;
        imagesInfo.startImageIndex = imageIndex;
        
        imagesViewer.imageInfo = imagesInfo;
        imagesViewer.fromController = weakSelf;
        [imagesViewer showImageViewFromOriginPosition];
	}
```

Further details can be found in CLImageViewerDemo.  
That's it.  

## How to Install？

There are two ways to use CLImageViewer in your project:  

- using Cocoapods, `pod 'CLImageViewer'`  
- copying all the files into your project  

## Tips

- **Just Local Images:**   
	If you don't have the web image already, just set the `placeholderImages` property when setting up the `CLImageInfo` instance, do not set the `imageURLs` property.  

- **Auto Sroll To Original Location:**  
	In some cases, the original location of the image you are watching is out of the screen.   

	This situation, you can set `needSrollToOrigin` property to `YES` when setting up the `CLImageInfo` instance. At the same time the `referenceRects` property should be add just one element which value is from the first opened image.  

	After this, when you single tap any image you are watching, the images list will auto scroll to the image which you first opened, then back to it's original location.  

## Future Enhancements

- Optimizing Performance  
- Simplify the interface  

## License
MIT License, see the included file.  
