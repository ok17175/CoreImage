//
//  ViewController.h
//  CoreImage
//
//  Created by 李深龙 on 13-10-1.
//  Copyright (c) 2013年 李深龙. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController<UIImagePickerControllerDelegate,UINavigationControllerDelegate>
@property (strong, nonatomic) IBOutlet UIImageView *imageView;

@end
