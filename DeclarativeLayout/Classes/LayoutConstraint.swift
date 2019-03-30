import UIKit

final class LayoutConstraint {
    
    let wrappedConstraint: NSLayoutConstraint
    var cachedHash: Int?
    
    init(wrappedConstraint: NSLayoutConstraint) {
        self.wrappedConstraint = wrappedConstraint
    }
}

extension LayoutConstraint: Equatable {
    static func ==(lhs: LayoutConstraint, rhs: LayoutConstraint) -> Bool {
        
        let lhsConstraint = lhs.wrappedConstraint
        let rhsConstraint = rhs.wrappedConstraint
        
        // I know the NSLayoutConstraint API says the first Item can be nil, but I don't think that's true. I think it'll crash at runtime anyway if that's true
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
        } else if let _ = rhsConstraint.secondItem {
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
        if let cachedHash = cachedHash {
            hasher.combine(cachedHash)
        } else {
            var newHasher = Hasher()
            if let firstItem = wrappedConstraint.firstItem as? UIView {
                newHasher.combine(firstItem)
            } else if let firstItem = wrappedConstraint.firstItem as? UILayoutGuide {
                newHasher.combine(firstItem)
            }

            if let secondItem = wrappedConstraint.secondItem as? UIView {
                newHasher.combine(secondItem)
            } else if let secondItem = wrappedConstraint.secondItem as? UILayoutGuide {
                newHasher.combine(secondItem)
            }

            newHasher.combine(wrappedConstraint.firstAttribute)
            newHasher.combine(wrappedConstraint.secondAttribute)
            newHasher.combine(wrappedConstraint.relation)
            newHasher.combine(wrappedConstraint.multiplier)
            let newHash = newHasher.finalize()
            cachedHash = newHash
            hasher.combine(newHash)
        }
    }
}
