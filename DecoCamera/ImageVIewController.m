//
//  ImageVIewController.m
//  DecoCamera
//
//  Created by 井上圭一 on 2016/01/25.
//  Copyright © 2016年 keiichi, inoue. All rights reserved.
//

#import "ImageVIewController.h"

@interface ImageVIewController ()

@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@property (weak, nonatomic) IBOutlet UIButton *grayButton;
@property (assign, nonatomic) BOOL isGray;

- (IBAction)saveButtonAction:(id)sender;
- (IBAction)grayButttonAction:(id)sender;
- (IBAction)backButtonAction:(id)sender;

@end

@implementation ImageVIewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.imageView.image = self.editImage;
    self.isGray = NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)saveButtonAction:(id)sender {
    
    SEL selector = @selector(inCompleteCapture:didFinishSavingWithError:contextInfo:);
    // 画像を保存する
    UIImageWriteToSavedPhotosAlbum(self.imageView.image, self, selector, NULL);
}

// 画像保存完了時のセレクタ
- (void)onCompleteCapture:(UIImage *)screenImage didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"保存終了" message:@"画像を保存しました" preferredStyle:UIAlertControllerStyleAlert];
    
    // addActionした順に左から右にボタンが配置されます
    [alertController addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        // ボタンを押した際に処理が必要ならここに書きます。
        
    }]];
    
    [self presentViewController:alertController animated:YES completion:nil];
    
}
- (IBAction)grayButtonAction:(id)sender {
    
    self.isGray = !self.isGray;
    
    if (self.isGray) {
        
        [self.grayButton setTitle:@"Reset" forState:UIControlStateNormal];
        
        UIImage *image = self.editImage;
        CGRect imageRect = (CGRect){0.0, 0.0, image.size.width, image.size.height};
        
        // CoreGraphicsのモノグラム色空間を準備します。
        CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceGray();
        
        // ビットマップコンテキストを作りサイズと色空間を設定します。
        CGContextRef context = CGBitmapContextCreate(nil, image.size.width, image.size.height, 8, 0, colorSpace, kCGImageAlphaNone);
        
        // ビットマップコンテキストに画像を描画します。
        CGImageRef imageRef = CGBitmapContextCreateImage(context);
        
        // 取得した画像からUIImageを作ります。
        UIImage *grayScaleImage = [UIImage imageWithCGImage:imageRef];
        
        // 準備した色空間、ビットマップコンテキスト、取得した画像をメモリから解放します
        CGColorSpaceRelease(colorSpace);
        CGContextRelease(context);
        CFRelease(imageRef);
        
        // Storybord上のUIImageViewに画像を描写します
        self.imageView.image = grayScaleImage;
        
    } else {
        self.grayButton.titleLabel.text = @"Gray";
        [self.grayButton setTitle:@"Gray" forState:UIControlStateNormal];
        
        self.imageView.image = self.editImage;
    }
}

- (IBAction)backButtonAction:(id)sender {
    [self.navigationController popToRootViewControllerAnimated:YES];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
