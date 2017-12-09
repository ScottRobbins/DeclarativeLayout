import UIKit

public class UIViewLayoutComponent: ViewLayoutComponent<UIView>, UIViewLayoutComponentType {
    var downcastedView: UIView { return view as UIView }
}
