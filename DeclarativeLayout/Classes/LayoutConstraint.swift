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
    
    var hashValue: Int {
        
        return combineHashes([
            wrappedConstraint.firstItem?.hashValue ?? 0,
            wrappedConstraint.secondItem?.hashValue ?? 0,
            wrappedConstraint.firstAttribute.hashValue,
            wrappedConstraint.secondAttribute.hashValue,
            wrappedConstraint.relation.hashValue,
            wrappedConstraint.multiplier.hashValue,
            0,
        ])
    }
    
    /*
                Credit to Sourcery's algorithm found here: https://github.com/krzysztofzablocki/Sourcery/blob/3e69bec7df09fb8ea42a927c4a8a2c82a196075b/Templates/Tests/Expected/AutoHashable.expected
                This is the boost hash combine algorithm implemented in Swift
        */
    fileprivate func combineHashes(_ hashes: [Int]) -> Int {
        return hashes.reduce(0, combineHashValues)
    }
    
    fileprivate func combineHashValues(_ initial: Int, _ other: Int) -> Int {
        #if arch(x86_64) || arch(arm64)
            let magic: UInt = 0x9e3779b97f4a7c15
        #elseif arch(i386) || arch(arm)
            let magic: UInt = 0x9e3779b9
        #endif
        var lhs = UInt(bitPattern: initial)
        let rhs = UInt(bitPattern: other)
        lhs ^= rhs &+ magic &+ (lhs << 6) &+ (lhs >> 2)
        return Int(bitPattern: lhs)
    }
}
