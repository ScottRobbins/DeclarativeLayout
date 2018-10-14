import UIKit

public class UIViewSubviewLayoutComponent<T: UIView, R: UIView>: SubviewLayoutComponent<T, R>, UIViewLayoutComponentType {
    unowned var downcastedView: UIView { return view as UIView }
}
