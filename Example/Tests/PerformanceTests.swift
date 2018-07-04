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
        
        self.measure {
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
    
    func testUpdatingWithNewViewsAndConstraints() {
        view.layoutAndConfigure(with: viewLayout)
        view.currentState = .newViewsAndConstraints
        
        self.measure {
            view.layoutAndConfigure(with: viewLayout)
        }
    }
    
    func testUpdatingWithChangedConstraints() {
        view.layoutAndConfigure(with: viewLayout)
        view.currentState = .changedConstraints
        
        self.measure {
            view.layoutAndConfigure(with: viewLayout)
        }
    }
}
