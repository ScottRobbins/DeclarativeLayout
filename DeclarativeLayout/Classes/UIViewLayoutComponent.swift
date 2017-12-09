import UIKit

public class UIViewLayoutComponent<T: UIView>: ViewLayoutComponent<T>, UIViewLayoutComponentType {
    var downcastedView: UIView { return view as UIView }
}
