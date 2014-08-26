//
//  ViewController.m
//  Sample
//
//  Created by 波切 賢一 on 12/06/28.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "ViewController.h"
#import "WebViewController.h"
#import "Base62.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UITextField *numberTextField;
@property (weak, nonatomic) IBOutlet UILabel *changeTextLabel;

@end

@implementation ViewController

- (IBAction)changeButton:(id)sender
{
    if (_numberTextField.text.length > 0) {
        
        int num = [_numberTextField.text intValue];
        
        NSString* s = [NSString base62StringWithInt:num];
        
        _changeTextLabel.text = s;
    }
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	
    
    // 10進数→62進数変換例
    NSString* s = [NSString base62StringWithInt:123456789];
    NSLog(@"%@", s);        //=> 8m0Kx
    
    int d = [s intValueAsBase62];
    NSLog(@"%d", d);        //=> 123456789
    
}

- (void)viewDidUnload
{
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

- (IBAction)modal_tapped:(id)sender
{
    WebViewController *controller = [[ WebViewController alloc] initWithNibName:@"WebViewController" bundle:nil ];
    [ self presentModalViewController:controller  animated:YES ];
}
@end
