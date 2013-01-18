/*
 
 File: CAShapeLayer+Animation.m
 
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
#import "CAShapeLayer+Animation.h"

@implementation CAShapeLayer (Animation)

- (void)a
{
//    if ([super respondsToSelector:@selector(a)]) {
//        [super a];
//    }
    NSLog(@"implements method b");
}

- (BOOL)animateWithBasicAnimationForKey:(AnimatedPropertyKeys)aPropertyKey
                          animationName:(NSString *)aName
                              fromValue:(id)aValue
                                toValue:(id)bValue
                            forDuration:(CGFloat)aDuration
{
    if (![super animateWithBasicAnimationForKey:aPropertyKey animationName:aName fromValue:aValue toValue:bValue forDuration:aDuration]) {
        CABasicAnimation *animation = nil;
        
        switch (aPropertyKey) {
            case kFillColor: {
                animation = [CABasicAnimation animationWithKeyPath:@"fillColor"];
            }
                break;
            case kLineDashPhase: {
                animation = [CABasicAnimation animationWithKeyPath:@"lineDashPhase"];
            }
                break;
            case kLineWidth: {
                animation = [CABasicAnimation animationWithKeyPath:@"lineWidth"];
            }
                break;
            case kMiterLimit: {
                animation = [CABasicAnimation animationWithKeyPath:@"miterLimit"];
            }
                break;
            case kPath: {
                animation = [CABasicAnimation animationWithKeyPath:@"path"];
            }
                break;
            case kStrokeColor: {
                animation = [CABasicAnimation animationWithKeyPath:@"strokeColor"];
            }
                break;
            case kStrokeEnd: {
                animation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
            }
                break;
            case kStrokeStart: {
                animation = [CABasicAnimation animationWithKeyPath:@"strokeStart"];
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
    
    return YES;
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
        case kLineWidth: {
            
        }
            break;
        case kMiterLimit: {
            
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
        case kStrokeEnd: {
            
        }
            break;
        case kStrokeStart: {
            
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

@end
