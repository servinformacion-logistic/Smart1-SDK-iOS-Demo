//
//  TrackerDemoSt.swift
//  Smart1SDKDemo
//
//  Created by David Esteban Hernández Garzón on 26/11/25.
//

import Combine

class TrackerDemoSt {
    static let st = TrackerDemoSt()
    let tracker: TrackerDemo
    
    private init() {
        tracker = TrackerDemo(autoStart: false)
    }
    
    static var onGettingInOrOutPortEventPublisher: AnyPublisher<(portId: Int, type: String), Never> {
        st.tracker.onGettingInOrOutPortEventPublisher
    }
    
    static func start() {
        st.tracker.start()
    }
    
    static func notifyNewOrderInProgress() {
        st.tracker.notifyNewOrderInProgress()
    }
    
    static func stop() {
        st.tracker.stop()
    }
    
    static func isAlreadyRunning() -> Bool {
        return st.tracker.isAlreadyRunning()
    }
}
