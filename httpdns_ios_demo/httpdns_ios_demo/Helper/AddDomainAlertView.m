//
//  AddDomainAlertView.m
//  httpdns_ios_demo
//
//  Created by Miracle on 2024/7/31.
//

#import "AddDomainAlertView.h"

@interface AddDomainAlertView()<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UITextField *domainTextField;

@end

@implementation AddDomainAlertView

+ (void)alertWithTitle:(NSString *)title handle:(AddHandle)handle {
    AddDomainAlertView *alertView = [[[NSBundle mainBundle] loadNibNamed:@"AddDomainAlertView" owner:self options:nil] firstObject];
    [alertView setTitle:title];
    alertView.addHandle = handle;
    [alertView show];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    self.domainTextField.delegate = self;
}

- (void)setTitle:(NSString *)title {
    self.titleLabel.text = title;
    NSLog(@"%@",self.titleLabel);
}

- (IBAction)cancleClick:(id)sender {
    [self removeFromSuperview];
}

- (IBAction)confirmClick:(id)sender {
    if (self.addHandle && [HTTPDNSDemoTools isValidString:self.domainTextField.text]) {
        self.addHandle(self.domainTextField.text);
        [self removeFromSuperview];
    }
}

- (void)show {
    [[UIApplication sharedApplication].keyWindow addSubview:self];
}

#pragma mark - textField delegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

@end
