import UIKit
import XCTest
import DeclarativeLayout

class PerformanceTests: XCTestCase {
    
    var view: ExampleView!
    var viewLayout: ViewLayout<ExampleView>!
    
    override func setUp() {
        super.setUp()
        
        view = ExampleView()
        viewLayout = ViewLayout(view: view)
    }
    
    func testInitialLayout() {
        
        self.measure() {
            view.layoutAndConfigure(with: viewLayout)
        }
    }
    
    func testUpdatingWithSameLayout() {
        view.layoutAndConfigure(with: viewLayout)
        
        self.measure {
            view.layoutAndConfigure(with: viewLayout)
        }
    }
    
    func testUpdatingWithNewConstraints() {
        view.layoutAndConfigure(with: viewLayout)
        view.currentState = .newConstraints
        
        self.measure {
            view.layoutAndConfigure(with: viewLayout)
        }
    }
}
