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
        "icon": "01d",
        "temp": 24.5,
    ],
    [
        "location": "seongnam",
        "icon": "02d",
        "temp": 20.9,
    ],
    [
        "location": "seongnam",
        "icon": "09d",
        "temp": 18.4,
    ],
    [
        "location": "seongnam",
        "icon": "13d",
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

