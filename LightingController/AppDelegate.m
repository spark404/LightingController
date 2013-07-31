//
//  AppDelegate.m
//  LightingController
//
// Copyright 2013 Hugo Trippaers
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
// http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

#import "AppDelegate.h"

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    midiInterface = [ MidiInterface alloc];
    [midiInterface init];
    
    NSArray *destinations = [midiInterface getDestinations];
    [self.destinationPopup removeAllItems];
    [self.destinationPopup addItemsWithTitles:destinations];
    
    [self.destinationPopup selectItemAtIndex:0]; // Select first one in the list
    [midiInterface setDestination:[self.destinationPopup titleOfSelectedItem]];
    
    /** toggleButton holds the array with pages
     *  each page is an NSArray with boolean values 
     *  corresponding to the toggle state
     */
    NSMutableArray *pageList = [NSMutableArray array];
    for (int pages = 0; pages < 10; pages++) {
        NSMutableArray *buttonStates = [NSMutableArray array] ;
        for (int buttons = 0; buttons<15; buttons++) {
            [buttonStates addObject:[NSNumber numberWithBool:NO]];
        }
        [pageList addObject:buttonStates];
    }
    toggleButtons = [NSArray arrayWithArray:pageList];
    
    currentPage = 0;
    [self.actionsPageLabel setStringValue:@"Page 1"];
}

- (IBAction)sliderChangeValue:(id)sender {
    NSSlider *slider = (NSSlider *) sender;
    if ([slider.identifier hasPrefix:@"Channel_"]) {
        NSString *channelid = [slider.identifier substringFromIndex:8];        
        [midiInterface sendMessage:[channelid intValue] velocity:slider.intValue];
    } else  {
        NSLog(@"Unexpected slider message received from id %@", slider.identifier);
    }
}

- (IBAction)resetButtonClick:(NSButton *)sender {
    [self.slider_chan_1 setIntValue:0];
    [self sliderChangeValue:[self.slider_chan_1 self]];
    
    [self.slider_chan_2 setIntValue:0];
    [self sliderChangeValue:[self.slider_chan_2 self]];

    [self.slider_chan_3 setIntValue:0];
    [self sliderChangeValue:[self.slider_chan_3 self]];
    
    [self.slider_chan_4 setIntValue:0];
    [self sliderChangeValue:[self.slider_chan_4 self]];

    [self.slider_chan_5 setIntValue:0];
    [self sliderChangeValue:[self.slider_chan_5 self]];

    [self.slider_chan_6 setIntValue:0];
    [self sliderChangeValue:[self.slider_chan_6 self]];

    [self.slider_chan_7 setIntValue:0];
    [self sliderChangeValue:[self.slider_chan_7 self]];

    [self.slider_chan_8 setIntValue:0];
    [self sliderChangeValue:[self.slider_chan_8 self]];

    [self.slider_chan_9 setIntValue:0];
    [self sliderChangeValue:[self.slider_chan_9 self]];

    [self.slider_chan_10 setIntValue:0];
    [self sliderChangeValue:[self.slider_chan_10 self]];

    [self.slider_chan_11 setIntValue:0];
    [self sliderChangeValue:[self.slider_chan_11 self]];

    [self.slider_chan_12 setIntValue:0];
    [self sliderChangeValue:[self.slider_chan_12 self]];

    [self.slider_chan_13 setIntValue:0];
    [self sliderChangeValue:[self.slider_chan_13 self]];

    [self.slider_chan_14 setIntValue:0];
    [self sliderChangeValue:[self.slider_chan_14 self]];

    [self.slider_chan_15 setIntValue:0];
    [self sliderChangeValue:[self.slider_chan_15 self]];

    [self.slider_chan_16 setIntValue:0];
    [self sliderChangeValue:[self.slider_chan_16 self]];

}

- (IBAction)selectDestination:(id)sender {
    NSPopUpButton *destPopup = (NSPopUpButton *) sender;
    [midiInterface setDestination:[destPopup titleOfSelectedItem]];
}

- (IBAction)programmableButtonClick:(id)sender {
    NSButton *button = (NSButton *) sender;
    
    int intensity = 0; // Intensity of the program (if applicable)
    int action = 0;    // Action to trigger
    

    
    if ([button.identifier hasPrefix:@"ProgBtn_"]) {
        NSInteger buttonNumber = [[button.identifier substringFromIndex:8] intValue];
        NSInteger buttonState = button.state;
        
        [[toggleButtons objectAtIndex:currentPage] replaceObjectAtIndex:buttonNumber-1 withObject:[NSNumber numberWithBool:buttonState]];

        
        if (buttonState == NSOffState) {
            intensity = 0; // Turn it off
        }
        else {
            intensity = [self.intensitySlider intValue]; // Turn it on
        }
        
        action = buttonNumber; // TODO add paging code
        
        [midiInterface sendOtherMessage:action intensity:intensity];
    } else  {
        NSLog(@"Unexpected slider message received from id %@", button.identifier);
    }
}

- (IBAction)pageChangeButtonClick:(id)sender {
    NSStepper *stepper = (NSStepper *)sender;
    currentPage = stepper.intValue;
    [self redrawActionButtonState];
}

-(void) redrawActionButtonState {
    NSArray *currentButtonList = [toggleButtons objectAtIndex:currentPage];
    [self.action_button_1 setState:[[currentButtonList objectAtIndex:0] boolValue]];
    [self.action_button_2 setState:[[currentButtonList objectAtIndex:1] boolValue]];
    [self.action_button_3 setState:[[currentButtonList objectAtIndex:2] boolValue]];
    [self.action_button_4 setState:[[currentButtonList objectAtIndex:3] boolValue]];
    [self.action_button_5 setState:[[currentButtonList objectAtIndex:4] boolValue]];
    [self.action_button_6 setState:[[currentButtonList objectAtIndex:5] boolValue]];
    [self.action_button_7 setState:[[currentButtonList objectAtIndex:6] boolValue]];
    [self.action_button_8 setState:[[currentButtonList objectAtIndex:7] boolValue]];
    [self.action_button_9 setState:[[currentButtonList objectAtIndex:8] boolValue]];
    [self.action_button_10 setState:[[currentButtonList objectAtIndex:9] boolValue]];
    [self.action_button_11 setState:[[currentButtonList objectAtIndex:10] boolValue]];
    [self.action_button_12 setState:[[currentButtonList objectAtIndex:11] boolValue]];
    [self.action_button_13 setState:[[currentButtonList objectAtIndex:12] boolValue]];
    [self.action_button_14 setState:[[currentButtonList objectAtIndex:13] boolValue]];
    [self.action_button_15 setState:[[currentButtonList objectAtIndex:14] boolValue]];

    [self.actionsPageLabel setStringValue:[NSString stringWithFormat:@"Page %d",currentPage+1]];
}

#pragma mark - MidiInterfaceSetupChangeNotification -

-(void) midiSetupChanged {
    NSArray *destinations = [midiInterface getDestinations];
    [self.destinationPopup removeAllItems];
    [self.destinationPopup addItemsWithTitles:destinations];   
}

@end
