##BounceQuest
  
Yet to find an easing curve that feels _right_, for many animations, despite the massive list of resources on the subject. The library is a journal to the quest for that elusive curve, and tools crafted or found along the way  
  
###List of resources  
  
####Articles
__Jeff Lamarche__ http://iphonedevelopment.blogspot.sg/2010/12/more-animation-curves-than-you-can.html  
__Matt Gallagher__ http://www.cocoawithlove.com/2008/09/parametric-acceleration-curves-in-core.html  
__Robert Penner__ http://www.robertpenner.com/easing/  
__Soroush Khanlou__ http://khanlou.com/2012/01/cakeyframeanimation-make-it-bounce/  
__Cocoanetics__ https://www.cocoanetics.com/2012/06/lets-bounce/  
  
####Visualizers
__Andrey Sitnik__ http://easings.net/  
__Robert Penner__ http://gizma.com/easing/  
__Timothee Groleau__ http://www.timotheegroleau.com/Flash/experiments/easing_function_generator.htm  

--

###Source Breakdown
__UILayerAnimation__ Main header file, also includes colour conversion functions (unverified) between RGB, XYZ, and [CIEL*ab](http://en.wikipedia.org/wiki/Lab_color_space) colour spaces  
__CALayer+Animation__ Category for CALayer custom curve animation, also tests setting associative references on category  
__CAShapeLayer+Animation__ Category for CAShapeLayer custom curve animation, also tests setting associative references on category  
__easing__ Taken from [AHEasing](https://github.com/warrenm/AHEasing)  
__UIColor+CrossFade__ Taken from [UIColor-CrossFade](https://github.com/cbpowell/UIColor-CrossFade)  
__UITransformableBezierPath__, __NonOpaquePathRepresentation__ Transforms points in UIBezierPath or CGPath to an nsarray for easy access, and recreate an interpolated path from points in the array  

--

###Credits for source
[Warren Moore](https://github.com/warrenm) for AHEasing  
[Charles Powell](https://github.com/cbpowell) for UIColor-CrossFade  

--

http://twitter.com/dilliontan