//
//  UIView+ForceLTR.m
//  UIViewForceLTR
//
//  Created by Ahmed Khalaf on 11/14/17.
//

#import "UIView+ForceLTR.h"
#import <objc/runtime.h>

@implementation UIView (ForceLTR)

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        Class class = [self class];
        
        SEL originalSelector = @selector(awakeFromNib);
        SEL swizzledSelector = @selector(xxx_awakeFromNib);
        
        Method originalMethod = class_getInstanceMethod(class, originalSelector);
        Method swizzledMethod = class_getInstanceMethod(class, swizzledSelector);
        
        // When swizzling a class method, use the following:
        // Class class = object_getClass((id)self);
        // ...
        // Method originalMethod = class_getClassMethod(class, originalSelector);
        // Method swizzledMethod = class_getClassMethod(class, swizzledSelector);
        
        BOOL didAddMethod =
        class_addMethod(class,
                        originalSelector,
                        method_getImplementation(swizzledMethod),
                        method_getTypeEncoding(swizzledMethod));
        
        if (didAddMethod) {
            class_replaceMethod(class,
                                swizzledSelector,
                                method_getImplementation(originalMethod),
                                method_getTypeEncoding(originalMethod));
        } else {
            method_exchangeImplementations(originalMethod, swizzledMethod);
        }
    });
}

#pragma mark - Method Swizzling

- (void)xxx_awakeFromNib {
    [self xxx_awakeFromNib];
    self.semanticContentAttribute = UISemanticContentAttributeForceLeftToRight;
}

@end
