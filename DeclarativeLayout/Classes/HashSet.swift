// Courtesy of the Swift Algorithm Club: https://github.com/raywenderlich/swift-algorithm-club/blob/master/Hash%20Set/HashSet.swift
struct HashSet<T: Hashable> {
    private var dictionary = Dictionary<T, Bool>()
    
    mutating func insert(_ element: T) {
        dictionary[element] = true
    }
    
    mutating func insert(_ elements: [T]) {
        elements.forEach() { insert($0) }
    }
    
    mutating func remove(_ element: T) {
        dictionary[element] = nil
    }
    
    func contains(_ element: T) -> Bool {
        return dictionary[element] != nil
    }
    
    func allElements() -> [T] {
        return Array(dictionary.keys)
    }
    
    var count: Int {
        return dictionary.count
    }
    
    var isEmpty: Bool {
        return dictionary.isEmpty
    }
}

extension HashSet {
    func union(otherSet: HashSet<T>) -> HashSet<T> {
        var combined = HashSet<T>()
        for obj in dictionary.keys {
            combined.insert(obj)
        }
        for obj in otherSet.dictionary.keys {
            combined.insert(obj)
        }
        return combined
    }
    
    func intersect(otherSet: HashSet<T>) -> HashSet<T> {
        var common = HashSet<T>()
        for obj in dictionary.keys {
            if otherSet.contains(obj) {
                common.insert(obj)
            }
        }
        return common
    }
    
    func difference(otherSet: HashSet<T>) -> HashSet<T> {
        var diff = HashSet<T>()
        for obj in dictionary.keys {
            if !otherSet.contains(obj) {
                diff.insert(obj)
            }
        }
        return diff
    }
}


