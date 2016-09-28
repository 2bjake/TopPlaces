//
//  PhotoScrollViewController.m
//  TopPlaces
//
//  Created by Foster, Jake on 9/26/16.
//  Copyright © 2016 Amazon. All rights reserved.
//

#import "PhotoScrollViewController.h"

@interface PhotoScrollViewController () <UIScrollViewDelegate, UISplitViewControllerDelegate>
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *spinner;
@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) UIImageView *imageView;
@property (strong, nonatomic) UIImage *image;

@end

@implementation PhotoScrollViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.splitViewController.delegate = self;
    [self.scrollView addSubview:self.imageView];
    self.scrollView.delegate = self;
    if (self.photoUrl && !self.image) {
        [self.spinner startAnimating];
    }
}

-(BOOL)splitViewController:(UISplitViewController *)splitViewController collapseSecondaryViewController:(UIViewController *)secondaryViewController ontoPrimaryViewController:(UIViewController *)primaryViewController {
    if (!self.photoUrl) {
        return YES;
    }
    return NO;
}

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    return self.imageView;
}

- (void)setPhotoUrl:(NSURL *)photoUrl {
    _photoUrl = photoUrl;
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:self.photoUrl];
    NSURLSessionConfiguration *config = [NSURLSessionConfiguration ephemeralSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:config];
    NSURLSessionDownloadTask *task =
    [session downloadTaskWithRequest:request
                   completionHandler:^(NSURL * _Nullable localFile, NSURLResponse * _Nullable response, NSError * _Nullable error) {
                       if (!error) {
                           NSData *data = [NSData dataWithContentsOfURL:localFile options:0 error:&error];
                           if (!error) {
                               dispatch_async(dispatch_get_main_queue(), ^{
                                   self.image = [UIImage imageWithData:data];
                               });
                           }
                       }
                       
                       if (error) {
                           NSLog(@"%@", error); //TODO: this is a bug, new image won't be loaded
                       }
                   }];
    [task resume];
}

- (UIImageView *)imageView {
    if (!_imageView) _imageView = [[UIImageView alloc] init];
    return _imageView;
}

- (UIImage *)image {
    return self.imageView.image;
}

- (void)setImage:(UIImage *)image {
    [self.spinner stopAnimating];
    self.imageView.image = image;
    [self.imageView sizeToFit];
    self.scrollView.contentSize = self.image ? self.image.size : CGSizeZero;
    [self.scrollView zoomToRect:CGRectMake(0, 0, self.scrollView.contentSize.width, self.scrollView.contentSize.height) animated:NO]; //TODO: this should be more zoomed in?
}

- (void)setScrollView:(UIScrollView *)scrollView {
    _scrollView = scrollView;
    self.scrollView.minimumZoomScale = 0.2;
    self.scrollView.maximumZoomScale = 2;
    self.scrollView.contentSize = self.image ? self.image.size : CGSizeZero;
    self.scrollView.delegate = self;
}

@end
