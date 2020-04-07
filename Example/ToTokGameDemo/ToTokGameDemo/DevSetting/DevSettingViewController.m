//
//  DevSettingViewController.m
//  ToTokGameDemo
//
//  Created by Balalaika on 2020/3/26.
//  Copyright © 2020 GMCT. All rights reserved.
//

#import "DevSettingViewController.h"
#import <ToTokGameSDK/ToTokGameSDK.h>
#import "Header.h"

@interface DevSettingViewController ()

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *navHeight;
@property (weak, nonatomic) IBOutlet UILabel *domainString;

@property (weak, nonatomic) IBOutlet UILabel *domainStatus;
@property (weak, nonatomic) IBOutlet UILabel *payStatus;

@end

@implementation DevSettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navHeight.constant = Nav_StatusBar_Height;
    [self setupUI];
}

- (IBAction)back:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)setupUI {
    NSString *domain = [[ToTokGameManager defaultManager] SDKServerDomain];
    self.domainString.text = domain;
    if ([domain containsString:@"team"]) {
        self.domainStatus.text = @"test";
    } else {
        self.domainStatus.text = @"pro";
    }
    int pay = [[ToTokGameManager defaultManager] getPayEnvironment];
    if (pay == 2) {
        self.payStatus.text = @"test";
    } else {
        self.payStatus.text = @"pro";
    }
}

- (IBAction)domainSetting:(id)sender {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Tips" message:@"Please select server environment" preferredStyle:UIAlertControllerStyleActionSheet];
    [alertController addAction:[UIAlertAction actionWithTitle:@"Test" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [[ToTokGameManager defaultManager] setServerDomainTest];
        [self setupUI];
    }]];
    [alertController addAction:[UIAlertAction actionWithTitle:@"Production" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [[ToTokGameManager defaultManager] setServerDomainProduction];
        [self setupUI];
    }]];
    [alertController addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleDefault handler:nil]];
    [self presentViewController:alertController animated:true completion:nil];
}

- (IBAction)paySetting:(id)sender {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Tips" message:@"Please select In-App Purchase environment" preferredStyle:UIAlertControllerStyleActionSheet];
    [alertController addAction:[UIAlertAction actionWithTitle:@"Test" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [[ToTokGameManager defaultManager] setPayEnvironmentTest];
        [self setupUI];
    }]];
    [alertController addAction:[UIAlertAction actionWithTitle:@"Production" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [[ToTokGameManager defaultManager] setPayEnvironmentProduction];
        [self setupUI];
    }]];
    [alertController addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleDefault handler:nil]];
    [self presentViewController:alertController animated:true completion:nil];
}

- (IBAction)debug:(id)sender {
    UISwitch *switchbutton = sender;
    if (switchbutton.isOn) {
        [[ToTokGameManager defaultManager] openLogInfo];
    } else {
        [[ToTokGameManager defaultManager] closeLogInfo];
    }
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
