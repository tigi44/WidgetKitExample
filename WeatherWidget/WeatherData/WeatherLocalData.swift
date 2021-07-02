//
//  WeatherLocalData.swift
//  
//
//  Created by tigi on 2021/02/12.
//

import Foundation

let WeatherLocalData = [
    [
        "location": "seongnam",
        "icon": "sun.max.fill",
        "temp": 24.5,
    ],
    [
        "location": "seongnam",
        "icon": "cloud.sun.fill",
        "temp": 20.9,
    ],
    [
        "location": "seongnam",
        "icon": "cloud.rain.fill",
        "temp": 18.4,
    ],
    [
        "location": "seongnam",
        "icon": "snow",
        "temp": -5.2,
    ],
]

let AirLocalData = [
    [
        "dt": Date().timeIntervalSince1970,
        "condition": "BAD",
    ],
    [
        "dt": Date().timeIntervalSince1970 + 60,
        "condition": "BAD",
    ],
    [
        "dt": Date().timeIntervalSince1970 + 120,
        "condition": "NORMAL",
    ],
    [
        "dt": Date().timeIntervalSince1970 + 180,
        "condition": "GOOD",
    ],
]

