//
//  AppDelegate.h
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

#import <Cocoa/Cocoa.h>
#import "MidiInterface.h"

MidiInterface *midiInterface;
NSArray *toggleButtons;
int currentPage;

@interface AppDelegate : NSObject <NSApplicationDelegate, MidiInterfaceSetupChangeNotification>

@property (weak) IBOutlet NSSlider *slider_chan_1;
@property (weak) IBOutlet NSSlider *slider_chan_2;
@property (weak) IBOutlet NSSlider *slider_chan_3;
@property (weak) IBOutlet NSSlider *slider_chan_4;
@property (weak) IBOutlet NSSlider *slider_chan_5;
@property (weak) IBOutlet NSSlider *slider_chan_6;
@property (weak) IBOutlet NSSlider *slider_chan_7;
@property (weak) IBOutlet NSSlider *slider_chan_8;
@property (weak) IBOutlet NSSlider *slider_chan_9;
@property (weak) IBOutlet NSSlider *slider_chan_10;
@property (weak) IBOutlet NSSlider *slider_chan_11;
@property (weak) IBOutlet NSSlider *slider_chan_12;
@property (weak) IBOutlet NSSlider *slider_chan_13;
@property (weak) IBOutlet NSSlider *slider_chan_14;
@property (weak) IBOutlet NSSlider *slider_chan_15;
@property (weak) IBOutlet NSSlider *slider_chan_16;

@property (weak) IBOutlet NSButton *action_button_1;
@property (weak) IBOutlet NSButton *action_button_2;
@property (weak) IBOutlet NSButton *action_button_3;
@property (weak) IBOutlet NSButton *action_button_4;
@property (weak) IBOutlet NSButton *action_button_5;
@property (weak) IBOutlet NSButton *action_button_6;
@property (weak) IBOutlet NSButton *action_button_7;
@property (weak) IBOutlet NSButton *action_button_8;
@property (weak) IBOutlet NSButton *action_button_9;
@property (weak) IBOutlet NSButton *action_button_10;
@property (weak) IBOutlet NSButton *action_button_11;
@property (weak) IBOutlet NSButton *action_button_12;
@property (weak) IBOutlet NSButton *action_button_13;
@property (weak) IBOutlet NSButton *action_button_14;
@property (weak) IBOutlet NSButton *action_button_15;


@property (weak) IBOutlet NSPopUpButton *destinationPopup;
@property (weak) IBOutlet NSTextField *actionsPageLabel;
@property (weak) IBOutlet NSSlider *intensitySlider;


@property (assign) IBOutlet NSWindow *window;

- (IBAction)sliderChangeValue:(id)sender;
- (IBAction)resetButtonClick:(NSButton *)sender;
- (IBAction)selectDestination:(id)sender;

- (IBAction)programmableButtonClick:(id)sender;
- (IBAction)pageChangeButtonClick:(id)sender;

- (IBAction)startGameSequence:(id)sender;
- (IBAction)stopGameSequence:(id)sender;

@end
