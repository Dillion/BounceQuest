/*
 
 File: UILayerAnimation.h
 
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

#import <QuartzCore/QuartzCore.h>
#import "easing.h"
#import "UITransformableBezierPath.h"
#import "UIColor+CrossFade.h"

typedef enum {
    
    // CALayer properties
    kAnchorPoint,
    /* use case: interpolating color for touch/transition change */
    kBackgroundColor,
    /* use case: interpolating color for touch/transition change */
    kBorderColor,
    kBorderWidth,
    kBounds,
    /* use case: fade in/out image contents */
    kContents,
    /* use case: wipe in/out image contents */
    kContentsRect,
    /* use case: selection hint */
    kCornerRadius,
    kDoubleSided,
    kHidden,
    kMask,
    kMasksToBounds,
    kOpacity,
    kPosition,
    kShadowColor,
    kShadowOffset,
    kShadowOpacity,
    kShadowRadius,
    kTransform,             // keyframe not supported
    kTransformScale,        // keyframe doesnt stack (need to figure out how to preserve preexisting matrix values)
    kTransformTranslate,    // keyframe doesnt stack (need to figure out how to preserve preexisting matrix values)
    kTransformRotate,       // keyframe doesnt stack (need to figure out how to preserve preexisting matrix values)
    
    
    
    // CAShapeLayer properties
    kFillColor,
    kLineDashPhase,
    kLineWidth,
    kMiterLimit,
    kPath,
    kStrokeColor,
    kStrokeEnd,
    kStrokeStart,
    
    
    // currently unsupported
    kBackgroundFilters,
    kCompositingFilter,
    kFilters,
    kSublayers,
    kSublayerTransform,
    kZPosition,
} AnimatedPropertyKeys;

typedef struct {
    float x;
    float y;
    float z;
} Color3F;

// Advanced color conversion
// XYZ, CIEL*ab http://www.easyrgb.com/index.php?X=MATH
static inline Color3F convertRGBtoXYZ(Color3F color) {
    float var_R = color.x/255;
    float var_G = color.y/255;
    float var_B = color.z/255;
    
    if (var_R > 0.04045) {
        var_R = pow(((var_R + 0.055) / 1.055),2.4);
    } else {
        var_R = var_R / 12.92;
    }
    if (var_G > 0.04045) {
        var_G = pow(((var_G + 0.055) / 1.055),2.4);
    } else {
        var_G = var_G / 12.92;
    }
    if (var_B > 0.04045) {
        var_B = pow(((var_B + 0.055) / 1.055),2.4);
    } else {
        var_B = var_B / 12.92;
    }
    
    var_R = var_R * 100;
    var_G = var_G * 100;
    var_B = var_B * 100;
    
    //Observer. = 2°, Illuminant = D65
    float X = var_R * 0.4124 + var_G * 0.3576 + var_B * 0.1805;
    float Y = var_R * 0.2126 + var_G * 0.7152 + var_B * 0.0722;
    float Z = var_R * 0.0193 + var_G * 0.1192 + var_B * 0.9505;
    
    Color3F xyzColor;
    xyzColor.x = X;
    xyzColor.y = Y;
    xyzColor.z = Z;
    
    return xyzColor;
}

static inline Color3F convertXYZtoRGB(Color3F color) {
    float var_X = color.x/100;
    float var_Y = color.y/100;
    float var_Z = color.z/100;
    
    float var_R = var_X *  3.2406 + var_Y * -1.5372 + var_Z * -0.4986;
    float var_G = var_X * -0.9689 + var_Y *  1.8758 + var_Z *  0.0415;
    float var_B = var_X *  0.0557 + var_Y * -0.2040 + var_Z *  1.0570;
    
    if ( var_R > 0.0031308 ) {
        var_R = 1.055 * ( pow(var_R,( 1.0 / 2.4 )) ) - 0.055;
    } else {
        var_R = 12.92 * var_R;
    }
    if ( var_G > 0.0031308 ) {
        var_G = 1.055 * ( pow(var_G,( 1.0 / 2.4 )) ) - 0.055;
    } else {
        var_G = 12.92 * var_G;
    }
    if ( var_B > 0.0031308 ) {
        var_B = 1.055 * ( pow(var_B,( 1.0 / 2.4 )) ) - 0.055;
    } else {
        var_B = 12.92 * var_B;
    }
    
    Color3F rgbColor;
    rgbColor.x = var_R * 255;
    rgbColor.y = var_G * 255;
    rgbColor.z = var_B * 255;
    
    return rgbColor;
}

static inline Color3F convertXYZtoCIEL(Color3F color) {
    float var_X = color.x / 95.047;          //ref_X =  95.047   Observer= 2°, Illuminant= D65
    float var_Y = color.y / 100.000;          //ref_Y = 100.000
    float var_Z = color.z / 108.883;          //ref_Z = 108.883
    
    if (var_X > 0.008856) {
        var_X = pow(var_X,( 1.0/3 ));
    } else {
        var_X = (7.787 * var_X) + (16.0 / 116);
    }
    if (var_Y > 0.008856) {
        var_Y = pow(var_Y,( 1.0/3 ));
    } else {
        var_Y = (7.787 * var_Y) + (16.0 / 116);
    }
    if (var_Z > 0.008856) {
        var_Z = pow(var_Z,( 1.0/3 ));
    } else {
        var_Z = (7.787 * var_Z) + (16.0 / 116);
    }
    
    Color3F cielColor;
    cielColor.x = ( 116 * var_Y ) - 16;
    cielColor.y = 500 * ( var_X - var_Y );
    cielColor.z = 200 * ( var_Y - var_Z );
    
    return cielColor;
}

static inline Color3F convertCIELtoXYZ(Color3F color) {
    float var_Y = ( color.x + 16 ) / 116;
    float var_X = color.y / 500 + var_Y;
    float var_Z = var_Y - color.z / 200;
    
    if ( pow(var_Y,3) > 0.008856 ) {
        var_Y = pow(var_Y,3);
    } else {
        var_Y = (var_Y - 16 / 116) / 7.787;
    }
    if ( pow(var_X,3) > 0.008856 ) {
        var_X = pow(var_X,3);
    }else {
        var_X = (var_X - 16 / 116) / 7.787;
    }
    if ( pow(var_Z,3) > 0.008856 ) {
        var_Z = pow(var_Z,3);
    } else {
        var_Z = ( var_Z - 16 / 116 ) / 7.787;
    }
    
    Color3F xyzColor;
    xyzColor.x = 95.047 * var_X;     //ref_X =  95.047     Observer= 2°, Illuminant= D65
    xyzColor.y = 100.000 * var_Y;     //ref_Y = 100.000
    xyzColor.z = 108.883 * var_Z;       //ref_Z = 108.883
    return xyzColor;
}

static inline Color3F intermediateRGBusingCIELscale(Color3F startColor, Color3F endColor, float percentage) {
    
    Color3F convertedStartColor = convertXYZtoCIEL(convertRGBtoXYZ(startColor));
    Color3F convertedEndColor = convertXYZtoCIEL(convertRGBtoXYZ(endColor));
    
    Color3F intermediateCIELColor;
    intermediateCIELColor.x = (convertedStartColor.x + convertedEndColor.x)*percentage;
    intermediateCIELColor.y = (convertedStartColor.y + convertedEndColor.y)*percentage;
    intermediateCIELColor.z = (convertedStartColor.z + convertedEndColor.z)*percentage;
    
    Color3F intermediateRGBColor = convertXYZtoRGB(convertCIELtoXYZ(intermediateCIELColor));
    return intermediateRGBColor;
}
