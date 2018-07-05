import UIKit
import XCTest
import DeclarativeLayout

class PerformanceTests: XCTestCase {
    
    var view: ExampleView!
    var viewLayout: ViewLayout<ExampleView>!
    
    private func setupTest() {
        view = ExampleView()
        viewLayout = ViewLayout(view: view)
    }
    
    func testInitialLayout() {
        measureMetrics([.wallClockTime], automaticallyStartMeasuring: false) {
            setupTest()
            startMeasuring()
            view.layoutAndConfigure(with: viewLayout)
            stopMeasuring()
        }
    }
    
    func testUpdatingWithSameLayout() {
        measureMetrics([.wallClockTime], automaticallyStartMeasuring: false) {
            setupTest()
            view.layoutAndConfigure(with: viewLayout)
            startMeasuring()
            view.layoutAndConfigure(with: viewLayout)
            stopMeasuring()
        }
    }
    
    func testUpdatingWithNewConstraints() {
        measureMetrics([.wallClockTime], automaticallyStartMeasuring: false) {
            setupTest()
            view.layoutAndConfigure(with: viewLayout)
            view.currentState = .newConstraints
            startMeasuring()
            view.layoutAndConfigure(with: viewLayout)
            stopMeasuring()
        }
    }
    
    func testUpdatingWithNewViewsAndConstraints() {
        measureMetrics([.wallClockTime], automaticallyStartMeasuring: false) {
            setupTest()
            view.layoutAndConfigure(with: viewLayout)
            view.currentState = .newViewsAndConstraints
            startMeasuring()
            view.layoutAndConfigure(with: viewLayout)
            stopMeasuring()
        }
    }
    
    func testUpdatingWithChangedConstraints() {
        measureMetrics([.wallClockTime], automaticallyStartMeasuring: false) {
            setupTest()
            view.layoutAndConfigure(with: viewLayout)
            view.currentState = .changedConstraints
            startMeasuring()
            view.layoutAndConfigure(with: viewLayout)
            stopMeasuring()
        }
    }
}
