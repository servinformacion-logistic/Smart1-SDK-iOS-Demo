//
//  TrackerDemoSt.swift
//  Smart1SDKDemo
//
//  Created by David Esteban Hernández Garzón on 26/11/25.
//

class TrackerDemoSt {
    static let st = TrackerDemoSt()
    let tracker: TrackerDemo
    
    private init() {
        tracker = TrackerDemo(autoStart: false)
    }
    
    static func start() {
        st.tracker.start()
    }
    
    static func stop() {
        st.tracker.stop()
    }
    
    static func isAlreadyRunning() -> Bool {
        return st.tracker.isAlreadyRunning()
    }
}
