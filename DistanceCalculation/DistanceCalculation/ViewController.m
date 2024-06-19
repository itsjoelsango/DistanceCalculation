 //
//  ViewController.m
//  DistanceCalculation
//
//  Created by Michael JS on 2024/06/18.
//

#import "ViewController.h"
#import "DistanceGetter/DGDistanceRequest.h"

@interface ViewController ()

// declare instance properties here
@property (weak, nonatomic) IBOutlet UITextField *locationTextField;

@property (weak, nonatomic) IBOutlet UITextField *firstDestinationTextField;
@property (weak, nonatomic) IBOutlet UILabel *firstDestinationLabel;

@property (weak, nonatomic) IBOutlet UITextField *secondDestinationTextField;
@property (weak, nonatomic) IBOutlet UILabel *secondDestinationLabel;

@property (weak, nonatomic) IBOutlet UITextField *thirdDestinationTextField;
@property (weak, nonatomic) IBOutlet UILabel *thirdDestinationLabel;

@property (weak, nonatomic) IBOutlet UITextField *fourthDestinationTextField;
@property (weak, nonatomic) IBOutlet UILabel *fourthDestinationLabel;

@property (weak, nonatomic) IBOutlet UIButton *buttonOutlet;

@property (nonatomic) DGDistanceRequest *request;


@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (IBAction)searchButtonResponder:(id)sender {
    
    self.buttonOutlet.enabled = NO;
    
    NSString *location = self.locationTextField.text;
    NSString *firstDestination = self.firstDestinationTextField.text;
    NSString *secondDestination = self.secondDestinationTextField.text;
    NSString *thirdDestination = self.thirdDestinationTextField.text;
    NSString *fourthDestination = self.fourthDestinationTextField.text;
    
    NSArray *destinations = @[firstDestination, secondDestination, thirdDestination, fourthDestination];
    
    self.request = [[DGDistanceRequest alloc] initWithLocationDescriptions:destinations sourceDescription:location];
    
    __weak ViewController *weakSelf = self;
    
    self.request.callback = ^(NSArray *responses) {
        ViewController *strongSelf = weakSelf;
        if (!strongSelf) return;
        
        NSNull *badResult = [NSNull null];
        
        for (NSUInteger i = 0, len = responses.count; i < len; i++) {
            NSString *x = @"";
            if (responses[i] != badResult) {
                double num = ([responses[i] doubleValue] / 1000.0);
                x = [NSString stringWithFormat:@"%.2f km", num];
            }
            else {
                x = @"Error";
            }
            
            switch (i)
            {
                case 0:
                    strongSelf.firstDestinationLabel.text = x;
                    break;
                case 1:
                    strongSelf.secondDestinationLabel.text = x;
                    break;
                case 2:
                    strongSelf.thirdDestinationLabel.text = x;
                    break;
                case 3:
                    strongSelf.fourthDestinationLabel.text = x;
                    break;
                default: break;
            }
        }
        strongSelf.request = nil;
        strongSelf.buttonOutlet.enabled = YES;
        
    };
    
    [self.request start];
    
}

@end
