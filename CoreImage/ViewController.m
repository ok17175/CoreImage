//
//  ViewController.m
//  CoreImage
//
//  Created by 李深龙 on 13-10-1.
//  Copyright (c) 2013年 李深龙. All rights reserved.
//

#import "ViewController.h"
#import <AssetsLibrary/AssetsLibrary.h>

@interface ViewController ()

@property(nonatomic,strong)CIContext *context;
@property(nonatomic,strong)CIFilter *filter;
@property(nonatomic,strong)CIImage *ciImage;
@property(nonatomic)float sliderValue;
@property (weak, nonatomic) IBOutlet UISlider *slider;
@end

@implementation ViewController

- (void)viewDidLoad
{
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"image" ofType:@"png"];
    NSURL *fileURL = [NSURL fileURLWithPath:filePath];
    
    self.context = [CIContext contextWithOptions:Nil];
    
    self.ciImage = [CIImage imageWithContentsOfURL:fileURL];
    
    self.filter = [CIFilter filterWithName:@"CISepiaTone" keysAndValues:kCIInputImageKey,self.ciImage,@"inputIntensity",@0.5, nil];
    
    CIImage *outputImage = [self.filter outputImage];
    
    CGImageRef cgImage = [self.context createCGImage:outputImage fromRect:[outputImage extent]];
    
    UIImage *image = [UIImage imageWithCGImage:cgImage];
    
    self.imageView.image = image;
    
    //NSLog(@"%@",[self.ciImage properties]);
    
    CGImageRelease(cgImage);
}

- (IBAction)changeValue:(UISlider *)sender
{
    self.sliderValue = sender.value;
    [self.filter setValue:@(self.sliderValue) forKey:@"inputIntensity"];
    CIImage *outputImage = [self.filter outputImage];
    
    CGImageRef cgImage = [self.context createCGImage:outputImage fromRect:[outputImage extent]];
    UIImage *image = [UIImage imageWithCGImage:cgImage];
    self.imageView.image = image;
    CGImageRelease(cgImage);
}

- (IBAction)loadPhoto:(UIButton *)sender
{
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc]init];
    imagePicker.delegate = self;
    [self presentViewController:imagePicker animated:YES completion:Nil];
}

- (IBAction)savePhoto:(id)sender
{
    CIImage *image = [self.filter outputImage];
    CGImageRef cgimage = [self.context createCGImage:image fromRect:[image extent]];
    ALAssetsLibrary *library = [[ALAssetsLibrary alloc]init];
    [library writeImageToSavedPhotosAlbum:cgimage metadata:[image properties] completionBlock:^(NSURL *assetURL,NSError *error){
        CGImageRelease(cgimage);
    }];
}


#pragma mark delegate

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [self dismissViewControllerAnimated:YES completion:Nil];
    UIImage *image = [info valueForKey:UIImagePickerControllerOriginalImage];
    self.ciImage = [CIImage imageWithCGImage:image.CGImage];
    [self.filter setValue:self.ciImage forKey:kCIInputImageKey];
    [self changeValue:self.slider];
}

-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
