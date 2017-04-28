import UIKit

func ==(lhs: NSLayoutConstraint, rhs: NSLayoutConstraint) -> Bool {
    guard let lhsFirstItem = lhs.firstItem as? UIView,
        let rhsFirstItem = rhs.firstItem as? UIView,
        let lhsSecondItem = lhs.secondItem as? UIView,
        let rhsSecondItem = rhs.secondItem as? UIView else
    {
        return false
    }
    
    return lhsFirstItem == rhsFirstItem
        && lhs.firstAttribute == rhs.firstAttribute
        && lhsSecondItem == rhsSecondItem
        && lhs.secondAttribute == rhs.secondAttribute
        && lhs.relation == rhs.relation
}
