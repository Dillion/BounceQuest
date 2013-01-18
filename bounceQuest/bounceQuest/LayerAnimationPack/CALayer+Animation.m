/*
 
 File: CALayer+Animation.m
 
 Copyright (c) 2012 Dillion Tan
 
 Permission is hereby granted, free of charge, to any person
 obtaining a copy of this software and associated documentation
 files (the "Software"), to deal in the Software without
 restriction, including without limitation the rights to use,
 copy, modify, merge, publish, distribute, sublicense, and/or sell
 copies of the Software, and to permit persons to whom the
 Software is furnished to do so, subject to the following
 conditions:
 
 The above copyright notice and this permission notice shall be
 included in all copies or substantial portions of the Software.
 
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
 EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
 OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
 NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
 HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
 WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
 FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
 OTHER DEALINGS IN THE SOFTWARE.
 
 */

#import "CALayer+Animation.h"
#import <objc/runtime.h>

static char const *const RepeatingKeyArray = "RepeatingKeyArray";

@implementation CALayer (Animation)

@dynamic repeatingKeyArray;

- (void)a
{
    NSLog(@"implements method a");
}

- (BOOL)animateWithBasicAnimationForKey:(AnimatedPropertyKeys)aPropertyKey
                          animationName:(NSString *)aName
                              fromValue:(id)aValue
                                toValue:(id)bValue
                            forDuration:(CGFloat)aDuration
{
    CABasicAnimation *animation = nil;
    
    switch (aPropertyKey) {
        case kAnchorPoint: {
            animation = [CABasicAnimation animationWithKeyPath:@"anchorPoint"];
        }
            break;
        case kBackgroundColor: {
            animation = [CABasicAnimation animationWithKeyPath:@"backgroundColor"];
        }
            break;
        case kBorderColor: {
            animation = [CABasicAnimation animationWithKeyPath:@"borderColor"];
        }
            break;
        case kBorderWidth: {
            animation = [CABasicAnimation animationWithKeyPath:@"borderWidth"];
        }
            break;
        case kBounds: {
            animation = [CABasicAnimation animationWithKeyPath:@"bounds"];
        }
            break;
        case kContents: {
            animation = [CABasicAnimation animationWithKeyPath:@"contents"];
        }
            break;
        case kContentsRect: {
            animation = [CABasicAnimation animationWithKeyPath:@"contentsRect"];
        }
            break;
        case kCornerRadius: {
            animation = [CABasicAnimation animationWithKeyPath:@"cornerRadius"];
        }
            break;
        case kDoubleSided: {
            animation = [CABasicAnimation animationWithKeyPath:@"doubleSided"];
        }
            break;
        case kHidden: {
            animation = [CABasicAnimation animationWithKeyPath:@"hidden"];
        }
            break;
        case kMask: {
            animation = [CABasicAnimation animationWithKeyPath:@"mask"];
        }
            break;
        case kMasksToBounds: {
            animation = [CABasicAnimation animationWithKeyPath:@"masksToBounds"];
        }
            break;
        case kOpacity: {
            animation = [CABasicAnimation animationWithKeyPath:@"opacity"];
        }
            break;
        case kPosition: {
            animation = [CABasicAnimation animationWithKeyPath:@"position"];
        }
            break;
        case kShadowColor: {
            animation = [CABasicAnimation animationWithKeyPath:@"shadowColor"];
        }
            break;
        case kShadowOffset: {
            animation = [CABasicAnimation animationWithKeyPath:@"shadowOffset"];
        }
            break;
        case kShadowOpacity: {
            animation = [CABasicAnimation animationWithKeyPath:@"shadowOpacity"];
        }
            break;
        case kShadowRadius: {
            animation = [CABasicAnimation animationWithKeyPath:@"shadowRadius"];
        }
            break;
        case kTransform: {
            animation = [CABasicAnimation animationWithKeyPath:@"transform"];
        }
            break;
        case kTransformScale: {
            animation = [CABasicAnimation animationWithKeyPath:@"transform"];
        }
            break;
        case kTransformTranslate: {
            animation = [CABasicAnimation animationWithKeyPath:@"transform"];
        }
            break;
        case kTransformRotate: {
            animation = [CABasicAnimation animationWithKeyPath:@"transform"];
        }
            break;
        
        default:
            break;
    }
    
    if (animation) {
        
        [CATransaction begin];
        
        animation.fromValue = aValue;
        animation.toValue = bValue;
        animation.duration = aDuration;
        animation.removedOnCompletion = NO;
        animation.beginTime = CACurrentMediaTime();
        animation.fillMode = kCAFillModeForwards;
        animation.delegate = self;
        [self addAnimation:animation forKey:aName];
        
        [CATransaction commit];
        
        return YES;
    } else {
        return NO;
    }
}

