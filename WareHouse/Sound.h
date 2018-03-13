//
//  Sound.h
//  WareHouse
//
//  Created by David Lan on 17/6/17.
//  Copyright © 2017 David Lan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AudioToolbox/AudioToolbox.h>

@interface Sound : NSObject{
     SystemSoundID sound;//系统声音的id 取值范围为：1000-2000
}

- (id)initSystemShake;
- (id)initSystemSoundWithName:(NSString *)soundName SoundType:(NSString *)soundType;
- (void)play;

@end
