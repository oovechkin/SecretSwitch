//
//  ModalViewController.m
//  SecretSwitch
//
//  Created by Edwin Veger on 30-05-14.
//  Copyright (c) 2014 Croath. All rights reserved.
//

#import "ModalViewController.h"

@interface ModalViewController ()

@end

@implementation ModalViewController

- (IBAction)doneButtonPressed:(id)sender {
    [self.presentingViewController dismissViewControllerAnimated:YES completion:^{
    }];
}

@end
