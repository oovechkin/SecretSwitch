SecretSwitch
============
Protect your secret info while switching apps.

##Demo

Like this:

![demo](https://raw2.github.com/croath/SecretSwitch/master/demo.gif)

##How to

    #import "SecretSwitch.h"

and then add this to your `application:didFinishLaunchingWithOptions:` method:

	[SecretSwitch protectSecret];

You can specify the resolution and blur with the following options. Refer to the method documentation to see how the parameters are handled.

    [SecretSwitch setBlurFactor:5];
    [SecretSwitch setResolutionFactor:4];
