//
//  OrderContainer.swift
//  Smart1SDKDemo
//
//  Created by David Esteban Hernández Garzón on 21/11/25.
//

import Smart1SDK_iOS

struct OrderContainer {
    let order    : Order
    let schedule : [ScheduleContainer]
    let route    : Route
}
