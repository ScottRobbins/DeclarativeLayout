/*
 Courtesy of the Swift Algorithm Club: https://github.com/raywenderlich/swift-algorithm-club/blob/master/Hash%20Set/HashSet.swift
 Slightly modified to fit my needs. Whether a hashset should allow you to get an element from it that is equal to another element is an academic debate I don't feel like having.
 Sure, I could just pass around a Dictionary<Hashable: Hashable>, but whatever, wanna fight about it?
 */
struct HashSet<T: Hashable> {
    private var dictionary = Dictionary<T, T>()
    
    init() { }
    
    init(_ elements: [T]) {
        dictionary.merge(zip(elements, elements)) { (_, new) in new }
    }
    
    mutating func insert(_ element: T) {
        dictionary[element] = element
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
    
    func get(_ element: T) -> T? {
        return dictionary[element]
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
