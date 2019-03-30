import UIKit

public final class UIViewLayoutComponent<T: UIView>: ViewLayoutComponent<T>, UIViewLayoutComponentType {
    unowned var downcastedView: UIView { return view as UIView }
}
