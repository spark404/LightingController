//
//  MidiInterface.m
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

#import "MidiInterface.h"

@implementation MidiInterface

@synthesize delegate;

- (id)init
{
    self = [super init];
    if(self) {
        OSStatus status;
        
        /** Create the MIDIClient
         */
        status = MIDIClientCreate(CFSTR("LightingController"),
                                           MyMIDINotifyProc,
                                           (__bridge void *)(self),
                                           &midiClient);
        
        if (status != 0) {
            NSLog(@"Failed to create MIDIClient, status %d", status);
            NSException* midiInterfaceException = [NSException
                                        exceptionWithName:@"MidiClientException"
                                        reason:@"Failed to create MIDI Client"
                                        userInfo:nil];
            @throw midiInterfaceException;
        }
        
        /** Create the OutputPort
         */
        status = MIDIOutputPortCreate(midiClient, CFSTR("LightingController Outputport"), &midiPort);
        if (status != 0) {
            NSException* midiInterfaceException = [NSException
                                                   exceptionWithName:@"MidiClientException" reason:@"Failed to create MIDI Outputport" userInfo:nil];
            @throw midiInterfaceException;
        }

        /** Find the output device
         */
        ItemCount destCount = MIDIGetNumberOfDestinations();
        for (ItemCount i = 0 ; i < destCount ; ++i) {
            
            MIDIEndpointRef dest = MIDIGetDestination(i);
            if (dest != 0) {
                NSLog(@"  Destination: %@", [self getName:dest]);
                if ([[self getName:dest] hasPrefix:@"Midi Out 1"]) { // TODO Hardcoded name
                    destinationPort = dest;
                }
            }
        }
    }
    return self;
}


-(void)dealloc
{
    OSStatus status = MIDIClientDispose(midiClient);
    if (status != 0) {
        NSLog(@"Failed to dispose the midi client, status %d", status);
    }
}

-(void)sendMessage:(int)channel velocity:(int) velocity{
    // init should have done its thing
    assert(midiClient != 0);
    assert(midiPort != 0);
    assert(destinationPort != 0);
    
    OSStatus status;
    Byte buffer[1024];
    Byte midiDataToSend[] = {0x90, channel-1, velocity};
    
    MIDIPacketList *packetList = (MIDIPacketList *)buffer;
    MIDIPacket     *curpacket  = MIDIPacketListInit(packetList);
    curpacket = MIDIPacketListAdd(packetList, sizeof(buffer), curpacket, 0, 3, midiDataToSend);
    
    status = MIDISend(midiPort, destinationPort, packetList);
    if (status != 0) {
        NSLog(@"Failed to send a midi message to device");
    } else {
        NSLog(@"sendMessage channel %d, velocity %d to %@", channel, velocity, [self getName:destinationPort]);
    }
}

-(void)sendOtherMessage:(int)action intensity:(int)intensity
{
    OSStatus status;
    Byte buffer[1024];
    Byte midiDataToSend[] = {0xA0, action, intensity};
    
    MIDIPacketList *packetList = (MIDIPacketList *)buffer;
    MIDIPacket     *curpacket  = MIDIPacketListInit(packetList);
    curpacket = MIDIPacketListAdd(packetList, sizeof(buffer), curpacket, 0, 3, midiDataToSend);
    
    status = MIDISend(midiPort, destinationPort, packetList);
    if (status != 0) {
        NSLog(@"Failed to send a midi message to device");
    } else {
        NSLog(@"sendMessage %x, %x, %x to %@", midiDataToSend[0], midiDataToSend[1], midiDataToSend[2],
              [self getName:destinationPort]);
    }
}

/** Returns the name of a given MIDIObjectRef as an NSString
 */
-(NSString *) getName: (MIDIObjectRef) object {
        CFStringRef name = nil;
        if (noErr != MIDIObjectGetStringProperty(object, kMIDIPropertyName, &name))
            return nil;
        return (NSString *)CFBridgingRelease(name);
}

/** List the output devices
 */
-(NSArray *) getDestinations {
    ItemCount destCount = MIDIGetNumberOfDestinations();
    NSMutableArray *destinationsArray = [NSMutableArray array];
    for (ItemCount i = 0 ; i < destCount ; ++i) {
        
        MIDIEndpointRef dest = MIDIGetDestination(i);
        if (dest != 0) {
            [destinationsArray addObject:[self getName:dest]];
        }
    }
    
    return destinationsArray;
}

-(void) setDestination:(NSString*)destinationName {
    destinationPort = 0; // RESET
    ItemCount destCount = MIDIGetNumberOfDestinations();
    for (ItemCount i = 0 ; i < destCount ; ++i) {
        
        MIDIEndpointRef dest = MIDIGetDestination(i);
        if (dest != 0 && ([[self getName:dest] compare:destinationName] == NSOrderedSame)) {
                destinationPort = dest;
        }
    }
    
    if (destinationPort == 0) {
        // Not found, raise an exception
        NSException* midiInterfaceException = [NSException
                                               exceptionWithName:@"MidiInterfaceException" reason:@"Could not find the requested destination" userInfo:nil];
        @throw midiInterfaceException;
    }
    
    NSLog(@"Destination set to %@ %@", [self getName:destinationPort], destinationName);
}

/** Workaround to pass a notification to the object
 * create a C style call and send it to a Objective-C method
 */
static void MyMIDINotifyProc(const MIDINotification *message, void *refCon)
{
    [(__bridge id) refCon MIDINotify: message];
}

-(void) MIDINotify: (const MIDINotification*) message
{
    const MIDIObjectAddRemoveNotification *addRemoveMessage;
    const MIDIObjectPropertyChangeNotification *propertyChangeMessage;
    
    NSLog(@"Received a notification of type %d", message->messageID);
    switch (message->messageID) {
        case kMIDIMsgSetupChanged:
            NSLog(@"Notification: MIDI Setup Changed");
            [self.delegate midiSetupChanged];
            break;
            
        case kMIDIMsgThruConnectionsChanged:
            NSLog(@"Notification: MIDI Thru Connections Changed");
            break;
            
        case kMIDIMsgObjectAdded:
            addRemoveMessage = (MIDIObjectAddRemoveNotification *) message;
            if (addRemoveMessage->childType == kMIDIObjectType_Destination) {
                NSLog(@"Destination device %@ added", [self getName:addRemoveMessage->child]);
            }
            break;
            
        case kMIDIMsgObjectRemoved:
            addRemoveMessage = (const MIDIObjectAddRemoveNotification *)message;
            if (addRemoveMessage->childType == kMIDIObjectType_Destination) {
                NSLog(@"Destination device %@ removed", [self getName:addRemoveMessage->child]);
            }
            break;
            
        case kMIDIMsgPropertyChanged:
            propertyChangeMessage = (const MIDIObjectPropertyChangeNotification *)message;
            NSLog(@"Property %@ changed on device %@", propertyChangeMessage->propertyName, [self getName:propertyChangeMessage->object]);
            break;
            
        case kMIDIMsgSerialPortOwnerChanged:
            NSLog(@"Notification: MIDI Serial Port Owner Changed");
            break;
            
        case kMIDIMsgIOError:
            NSLog(@"Notification: MIDI IO Error");
            break;
                        
        default:
            NSLog(@"Notification: Unknown notification (id %d)", message->messageID);
            break;
    }
}


@end
