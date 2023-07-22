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
