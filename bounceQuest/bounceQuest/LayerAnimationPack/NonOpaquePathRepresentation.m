/*
 
 File: NonOpaquePathRepresentation.h
 
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

#import "NonOpaquePathRepresentation.h"

@implementation NonOpaquePathRepresentation

@synthesize elementArray;

- (id)init
{
    self = [super init];
    if (self) {
        
        self.elementArray = [NSMutableArray array];
    }
    return self;
}

- (CGPathRef)createPathFromElements
{
    CGMutablePathRef pathRef = CGPathCreateMutable();
    for (NSDictionary *elementDictionary in elementArray) {
        int elementType = [[elementDictionary objectForKey:@"type"] intValue];
        NSArray *elementPoints = [elementDictionary objectForKey:@"points"];
        
        switch (elementType) {
            case kCGPathElementMoveToPoint: {
                CGPoint point1 = [[elementPoints objectAtIndex:0] CGPointValue];
                CGPathMoveToPoint(pathRef, NULL, point1.x, point1.y);
            }
                break;
            case kCGPathElementAddLineToPoint: {
                CGPoint point1 = [[elementPoints objectAtIndex:0] CGPointValue];
                CGPathAddLineToPoint(pathRef, NULL, point1.x, point1.y);
            }
                break;
            case kCGPathElementAddQuadCurveToPoint: {
                CGPoint point1 = [[elementPoints objectAtIndex:0] CGPointValue];
                CGPoint point2 = [[elementPoints objectAtIndex:1] CGPointValue];
                CGPathAddQuadCurveToPoint(pathRef, NULL, point1.x, point1.y, point2.x, point2.y);
            }
                break;
            case kCGPathElementAddCurveToPoint: {
                CGPoint point1 = [[elementPoints objectAtIndex:0] CGPointValue];
                CGPoint point2 = [[elementPoints objectAtIndex:1] CGPointValue];
                CGPoint point3 = [[elementPoints objectAtIndex:2] CGPointValue];
                CGPathAddCurveToPoint(pathRef, NULL, point1.x, point1.y, point2.x, point2.y, point3.x, point3.y);
            }
                break;
            case kCGPathElementCloseSubpath:
                CGPathCloseSubpath(pathRef);
                break;
            default:
                break;
        }
    }
    
    return pathRef;
}

- (CGPathRef)createInterpolatedPathReferencingPath:(NonOpaquePathRepresentation *)aPath
                                            timing:(CGFloat)aTiming
{
    CGMutablePathRef pathRef = CGPathCreateMutable();
    int fromPathCount = [elementArray count];
    int toPathCount = [aPath.elementArray count];
    if (fromPathCount == toPathCount) {
        int index = 0;
        for (NSDictionary *elementDictionary in elementArray) {
            NSDictionary *toElementDictionary = [aPath.elementArray objectAtIndex:index];
            
            int elementType = [[elementDictionary objectForKey:@"type"] intValue];
            NSArray *elementPoints = [elementDictionary objectForKey:@"points"];
            NSArray *toElementPoints = [toElementDictionary objectForKey:@"points"];
            
            switch (elementType) {
                case kCGPathElementMoveToPoint: {
                    CGPoint fromPoint = [[elementPoints objectAtIndex:0] CGPointValue];
                    CGPoint toPoint = [[toElementPoints objectAtIndex:0] CGPointValue];
                    
                    CGPoint newPoint = CGPointMake(fromPoint.x + (toPoint.x - fromPoint.x)*aTiming,
                                                   fromPoint.y + (toPoint.y - fromPoint.y)*aTiming);
                    
                    CGPathMoveToPoint(pathRef, NULL, newPoint.x, newPoint.y);
                }
                    break;
                case kCGPathElementAddLineToPoint: {
                    CGPoint fromPoint = [[elementPoints objectAtIndex:0] CGPointValue];
                    CGPoint toPoint = [[toElementPoints objectAtIndex:0] CGPointValue];
                    
                    CGPoint newPoint = CGPointMake(fromPoint.x + (toPoint.x - fromPoint.x)*aTiming,
                                                   fromPoint.y + (toPoint.y - fromPoint.y)*aTiming);
                    
                    CGPathAddLineToPoint(pathRef, NULL, newPoint.x, newPoint.y);
                }
                    break;
                case kCGPathElementAddQuadCurveToPoint: {
                    CGPoint fromPoint = [[elementPoints objectAtIndex:0] CGPointValue];
                    CGPoint toPoint = [[toElementPoints objectAtIndex:0] CGPointValue];
                    
                    CGPoint newPoint = CGPointMake(fromPoint.x + (toPoint.x - fromPoint.x)*aTiming,
                                                   fromPoint.y + (toPoint.y - fromPoint.y)*aTiming);
                    
                    CGPoint fromPoint2 = [[elementPoints objectAtIndex:1] CGPointValue];
                    CGPoint toPoint2 = [[toElementPoints objectAtIndex:1] CGPointValue];
                    
                    CGPoint newPoint2 = CGPointMake(fromPoint2.x + (toPoint2.x - fromPoint2.x)*aTiming,
                                                    fromPoint2.y + (toPoint2.y - fromPoint2.y)*aTiming);
                    
                    CGPathAddQuadCurveToPoint(pathRef, NULL, newPoint.x, newPoint.y, newPoint2.x, newPoint2.y);
                }
                    break;
                case kCGPathElementAddCurveToPoint: {
                    CGPoint fromPoint = [[elementPoints objectAtIndex:0] CGPointValue];
                    CGPoint toPoint = [[toElementPoints objectAtIndex:0] CGPointValue];
                    
                    CGPoint newPoint = CGPointMake(fromPoint.x + (toPoint.x - fromPoint.x)*aTiming,
                                                   fromPoint.y + (toPoint.y - fromPoint.y)*aTiming);
                    
                    CGPoint fromPoint2 = [[elementPoints objectAtIndex:1] CGPointValue];
                    CGPoint toPoint2 = [[toElementPoints objectAtIndex:1] CGPointValue];
                    
                    CGPoint newPoint2 = CGPointMake(fromPoint2.x + (toPoint2.x - fromPoint2.x)*aTiming,
                                                    fromPoint2.y + (toPoint2.y - fromPoint2.y)*aTiming);
                    
                    CGPoint fromPoint3 = [[elementPoints objectAtIndex:2] CGPointValue];
                    CGPoint toPoint3 = [[toElementPoints objectAtIndex:2] CGPointValue];
                    
                    CGPoint newPoint3 = CGPointMake(fromPoint3.x + (toPoint3.x - fromPoint3.x)*aTiming,
                                                    fromPoint3.y + (toPoint3.y - fromPoint3.y)*aTiming);
                    
                    CGPathAddCurveToPoint(pathRef, NULL, newPoint.x, newPoint.y, newPoint2.x, newPoint2.y, newPoint3.x, newPoint3.y);
                }
                    break;
                case kCGPathElementCloseSubpath: {
                    CGPathCloseSubpath(pathRef);
                }
                    break;
                default:
                    break;
                    
            }
            index++;
        }
    }
    
    return pathRef;
}

@end