- (BOOL)animateWithKeyframeAnimationForKey:(AnimatedPropertyKeys)aPropertyKey
                             animationName:(NSString *)aName
                                 fromValue:(id)aValue
                                   toValue:(id)bValue
                               forDuration:(CGFloat)aDuration
                              withFunction:(AHEasingFunction)aFunction
{
    CAKeyframeAnimation *animation = nil;
    
    switch (aPropertyKey) {
        case kAnchorPoint: {
            
        }
            break;
        case kBackgroundColor: {
            UIColor *fromColor = (UIColor *)aValue;
            UIColor *toColor = (UIColor *)bValue;
            
            NSMutableArray *values = [NSMutableArray arrayWithCapacity:DefaultKeyframeCount];
            
            CGFloat t = 0.0;
            CGFloat dt = 1.0 / (DefaultKeyframeCount - 1);
            for(size_t frame = 0; frame < DefaultKeyframeCount; ++frame, t += dt)
            {
                float timing = aFunction(t);
                UIColor *newColor = [UIColor colorForFadeBetweenFirstColor:fromColor secondColor:toColor atRatio:timing];
                [values addObject:(__bridge id)newColor.CGColor];
            }
            
            animation = [CABasicAnimation animationWithKeyPath:@"backgroundColor"];
            animation.values = values;
        }
            break;
        case kBorderColor: {
            UIColor *fromColor = (UIColor *)aValue;
            UIColor *toColor = (UIColor *)bValue;
            
            NSMutableArray *values = [NSMutableArray arrayWithCapacity:DefaultKeyframeCount];
            
            CGFloat t = 0.0;
            CGFloat dt = 1.0 / (DefaultKeyframeCount - 1);
            for(size_t frame = 0; frame < DefaultKeyframeCount; ++frame, t += dt)
            {
                float timing = aFunction(t);
                UIColor *newColor = [UIColor colorForFadeBetweenFirstColor:fromColor secondColor:toColor atRatio:timing];
                [values addObject:(__bridge id)newColor.CGColor];
            }
            
            animation = [CABasicAnimation animationWithKeyPath:@"borderColor"];
            animation.values = values;
        }
            break;
        case kTransformScale: {
            CATransform3D fromTransform = [(NSValue *)aValue CATransform3DValue];
            CATransform3D toTransform = [(NSValue *)bValue CATransform3DValue];
            
            NSMutableArray *values = [NSMutableArray arrayWithCapacity:DefaultKeyframeCount];
            
            CGFloat t = 0.0;
            CGFloat dt = 1.0 / (DefaultKeyframeCount - 1);
            for(size_t frame = 0; frame < DefaultKeyframeCount; ++frame, t += dt)
            {
                float timing = aFunction(t);
                NSValue *newTransform = [NSValue valueWithCATransform3D:CATransform3DScale(fromTransform, 1+toTransform.m11*timing, 1+toTransform.m22*timing, 1+toTransform.m33*timing)];
                [values addObject:newTransform];
            }
            
            animation = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
            animation.values = values;
        }
            break;
        case kTransformTranslate: {
            CATransform3D fromTransform = [(NSValue *)aValue CATransform3DValue];
            CATransform3D toTransform = [(NSValue *)bValue CATransform3DValue];
            
            NSMutableArray *values = [NSMutableArray arrayWithCapacity:DefaultKeyframeCount];
            
            CGFloat t = 0.0;
            CGFloat dt = 1.0 / (DefaultKeyframeCount - 1);
            for(size_t frame = 0; frame < DefaultKeyframeCount; ++frame, t += dt)
            {
                float timing = aFunction(t);
                NSValue *newTransform = [NSValue valueWithCATransform3D:CATransform3DTranslate(fromTransform, toTransform.m41*timing, toTransform.m42*timing, toTransform.m43*timing)];
                [values addObject:newTransform];
            }
            
            animation = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
            animation.values = values;
        }
            break;
        case kTransformRotate: {
            CATransform3D fromTransform = [(NSValue *)aValue CATransform3DValue];
            NSDictionary *toTransformDictionary = (NSDictionary *)bValue;
            float angle = [[toTransformDictionary objectForKey:@"angle"] floatValue];
            float vecX = [[toTransformDictionary objectForKey:@"vecX"] floatValue];
            float vecY = [[toTransformDictionary objectForKey:@"vecY"] floatValue];
            float vecZ = [[toTransformDictionary objectForKey:@"vecZ"] floatValue];
            
            NSMutableArray *values = [NSMutableArray arrayWithCapacity:DefaultKeyframeCount];
            
            CGFloat t = 0.0;
            CGFloat dt = 1.0 / (DefaultKeyframeCount - 1);
            for(size_t frame = 0; frame < DefaultKeyframeCount; ++frame, t += dt)
            {
                float timing = aFunction(t);
                NSValue *newTransform = [NSValue valueWithCATransform3D:CATransform3DRotate(fromTransform, angle*timing, vecX, vecY, vecZ)];
                [values addObject:newTransform];
            }
            
            animation = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
            animation.values = values;
        }
            break;
        case kBounds: {
            
            CGRect fromRect = [(NSValue *)aValue CGRectValue];
            CGRect toRect = [(NSValue *)bValue CGRectValue];
            
            NSMutableArray *values = [NSMutableArray arrayWithCapacity:DefaultKeyframeCount];
            
            CGFloat t = 0.0;
            CGFloat dt = 1.0 / (DefaultKeyframeCount - 1);
            for(size_t frame = 0; frame < DefaultKeyframeCount; ++frame, t += dt)
            {
                float timing = aFunction(t);
                CGRect newRect = CGRectMake(fromRect.origin.x + (toRect.origin.x - fromRect.origin.x)*timing,
                                            fromRect.origin.y + (toRect.origin.y - fromRect.origin.y)*timing,
                                            fromRect.size.width + (toRect.size.width - fromRect.size.width)*timing,
                                            fromRect.size.height + (toRect.size.height - fromRect.size.height)*timing);
                [values addObject:[NSValue valueWithCGRect:newRect]];
            }
            
            animation = [CAKeyframeAnimation animationWithKeyPath:@"bounds"];
            animation.values = values;
        }
            break;
        case kPosition: {
            
            CGPoint fromPoint = [(NSValue *)aValue CGPointValue];
            CGPoint toPoint = [(NSValue *)bValue CGPointValue];
            
            NSMutableArray *values = [NSMutableArray arrayWithCapacity:DefaultKeyframeCount];
            
            CGFloat t = 0.0;
            CGFloat dt = 1.0 / (DefaultKeyframeCount - 1);
            for(size_t frame = 0; frame < DefaultKeyframeCount; ++frame, t += dt)
            {
                float timing = aFunction(t);
                CGPoint newPoint = CGPointMake(fromPoint.x + (toPoint.x - fromPoint.x)*timing,
                                               fromPoint.y + (toPoint.y - fromPoint.y)*timing);
                [values addObject:[NSValue valueWithCGPoint:newPoint]];
            }
            
            animation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
            animation.values = values;
        }
            break;
        case kPath: {
            UITransformableBezierPath *fromPath = (UITransformableBezierPath *)aValue;
            UITransformableBezierPath *toPath = (UITransformableBezierPath *)bValue;
            
            CGSize originalSize = fromPath.sizeHint;
            CGSize newSize = toPath.sizeHint;
            
            NSMutableArray *values = [NSMutableArray arrayWithCapacity:DefaultKeyframeCount];
            
            CGFloat t = 0.0;
            CGFloat dt = 1.0 / (DefaultKeyframeCount - 1);
            for(size_t frame = 0; frame < DefaultKeyframeCount; ++frame, t += dt)
            {
                float timing = aFunction(t);
                UITransformableBezierPath *newPath = [fromPath interpolatedPathWithPath:toPath atTiming:timing];
                [newPath applyTransform:CGAffineTransformMakeTranslation(-(originalSize.width + (newSize.width - originalSize.width)*timing)/2,-(originalSize.height + (newSize.height - originalSize.height)*timing)/2)];
                [values addObject:(__bridge id)newPath.CGPath];
            }
            
            animation = [CAKeyframeAnimation animationWithKeyPath:@"path"];
            animation.values = values;
        }
            break;
        case kFillColor: {
            UIColor *fromColor = (UIColor *)aValue;
            UIColor *toColor = (UIColor *)bValue;
            
            NSMutableArray *values = [NSMutableArray arrayWithCapacity:DefaultKeyframeCount];
            
            CGFloat t = 0.0;
            CGFloat dt = 1.0 / (DefaultKeyframeCount - 1);
            for(size_t frame = 0; frame < DefaultKeyframeCount; ++frame, t += dt)
            {
                float timing = aFunction(t);
                UIColor *newColor = [UIColor colorForFadeBetweenFirstColor:fromColor secondColor:toColor atRatio:timing];
                [values addObject:(__bridge id)newColor.CGColor];
            }
            
            animation = [CAKeyframeAnimation animationWithKeyPath:@"fillColor"];
            animation.values = values;
        }
            break;
        case kStrokeColor: {
            UIColor *fromColor = (UIColor *)aValue;
            UIColor *toColor = (UIColor *)bValue;
            
            NSMutableArray *values = [NSMutableArray arrayWithCapacity:DefaultKeyframeCount];
            
            CGFloat t = 0.0;
            CGFloat dt = 1.0 / (DefaultKeyframeCount - 1);
            for(size_t frame = 0; frame < DefaultKeyframeCount; ++frame, t += dt)
            {
                float timing = aFunction(t);
                UIColor *newColor = [UIColor colorForFadeBetweenFirstColor:fromColor secondColor:toColor atRatio:timing];
                [values addObject:(__bridge id)newColor.CGColor];
            }
            
            animation = [CAKeyframeAnimation animationWithKeyPath:@"strokeColor"];
            animation.values = values;
        }
            break;
        case kLineDashPhase: {
            float fromPhase = [(NSNumber *)aValue floatValue];
            float toPhase = [(NSNumber *)bValue floatValue];
            
            NSMutableArray *values = [NSMutableArray arrayWithCapacity:DefaultKeyframeCount];
            
            CGFloat t = 0.0;
            CGFloat dt = 1.0 / (DefaultKeyframeCount - 1);
            for(size_t frame = 0; frame < DefaultKeyframeCount; ++frame, t += dt)
            {
                float timing = aFunction(t);
                float newPhase = fromPhase+(toPhase-fromPhase)*timing;
                [values addObject:[NSNumber numberWithFloat:newPhase]];
            }
            
            animation = [CAKeyframeAnimation animationWithKeyPath:@"lineDashPhase"];
            animation.values = values;
        }
            break;
        default:
            break;
    }
    
    if (animation) {
        [CATransaction begin];
        
        animation.duration = aDuration;
        animation.removedOnCompletion = NO;
        animation.beginTime = CACurrentMediaTime();
        animation.fillMode = kCAFillModeForwards;
        animation.delegate = self;
        [self addAnimation:animation forKey:aName];
        
        [CATransaction commit];
        
        return YES;
    } else {
        return NO;
    }
}

