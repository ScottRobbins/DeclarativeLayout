import UIKit

public final class UIViewSubviewLayoutComponent<T: UIView, R: UIView>: SubviewLayoutComponent<T, R>, UIViewLayoutComponentType {
    unowned var downcastedView: UIView { return ownedView as UIView }
}
