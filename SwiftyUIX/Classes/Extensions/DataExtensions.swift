//
//  DataExtensions.swift
//  SwiftyUIX
//
//  Created by Moksh Suthar on 22/07/23.
//

import Foundation
public extension Data{
    // Returns the size of a Data object in a human-readable format (KB, MB, GB, etc.).
    func getReadableDataSize() -> String {
        let byteCount = Double(self.count)
        let formatter = ByteCountFormatter()
        formatter.allowedUnits = [.useBytes, .useKB, .useMB, .useGB,.useTB]
        formatter.countStyle = .file
        return formatter.string(fromByteCount: Int64(byteCount))
    }
}

public extension Int64 {
    func toReadableSize() -> String {
        let units = ["B", "KB", "MB", "GB", "TB", "PB", "EB"]
        var size = Double(self)
        var unitIndex = 0
        
        // Loop through units to find the appropriate size
        while size >= 1024 && unitIndex < units.count - 1 {
            size /= 1024
            unitIndex += 1
        }
        
        // Format the size to 2 decimal places for clarity
        return String(format: "%.2f %@", size, units[unitIndex])
    }
}
