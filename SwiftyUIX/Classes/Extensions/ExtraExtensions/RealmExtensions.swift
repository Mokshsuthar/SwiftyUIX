//
//  RealmExtensions.swift
//  SwiftyUIX
//
//  Created by Moksh Suthar on 24/09/23.
//


#if canImport(RealmSwift)
import RealmSwift
extension Results {
    func toArray<T>(ofType: T.Type) -> Array<T> {
        var array: [T] = []
        for i in 0 ..< count {
            if let result = self[i] as? T {
                array.append(result)
            }
        }
        return array
    }
}


extension Array {
    func toList<T>(ofType: T.Type) -> List<T> {
        let list = List<T>()
        for i in 0 ..< count {
            if let result = self[i] as? T {
                //array.append(result)
                list.append(result)
                
            }
        }

        return list
    }
}


extension List {
    func toArray<T>(ofType: T.Type) -> [T] {
        var array: [T] = []
        for i in 0 ..< count {
            if let result = self[i] as? T {
                //array.append(result)
                array.append(result)
                
            }
        }

        return array
    }
}

#endif
