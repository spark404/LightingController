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
    [self.slider_chan_2 setIntValue:0];
    [self.slider_chan_3 setIntValue:0];
    [self.slider_chan_4 setIntValue:0];
    [self.slider_chan_5 setIntValue:0];
    [self.slider_chan_6 setIntValue:0];
    [self.slider_chan_7 setIntValue:0];
    [self.slider_chan_8 setIntValue:0];
    [self.slider_chan_9 setIntValue:0];
    [self.slider_chan_10 setIntValue:0];
    [self.slider_chan_11 setIntValue:0];
    [self.slider_chan_12 setIntValue:0];
    [self.slider_chan_13 setIntValue:0];
    [self.slider_chan_14 setIntValue:0];
    [self.slider_chan_15 setIntValue:0];
    [self.slider_chan_16 setIntValue:0];
}
@end
