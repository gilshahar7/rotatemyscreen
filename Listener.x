#import <libactivator/libactivator.h>

@interface UIApplication ()
- (NSInteger)_frontMostAppOrientation;
@end

@interface SBOrientationLockManager
+(SBOrientationLockManager *)sharedInstance;
-(bool)isUserLocked;
-(void)lock:(NSInteger)arg1;
-(void)unlock;
@end

@interface RotateMyScreenListener : NSObject<LAListener>
@end

//Activator

@implementation RotateMyScreenListener

-(void)activator:(LAActivator *)activator receiveEvent:(LAEvent *)event forListenerName:(NSString *)listenerName {
    //We got called! run some stuff.

  if ([listenerName isEqualToString:@"com.gilshahar7.rotatemyscreenListener.clockwise"]) {
		SBOrientationLockManager *orientationLockManager = [%c(SBOrientationLockManager) sharedInstance];
		BOOL wasUserLocked = [orientationLockManager isUserLocked];
		NSInteger orientation =[[UIApplication sharedApplication] _frontMostAppOrientation]; //1->4->2->3
		NSInteger nextOrientation;
		switch (orientation) {
			case 1:
				nextOrientation = 3;
				break;
			case 4:
				nextOrientation = 1;
				break;
			case 2:
				nextOrientation = 4;
				break;
			case 3:
				nextOrientation = 2;
				break;
		}
		[orientationLockManager lock:nextOrientation];
		// Delay execution of my block for 0.2 seconds.
		dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 0.2 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
			if(wasUserLocked == false)
				[orientationLockManager unlock];
		});
  } else if ([listenerName isEqualToString:@"com.gilshahar7.rotatemyscreenListener.counterclockwise"]) {
		SBOrientationLockManager *orientationLockManager = [%c(SBOrientationLockManager) sharedInstance];
		BOOL wasUserLocked = [orientationLockManager isUserLocked];
		NSInteger orientation =[[UIApplication sharedApplication] _frontMostAppOrientation]; //1->4->2->3
		NSInteger nextOrientation;
		switch (orientation) {
			case 1:
				nextOrientation = 4;
				break;
			case 4:
				nextOrientation = 2;
				break;
			case 2:
				nextOrientation = 3;
				break;
			case 3:
				nextOrientation = 1;
				break;
		}
		[orientationLockManager lock:nextOrientation];
		// Delay execution of my block for 0.2 seconds.
		dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 0.2 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
			if(wasUserLocked == false)
				[orientationLockManager unlock];
		});
  }
  [event setHandled:YES];
}

+(void)load {
  @autoreleasepool {
    [[LAActivator sharedInstance] registerListener:[self new] forName:@"com.gilshahar7.rotatemyscreenListener.counterclockwise"];
    [[LAActivator sharedInstance] registerListener:[self new] forName:@"com.gilshahar7.rotatemyscreenListener.clockwise"];
  }
}

- (NSString *)activator:(LAActivator *)activator requiresLocalizedGroupForListenerName:(NSString *)listenerName {
    return @" RotateMyScreen";
}

- (NSString *)activator:(LAActivator *)activator requiresLocalizedTitleForListenerName:(NSString *)listenerName {
  if ([listenerName isEqualToString:@"com.gilshahar7.rotatemyscreenListener.clockwise"]) {
    return @"Rotate clockwise";
  } else if ([listenerName isEqualToString:@"com.gilshahar7.rotatemyscreenListener.counterclockwise"]) {
    return @"Rotate counter clockwise";
  }
  return @"RotateMyScreen";
}
- (NSString *)activator:(LAActivator *)activator requiresLocalizedDescriptionForListenerName:(NSString *)listenerName {
  if ([listenerName isEqualToString:@"com.gilshahar7.rotatemyscreenListener.clockwise"]) {
    return @"Rotate the screen clockwise";
  } else if ([listenerName isEqualToString:@"com.gilshahar7.rotatemyscreenListener.counterclockwise"]) {
    return @"Rotate the screen counter clockwise";
  }
  return @"RotateMyScreen";
}
- (NSArray *)activator:(LAActivator *)activator requiresCompatibleEventModesForListenerWithName:(NSString *)listenerName {
    return [NSArray arrayWithObjects:@"springboard", @"lockscreen", @"application", nil];
}

@end
//Activator - end
