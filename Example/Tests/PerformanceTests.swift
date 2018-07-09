import UIKit
import XCTest
import DeclarativeLayout

class PerformanceTests: XCTestCase {
    
    var view: ExampleView!
    var viewLayout: ViewLayout<ExampleView>!
    
    private func setupTest() {
        // It does this twice to populate the selector/instruction pointer cache (maybe?)
        // of the codepath i'm running
        view = ExampleView()
        viewLayout = ViewLayout(view: view)
        view.layoutAndConfigure(with: viewLayout)
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
