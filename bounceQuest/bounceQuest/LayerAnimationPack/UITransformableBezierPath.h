/*
 
 File: UITransformableBezierPath.h
 
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

#import <UIKit/UIKit.h>
#import "NonOpaquePathRepresentation.h"

static void objectifyPathApplier(void* info, const CGPathElement* element)
{
    NonOpaquePathRepresentation *pathRepresentation = (__bridge NonOpaquePathRepresentation *)info;
    
	int nPoints;
	switch (element->type)
	{
		case kCGPathElementMoveToPoint:
			nPoints = 1;
			break;
		case kCGPathElementAddLineToPoint:
			nPoints = 1;
			break;
		case kCGPathElementAddQuadCurveToPoint:
			nPoints = 2;
			break;
		case kCGPathElementAddCurveToPoint:
			nPoints = 3;
			break;
		case kCGPathElementCloseSubpath:
			nPoints = 0;
			break;
		default:
			return;
	}
    
    NSMutableDictionary *newElement = [NSMutableDictionary dictionary];
    [newElement setObject:[NSNumber numberWithInt:element->type] forKey:@"type"];
    NSMutableArray *elementPoints = [NSMutableArray arrayWithCapacity:3];
    
    for (int i = 0; i < nPoints; i++) {
        [elementPoints addObject:[NSValue valueWithCGPoint:element->points[i]]];
    }
    
    [newElement setObject:elementPoints forKey:@"points"];
    [pathRepresentation.elementArray addObject:newElement];
}

@interface UITransformableBezierPath : UIBezierPath

@property (nonatomic, strong) NonOpaquePathRepresentation *pathRepresentation;

@property (nonatomic) CGSize sizeHint;

- (id)initWithBezierPath:(UIBezierPath *)aPath
                sizeHint:(CGSize)aSize;
- (id)initWithCGPath:(CGPathRef)aPath
            sizeHint:(CGSize)aSize;

- (UITransformableBezierPath *)interpolatedPathWithPath:(UITransformableBezierPath *)aPath
                                               atTiming:(CGFloat)interpolationTiming;

@end
