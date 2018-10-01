class LayoutConstraint {
    
    let wrappedConstraint: NSLayoutConstraint
    
    init(wrappedConstraint: NSLayoutConstraint) {
        self.wrappedConstraint = wrappedConstraint
    }
}

extension LayoutConstraint: Equatable {
    static func ==(lhs: LayoutConstraint, rhs: LayoutConstraint) -> Bool {
        
        let lhsConstraint = lhs.wrappedConstraint
        let rhsConstraint = rhs.wrappedConstraint
        
        // I know the NSLayoutConstraint API says the first Item can be nil, but I don't think that's true. I think it'll crash at runtime anyway if that's true
        // You can constrain to either UIViews or UILayoutGuides
        if let lhsFirstItem = lhsConstraint.firstItem as? UIView,
            let rhsFirstItem = rhsConstraint.firstItem as? UIView {
            guard lhsFirstItem == rhsFirstItem else {
                return false
            }
        } else if let lhsFirstItem = lhsConstraint.firstItem as? UILayoutGuide,
            let rhsFirstItem = rhsConstraint.firstItem as? UILayoutGuide {
            guard lhsFirstItem == rhsFirstItem else {
                return false
            }
        } else {
            return false
        }
        
        // If there is a second item, compare them
        if let lhsSecondItem = lhsConstraint.secondItem as? UIView {
            guard let rhsSecondItem = rhsConstraint.secondItem as? UIView,
                lhsSecondItem == rhsSecondItem else
            {
                return false
            }
        } else if let lhsSecondItem = lhsConstraint.secondItem as? UILayoutGuide {
            guard let rhsSecondItem = rhsConstraint.secondItem as? UILayoutGuide,
                lhsSecondItem == rhsSecondItem else
            {
                return false
            }
        } else if let _ = rhsConstraint.secondItem { // If we got here, it means that the lhs did not have a second item but the rhs did or the lhs had an invalid item
            return false
        }
        
        return lhsConstraint.firstAttribute == rhsConstraint.firstAttribute
            && lhsConstraint.secondAttribute == rhsConstraint.secondAttribute
            && lhsConstraint.relation == rhsConstraint.relation
            && lhsConstraint.multiplier == rhsConstraint.multiplier
    }
}

extension LayoutConstraint: Hashable {
    
    public func hash(into hasher: inout Hasher) {
        if let firstItem = wrappedConstraint.firstItem as? UIView {
            hasher.combine(firstItem)
        } else if let firstItem = wrappedConstraint.firstItem as? UILayoutGuide {
            hasher.combine(firstItem)
        }
        
        if let secondItem = wrappedConstraint.secondItem as? UIView {
            hasher.combine(secondItem)
        } else if let secondItem = wrappedConstraint.secondItem as? UILayoutGuide {
            hasher.combine(secondItem)
        }
        
        hasher.combine(wrappedConstraint.firstAttribute)
        hasher.combine(wrappedConstraint.secondAttribute)
        hasher.combine(wrappedConstraint.relation)
        hasher.combine(wrappedConstraint.multiplier)
    }
}
