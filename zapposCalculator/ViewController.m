//
//  ViewController.m
//  zapposCalculator
//
//  Created by Saksham Saini on 2/4/16.
//  Copyright © 2016 Saksham_Saini. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController
UILabel *numberLabel;
UILabel *firstNumberLabel;
NSString *firstNumber = @"";
NSString *oldNumber = @"";
NSString *secondNumber=@"";
NSString *op;
BOOL operatorPressed;
BOOL decimalPressed = FALSE;
- (void)viewDidLoad {
    [super viewDidLoad];
        // Do any additional setup after loading the view, typically from a nib.
}


-(void) viewWillAppear:(BOOL)animated{
    [[NSNotificationCenter defaultCenter] addObserver:self  selector:@selector(orientationChanged:)name:UIDeviceOrientationDidChangeNotification  object:nil];
}

-(void) orientationChanged:(NSNotification *)note{
    [self addButtons];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//Method called whenever a number button is pressed
-(void) selectedNumber:(UIButton *)button{
    
    NSString *mainLabelString = [NSString stringWithString:numberLabel.text];
    if([mainLabelString isEqualToString:@"0"] || operatorPressed){
        numberLabel.text = [NSString stringWithFormat:@"%@", button.titleLabel.text];
        operatorPressed = false;
    }
    else{
        if ([button.titleLabel.text isEqualToString:@"."]&&[numberLabel.text rangeOfString:@"."].location == NSNotFound) {
            NSString *mergedNumber = [NSString stringWithFormat:@"%@%@",mainLabelString, button.titleLabel.text];
            numberLabel.adjustsFontSizeToFitWidth = YES;
            numberLabel.text = mergedNumber;
            decimalPressed = true;
        }
        else if(![button.titleLabel.text isEqualToString:@"."]){
            NSString *mergedNumber = [NSString stringWithFormat:@"%@%@",mainLabelString, button.titleLabel.text];
            numberLabel.adjustsFontSizeToFitWidth = YES;
            numberLabel.text = mergedNumber;
        }
    }
   
    [button setBackgroundColor:[UIColor colorWithRed:120.0/255 green:120.0/255 blue:120.0/255 alpha:1.0]];
    
}

//Method called to change back the color of the button when unpressed
-(void) changeColorBack:(UIButton *) button{
    NSString *selectedValue = button.titleLabel.text;
    if ([selectedValue integerValue] || [selectedValue  isEqual: @"0"] || [selectedValue isEqual:@"."])
        [button setBackgroundColor:[UIColor grayColor]];
    else if([selectedValue isEqualToString:@"AC"])
        [button setBackgroundColor:[UIColor colorWithRed:59.0/255 green:156.0/255 blue:255.0/255 alpha:1.0]];
    else
        [button setBackgroundColor:[UIColor orangeColor]];
        
}

//Method called when a mathematical operator is pressed to select which operator function to call
- (void)selectOperator {
    if([op isEqualToString:@"+"]){
        [self addNumbers];
    }
    else if([op isEqualToString:@"-"]){
        [self subtractNumbers];
    }
    else if ([op isEqualToString:@"%"]){
        [self percentageNumbers];
    }
    else if ([op isEqualToString:@"*"]){
        [self multiplyNumbers];
    }
    else if([op isEqualToString:@"/"]){
        [self divideNumbers];
    }
    op = @"";
}

//Method called when a mathematical operator is pressed. It analyzes the operator and checks if more value is needed or not
-(void) selectedOperator:(UIButton *)button{
    
    if([button.titleLabel.text isEqualToString:@"AC"]){
        firstNumber = secondNumber = @"0";
        numberLabel.text = @"0";
        decimalPressed = false;
        operatorPressed = false;
    }
    else if([button.titleLabel.text isEqualToString:@"="]){
        secondNumber = numberLabel.text;
        [self selectOperator];
        [numberLabel setTextAlignment:NSTextAlignmentRight];

        secondNumber = @"";

    }
    else if(operatorPressed == false )
    {
        decimalPressed = false;
        if([firstNumber isEqualToString:@"0"]|[firstNumber isEqualToString:@""]){
            firstNumber = numberLabel.text;
            [numberLabel setTextAlignment:NSTextAlignmentRight];

        }
        else {
            secondNumber = numberLabel.text;
            [self selectOperator];
            [numberLabel setTextAlignment:NSTextAlignmentRight];

        }
        op = button.titleLabel.text;
        operatorPressed = true;
    
        if ([op isEqualToString:@"%"]) {
            [self selectOperator];
        }
    }
    else
    {
        op = button.titleLabel.text;
        secondNumber = numberLabel.text;
        [self selectOperator];
        operatorPressed = false;
    }
    if ([button.titleLabel.text isEqualToString:@"AC"])
        [button setBackgroundColor:[UIColor colorWithRed:39.0/255 green:136.0/255 blue:235.0/255 alpha:1.0]];
    else
        [button setBackgroundColor:[UIColor colorWithRed:212.0/255 green:104.0/255 blue:0.0/255 alpha:1.0]];
    
}


//Method to add buttons to the screen
-(void)addButtons{
    [self.view.subviews makeObjectsPerformSelector: @selector(removeFromSuperview)];
    
    //Calculating the height and width of the screen for all devices and orientations
    CGFloat height = self.view.frame.size.height;
    CGFloat width = self.view.frame.size.width;
    
    NSMutableArray *numberArray;    //Array to store the numbers
    NSArray *operatorArray = [[NSArray alloc] initWithObjects:@"+",@"-",@"/",@"*",@"%", nil]; //Array to store the mathematical operators
    NSArray *misc = [[NSArray alloc] initWithObjects:@"AC",@"=", nil];//Array to store the clear and equals sign
    
    
    numberArray = [[NSMutableArray alloc] init];
    for ( int i = 1; i<=10;i++){
        [numberArray addObject:[NSString stringWithFormat:@"%d",i%10]];
    }

    [numberArray addObject:[NSString stringWithFormat:@"."]];
    
    //Loop for placing the number buttons on the screen
    for(int i = 0; i<[numberArray count]; i++){
        UIButton *numberButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [numberButton addTarget:self action:@selector(selectedNumber:) forControlEvents:UIControlEventTouchDown];
        [numberButton addTarget:self action:@selector(changeColorBack:) forControlEvents:UIControlEventTouchUpInside];
        
        [numberButton setBackgroundColor:[UIColor grayColor]];
        [numberButton setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
        [numberButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        numberButton.titleLabel.font = [UIFont systemFontOfSize:30.0];
        [numberButton setTitle:[NSString stringWithFormat:@"%@", numberArray[i]] forState:UIControlStateNormal];
        numberButton.frame = CGRectMake((width/4.0)*(i%3),(height/6)*(i/3+1), (width/4.0)-0.25, ((height)/6.0));
        [numberButton.layer setBorderColor:[[UIColor blackColor] CGColor]];
        [numberButton.layer setBorderWidth:0.20];

        [self.view addSubview:numberButton];
    }
    
    //Loop to place the clear and equals button on the screen
    for (int i = 0; i<[misc count]; i++) {
        UIButton *miscButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [miscButton addTarget:self action:@selector(selectedOperator:) forControlEvents:UIControlEventTouchDown];
        [miscButton addTarget:self action:@selector(changeColorBack:) forControlEvents:UIControlEventTouchUpInside];
        
        if ([misc[i] isEqualToString:@"="]) {
             [miscButton setBackgroundColor:[UIColor orangeColor]];
        }
        else{
            [miscButton setBackgroundColor:[UIColor colorWithRed:59.0/255 green:156.0/255 blue:255.0/255 alpha:1.0]];
        }
        [miscButton setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
        [miscButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        miscButton.titleLabel.font = [UIFont systemFontOfSize:30.0];
        [miscButton setTitle:[NSString stringWithFormat:@"%@", misc[i]] forState:UIControlStateNormal];
        miscButton.frame = CGRectMake((width/2.0)*(i%2),5*(height/6), (width/2.0), ((height)/6.0));
        [miscButton.layer setBorderColor:[[UIColor blackColor] CGColor]];
        [miscButton.layer setBorderWidth:0.20];
        
        [self.view addSubview:miscButton];

    }
    
    //Loop to place the mathematical operators on the screen
    for (int i = 0; i<[operatorArray count];i++){
        
        UIButton *operatorButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [operatorButton addTarget:self action:@selector(selectedOperator:) forControlEvents:UIControlEventTouchDown];
        [operatorButton addTarget:self action:@selector(changeColorBack:) forControlEvents:UIControlEventTouchUpInside];
        
        [operatorButton setBackgroundColor:[UIColor orangeColor]];
        operatorButton.titleLabel.font = [UIFont systemFontOfSize:30.0];
        [operatorButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [operatorButton setTitle:[NSString stringWithFormat:@"%@",operatorArray[i]] forState:UIControlStateNormal];
        
        if(i == [operatorArray count]-1){
        
            operatorButton.frame = CGRectMake(((width/4.0))*2, (height/6)*(i), (width/4.0), ((height)/6.0));
        }
        else
            operatorButton.frame = CGRectMake((width/4.0)*3, (height/6)*(i+1), (width/4.0), ((height)/6.0));
        
        [operatorButton.layer setBorderColor:[[UIColor blackColor] CGColor]];
        [operatorButton.layer setBorderWidth:0.20];

        [self.view addSubview:operatorButton];
    }
    
    //Setting the label properties for the Main Number Label
    numberLabel= [[UILabel alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height/12-20, self.view.frame.size.width-5, 50)];
    [numberLabel setFont:[UIFont fontWithName:@"Helvetica" size:50.0] ];
    if ([firstNumber isEqualToString:@""])
        numberLabel.text = [NSString stringWithFormat:@"0"];
    else
        numberLabel.text = firstNumber;
    [numberLabel setTextColor:[UIColor whiteColor]];
    [numberLabel setTextAlignment:NSTextAlignmentRight];
    [self.view addSubview:numberLabel];
}

//Converts the string values to NSNumber
-(NSNumber*) stringToNumber:(NSString *)string{
    NSNumberFormatter *f = [[NSNumberFormatter alloc] init];
    f.numberStyle = NSNumberFormatterDecimalStyle;
    NSNumber *myNumber = [f numberFromString:string];
    return myNumber;

}

//Function to add numbers
-(void) addNumbers{
    NSLog(@"First Number:%@ Second Number%@",firstNumber,secondNumber);
    NSNumber *sum  = [NSNumber numberWithFloat:([[self stringToNumber:firstNumber] floatValue]+[[self stringToNumber:secondNumber]floatValue])];
    firstNumber = [NSString stringWithFormat:@"%@",sum];
    numberLabel.text = [NSString stringWithFormat:@"%@",sum];
    NSLog(@"Sum %@",sum);
    
}

//Function to Subtract Numbers
-(void) subtractNumbers{
    NSLog(@"First Number:%@ Second Number%@",firstNumber,secondNumber);
    NSNumber *sum  = [NSNumber numberWithFloat:([[self stringToNumber:firstNumber] floatValue]-[[self stringToNumber:secondNumber]floatValue])];
    firstNumber = [NSString stringWithFormat:@"%@",sum];
    numberLabel.text = [NSString stringWithFormat:@"%@",sum];
    NSLog(@"Sum %@",sum);

}

//Function to divide numbers
-(void) divideNumbers{
    NSLog(@"First Number:%@ Second Number%@",firstNumber,secondNumber);
    NSNumber *sum  = [NSNumber numberWithFloat:([[self stringToNumber:firstNumber] floatValue]/[[self stringToNumber:secondNumber]floatValue])];
    firstNumber = [NSString stringWithFormat:@"%@",sum];
    numberLabel.text = [NSString stringWithFormat:@"%@",sum];
    NSLog(@"Sum %@",sum);

}

//Function to multiply numbers
-(void) multiplyNumbers{
    NSLog(@"First Number:%@ Second Number%@",firstNumber,secondNumber);
    NSNumber *sum  = [NSNumber numberWithFloat:([[self stringToNumber:firstNumber] floatValue]*[[self stringToNumber:secondNumber]floatValue])];
    firstNumber = [NSString stringWithFormat:@"%@",sum];
    numberLabel.text = [NSString stringWithFormat:@"%@",sum];
    NSLog(@"Sum %@",sum);

}

//Function to calculate the percentage of a number
-(void) percentageNumbers{
    NSLog(@"First Number:%@ Second Number%@",firstNumber,secondNumber);
    NSNumber *sum  = [NSNumber numberWithFloat:([[self stringToNumber:firstNumber] floatValue]/100)];
    firstNumber = [NSString stringWithFormat:@"%@",sum];
    numberLabel.text = [NSString stringWithFormat:@"%@",sum];
    operatorPressed = false;
    NSLog(@"Sum %@",sum);

}

//Function to give the equivalent value
-(void)equalNumbers{
    NSLog(@"First Number:%@ Second Number%@",firstNumber,secondNumber);
    NSNumber *sum  = [NSNumber numberWithFloat:([[self stringToNumber:firstNumber] floatValue]+[[self stringToNumber:secondNumber]floatValue])];
    firstNumber = [NSString stringWithFormat:@"%@",sum];
    numberLabel.text = [NSString stringWithFormat:@"%@",sum];
    NSLog(@"Sum %@",sum);

}

@end
