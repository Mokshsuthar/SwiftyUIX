//
//  PHAssetExtensions.swift
//  AI Photo
//
//  Created by Moksh on 11/6/25.
//
#if os(iOS)
import Photos
import UIKit

public extension PHAsset {
    /// Loads a UIImage for this asset using async/await.
    /// - Parameters:
    ///   - targetSize: Use `.maximum` to get full pixel size, or pass a custom size for thumbnails.
    ///   - contentMode: `.aspectFit` (no crop) or `.aspectFill` (may crop).
    ///   - deliveryMode: `.highQualityFormat` for best quality (may be slower if from iCloud).
    /// - Returns: The resulting UIImage, or nil if it couldn’t be loaded.
    func loadImage(
        targetSize: CGSize? = nil,
        contentMode: PHImageContentMode = .aspectFit,
        deliveryMode: PHImageRequestOptionsDeliveryMode = .highQualityFormat
    ) async -> UIImage? {
        await withCheckedContinuation { continuation in
            let manager = PHImageManager.default()
            let options = PHImageRequestOptions()
            options.deliveryMode = deliveryMode
            options.isNetworkAccessAllowed = true
            options.isSynchronous = false

            let size = targetSize ?? CGSize(width: self.pixelWidth, height: self.pixelHeight)

            manager.requestImage(
                for: self,
                targetSize: size,
                contentMode: contentMode,
                options: options
            ) { image, _ in
                continuation.resume(returning: image)
            }
        }
    }

    /// Loads the original image via image data (useful if you need exact bytes/metadata).
    func loadOriginalImage() async -> UIImage? {
        await withCheckedContinuation { continuation in
            let options = PHImageRequestOptions()
            options.isNetworkAccessAllowed = true
            options.deliveryMode = .highQualityFormat

            PHImageManager.default().requestImageDataAndOrientation(for: self, options: options) { data, _, _, _ in
                if let data = data {
                    continuation.resume(returning: UIImage(data: data))
                } else {
                    continuation.resume(returning: nil)
                }
            }
        }
    }
}
#endif
