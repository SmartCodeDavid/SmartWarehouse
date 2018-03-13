//
//  Sound.m
//  WareHouse
//
//  Created by David Lan on 17/6/17.
//  Copyright © 2017 David Lan. All rights reserved.
//

#import "Sound.h"

@implementation Sound

- (id)initSystemSoundWithName:(NSString *)soundName SoundType:(NSString *)soundType
{
    self = [super init];
    if (self) {
        NSString *path = [NSString stringWithFormat:@"/System/Library/Audio/UISounds/%@.%@",soundName,soundType];
        if (path) {
            OSStatus error = AudioServicesCreateSystemSoundID((__bridge CFURLRef)[NSURL fileURLWithPath:path],&sound);
            
            if (error != kAudioServicesNoError) {
                sound = 0;
            }
        }
    }
    return self;
}

- (id)initSystemShake
{
    self = [super init];
    if (self) {
        sound = kSystemSoundID_Vibrate;
    }
    return self;
}

- (void)play
{
    AudioServicesPlaySystemSound(sound);
}

@end
