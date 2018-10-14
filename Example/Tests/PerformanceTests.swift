import UIKit
import XCTest
import DeclarativeLayout

class PerformanceTests: XCTestCase {
    
    var view: ExampleView!
    var viewLayout: ViewLayout<ExampleView>!
    
    private func setupTest(numberOfViews: Int) {
        // It does this twice to populate the selector/instruction pointer cache (maybe?)
        // of the codepath i'm running
        view = ExampleView(numberOfViews: numberOfViews)
        viewLayout = ViewLayout(view: view)
        view.layoutAndConfigure(with: viewLayout)
        view = ExampleView(numberOfViews: numberOfViews)
        viewLayout = ViewLayout(view: view)
    }
    
    // MARK: - Realistic
    
    func testInitialLayoutRealistic() {
        measureMetrics([.wallClockTime], automaticallyStartMeasuring: false) {
            setupTest(numberOfViews: 20)
            startMeasuring()
            view.layoutAndConfigure(with: viewLayout)
            stopMeasuring()
        }
    }
    
    func testUpdatingWithSameLayoutRealistic() {
        measureMetrics([.wallClockTime], automaticallyStartMeasuring: false) {
            setupTest(numberOfViews: 20)
            view.layoutAndConfigure(with: viewLayout)
            startMeasuring()
            view.layoutAndConfigure(with: viewLayout)
            stopMeasuring()
        }
    }
    
    func testUpdatingWithNewConstraintsRealistic() {
        measureMetrics([.wallClockTime], automaticallyStartMeasuring: false) {
            setupTest(numberOfViews: 20)
            view.layoutAndConfigure(with: viewLayout)
            view.currentState = .newConstraints
            startMeasuring()
            view.layoutAndConfigure(with: viewLayout)
            stopMeasuring()
        }
    }
    
    func testUpdatingWithNewViewsAndConstraintsRealistic() {
        measureMetrics([.wallClockTime], automaticallyStartMeasuring: false) {
            setupTest(numberOfViews: 20)
            view.layoutAndConfigure(with: viewLayout)
            view.currentState = .newViewsAndConstraints
            startMeasuring()
            view.layoutAndConfigure(with: viewLayout)
            stopMeasuring()
        }
    }
    
    func testUpdatingWithChangedConstraintsRealistic() {
        measureMetrics([.wallClockTime], automaticallyStartMeasuring: false) {
            setupTest(numberOfViews: 20)
            view.layoutAndConfigure(with: viewLayout)
            view.currentState = .changedConstraints
            startMeasuring()
            view.layoutAndConfigure(with: viewLayout)
            stopMeasuring()
        }
    }
    
    // MARK: - Outlier
    
    func testInitialLayoutOutlier() {
        measureMetrics([.wallClockTime], automaticallyStartMeasuring: false) {
            setupTest(numberOfViews: 100)
            startMeasuring()
            view.layoutAndConfigure(with: viewLayout)
            stopMeasuring()
        }
    }
    
    func testUpdatingWithSameLayoutOutlier() {
        measureMetrics([.wallClockTime], automaticallyStartMeasuring: false) {
            setupTest(numberOfViews: 100)
            view.layoutAndConfigure(with: viewLayout)
            startMeasuring()
            view.layoutAndConfigure(with: viewLayout)
            stopMeasuring()
        }
    }
    
    func testUpdatingWithNewConstraintsOutlier() {
        measureMetrics([.wallClockTime], automaticallyStartMeasuring: false) {
            setupTest(numberOfViews: 100)
            view.layoutAndConfigure(with: viewLayout)
            view.currentState = .newConstraints
            startMeasuring()
            view.layoutAndConfigure(with: viewLayout)
            stopMeasuring()
        }
    }
    
    func testUpdatingWithNewViewsAndConstraintsOutlier() {
        measureMetrics([.wallClockTime], automaticallyStartMeasuring: false) {
            setupTest(numberOfViews: 100)
            view.layoutAndConfigure(with: viewLayout)
            view.currentState = .newViewsAndConstraints
            startMeasuring()
            view.layoutAndConfigure(with: viewLayout)
            stopMeasuring()
        }
    }
    
    func testUpdatingWithChangedConstraintsOutlier() {
        measureMetrics([.wallClockTime], automaticallyStartMeasuring: false) {
            setupTest(numberOfViews: 100)
            view.layoutAndConfigure(with: viewLayout)
            view.currentState = .changedConstraints
            startMeasuring()
            view.layoutAndConfigure(with: viewLayout)
            stopMeasuring()
        }
    }
}
