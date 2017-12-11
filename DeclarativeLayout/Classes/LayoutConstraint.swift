class LayoutConstraint {
    
    let wrappedConstraint: NSLayoutConstraint
    
    init(wrappedConstraint: NSLayoutConstraint) {
        self.wrappedConstraint = wrappedConstraint
    }
}

extension LayoutConstraint: Equatable {
    static func ==(lhs: LayoutConstraint, rhs: LayoutConstraint) -> Bool {
        guard let lhsFirstItem = lhs.wrappedConstraint.firstItem as? UIView,
            let rhsFirstItem = rhs.wrappedConstraint.firstItem as? UIView,
            let lhsSecondItem = lhs.wrappedConstraint.secondItem as? UIView,
            let rhsSecondItem = rhs.wrappedConstraint.secondItem as? UIView else
        {
            return false
        }
        
        return lhsFirstItem == rhsFirstItem
            && lhs.wrappedConstraint.firstAttribute == rhs.wrappedConstraint.firstAttribute
            && lhsSecondItem == rhsSecondItem
            && lhs.wrappedConstraint.secondAttribute == rhs.wrappedConstraint.secondAttribute
            && lhs.wrappedConstraint.relation == rhs.wrappedConstraint.relation
            && lhs.wrappedConstraint.multiplier == rhs.wrappedConstraint.multiplier
    }
}
