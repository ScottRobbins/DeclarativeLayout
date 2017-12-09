import UIKit

public class UIViewSubviewLayoutComponent<T: UIView, R: UIView>: SubviewLayoutComponent<T, R>, UIViewLayoutComponentType {
    var downcastedView: UIView { return view as UIView }
}
