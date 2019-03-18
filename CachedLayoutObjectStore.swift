final class CachedLayoutObjectStore {
    enum LayoutObject {
        case view(UIView)
        case layoutGuide(UILayoutGuide)
    }

    private var storage = [String: LayoutObject]()

    subscript(index: String) -> LayoutObject? {
        get { return storage[index] }
        set { storage[index] = newValue }
    }
}
