//
//  NSImage+Convenience.swift
//  cuImage
//
//  Created by HuLizhen on 14/01/2017.
//  Copyright © 2017 HuLizhen. All rights reserved.
//

import Cocoa

extension NSImage {
    /**
     Compress image by specified factor.
     
     - parameters:
        - factor: The value is a float between 0.0 and 1.0,
                    with 1.0 resulting in no compression and
                    0.0 resulting in the maximum compression possible.
     
     - returns: Compressed JPEG image data if succeeded, otherwise nil.
     */
    func compressedData(by factor: Float) -> Data? {
        if let tiffRepresentation = self.tiffRepresentation,
            let bitmap = NSBitmapImageRep(data: tiffRepresentation),
            let data = bitmap.representation(using: .JPEG, properties: [NSImageCompressionFactor: factor]) {
            return data
        }
        return nil
    }

    /**
     Generate thumbnail of the image.
     */
    func thumbnail(maxSize: Float) -> NSImage? {
        var options: [String: Any?] = [kCGImageSourceShouldCache as String: false]

        var thumbnail: NSImage?
        if let source = CGImageSourceCreateWithData(tiffRepresentation as! CFData, options as CFDictionary) {
            options = [kCGImageSourceShouldCache as String: false,
                       kCGImageSourceThumbnailMaxPixelSize as String: maxSize,
                       kCGImageSourceCreateThumbnailFromImageAlways as String: true]
            
            if let image = CGImageSourceCreateThumbnailAtIndex(source, 0, options as CFDictionary) {
                thumbnail = NSImage(cgImage: image, size: NSSize(width: image.width, height: image.height))
            }
        }
        return thumbnail
    }
}