- (NSArray *)repeatingKeyArray {
    return objc_getAssociatedObject(self, RepeatingKeyArray);
}

- (void)setRepeatingKeyArray:(NSMutableArray *)repeatingKeyArray {
    objc_setAssociatedObject(self, RepeatingKeyArray, repeatingKeyArray, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
    if (flag) {
//        NSLog(@"%@ value %@ valuefunction %@", [anim debugDescription], [anim valueForKeyPath:@"path"], [anim valueFunction]);
//        NSLog(@"animations %@", self.animationKeys);
        
        CABasicAnimation *currentAnimation = (CABasicAnimation *)[anim copy];
        
        for (NSString *repeatingKey in self.repeatingKeyArray) {
            if ([repeatingKey compare:currentAnimation.keyPath] == NSOrderedSame) {
                [CATransaction begin];
                
                [self addAnimation:[currentAnimation copy] forKey:repeatingKey];
                
                [CATransaction commit];
                break;
            }
        }
    }
}

- (void)addRepeatingKeyPath:(AnimatedPropertyKeys)aPropertyKey
{
    NSMutableArray *keyArray = self.repeatingKeyArray;
    if (!keyArray) {
        keyArray = [NSMutableArray array];
    }
    
    switch (aPropertyKey) {
        case kAnchorPoint: {
            [keyArray addObject:@"anchorPoint"];
        }
            break;
        case kBackgroundColor: {
            [keyArray addObject:@"backgroundColor"];
        }
            break;
        case kBorderColor: {
            [keyArray addObject:@"borderColor"];
        }
            break;
        case kBorderWidth: {
            [keyArray addObject:@"borderWidth"];
        }
            break;
        case kBounds: {
            [keyArray addObject:@"bounds"];
        }
            break;
        case kContents: {
            [keyArray addObject:@"contents"];
        }
            break;
        case kContentsRect: {
            [keyArray addObject:@"contentsRect"];
        }
            break;
        case kCornerRadius: {
            [keyArray addObject:@"cornerRadius"];
        }
            break;
        case kDoubleSided: {
            [keyArray addObject:@"doubleSided"];
        }
            break;
        case kHidden: {
            [keyArray addObject:@"hidden"];
        }
            break;
        case kMask: {
            [keyArray addObject:@"mask"];
        }
            break;
        case kMasksToBounds: {
            [keyArray addObject:@"masksToBounds"];
        }
            break;
        case kOpacity: {
            [keyArray addObject:@"opacity"];
        }
            break;
        case kPosition: {
            [keyArray addObject:@"position"];
        }
            break;
        case kShadowColor: {
            [keyArray addObject:@"shadowColor"];
        }
            break;
        case kShadowOffset: {
            [keyArray addObject:@"shadowOffset"];
        }
            break;
        case kShadowOpacity: {
            [keyArray addObject:@"shadowOpacity"];
        }
            break;
        case kShadowRadius: {
            [keyArray addObject:@"shadowRadius"];
        }
            break;
        case kTransform: {
            [keyArray addObject:@"transform"];
        }
            break;
        case kTransformScale: {
            [keyArray addObject:@"transform"];
        }
            break;
        case kTransformTranslate: {
            [keyArray addObject:@"transform"];
        }
            break;
        case kTransformRotate: {
            [keyArray addObject:@"transform"];
        }
            break;
        default:break;
    }
    
    [self setRepeatingKeyArray:keyArray];
}

@end
