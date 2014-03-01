//
//  NSImage+NKO.m
//  Dashboard Server
//
//  Created by Carlos Vidal Pallín on 28/02/2014.
//  Copyright (c) 2014 nakioStudio. All rights reserved.
//

#import "NSImage+NKO.h"

@implementation NSImage (NKO)

- (NSImage*)scaleImageToSize:(CGSize)size
{
    NSSize imageSize = [self size];
    float width  = imageSize.width;
    float height = imageSize.height;
    float targetWidth  = size.width;
    float targetHeight = size.height;
    float scaleFactor  = 0.0;
    float scaledWidth  = targetWidth;
    float scaledHeight = targetHeight;
    
    NSPoint thumbnailPoint = NSZeroPoint;
    
    float widthFactor  = targetWidth / width;
    float heightFactor = targetHeight / height;
    
    if (widthFactor < heightFactor)
    {
        scaleFactor = widthFactor;
    }
    else
    {
        scaleFactor = heightFactor;
    }
    
    scaledWidth  = width  * scaleFactor;
    scaledHeight = height * scaleFactor;
    
    if (widthFactor < heightFactor)
    {
        thumbnailPoint.y = (targetHeight - scaledHeight) * 0.5;
    }
    
    else if (widthFactor > heightFactor)
    {
        thumbnailPoint.x = (targetWidth - scaledWidth) * 0.5;
    }
    
    NSImage *newImage = [[NSImage alloc] initWithSize:NSSizeFromCGSize(size)];
    
    [newImage lockFocus];
    
    NSRect thumbnailRect;
    thumbnailRect.origin = thumbnailPoint;
    thumbnailRect.size.width = scaledWidth;
    thumbnailRect.size.height = scaledHeight;
    
    [self drawInRect:thumbnailRect
             fromRect:NSZeroRect
            operation:NSCompositeSourceOver
             fraction:1.0];
    
    [newImage unlockFocus];
    
    return newImage;
}

@end
