//
//  YWSettingViewController.m
//  YWFeedbackDemo
//
//  Created by ali on 2024/9/27.
//

#import "YWSettingViewController.h"

@interface YWSettingViewController ()
@property (weak, nonatomic) IBOutlet UITextField *userNickTextField;
@property (weak, nonatomic) IBOutlet UISwitch *customSwitch;
@property (weak, nonatomic) IBOutlet UITextField *fontTextField;
@property (weak, nonatomic) IBOutlet UISwitch *errorSwitch;

@end

@implementation YWSettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    UIBarButtonItem *leftButton = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:self action:@selector(backButtontapped)];
    self.navigationItem.leftBarButtonItem = leftButton;
    [self getSettingInfo];
}

- (void)getSettingInfo {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSDictionary *settingInfo = [userDefaults objectForKey:@"YWSettingInfo"];
    if (settingInfo) {
        NSString *userNick = settingInfo[@"userName"];
        NSString *font = settingInfo[@"font"];
        BOOL customSwitch = [settingInfo[@"customSwitch"] boolValue];
        BOOL errorSwitch = [settingInfo[@"errorSwitch"] boolValue];
        
        self.userNickTextField.text = userNick;
        self.fontTextField.text = font;
        self.errorSwitch.on = errorSwitch;
        self.customSwitch.on = customSwitch;
    }
}

- (void)backButtontapped {
    
    NSMutableDictionary *settingInfo = [@{} mutableCopy];
    if (self.userNickTextField.text && self.userNickTextField.text.length > 0) {
        settingInfo[@"userName"] = self.userNickTextField.text;
    }
    if (self.fontTextField.text && self.fontTextField.text.length > 0) {
        settingInfo[@"font"] = self.fontTextField.text;
    }
    settingInfo[@"customSwitch"] = @(self.customSwitch.on);
    settingInfo[@"errorSwitch"] = @(self.errorSwitch.on);
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:settingInfo forKey:@"YWSettingInfo"];
    [userDefaults synchronize];
    
    [self.navigationController popViewControllerAnimated:YES];
    
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
