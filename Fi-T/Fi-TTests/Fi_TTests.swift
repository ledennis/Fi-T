//
//  Fi_TTests.swift
//  Fi-TTests
//
//  Created by Dennis Le on 4/1/18.
//  Copyright © 2018 Dennis Le. All rights reserved.
//

import XCTest
@testable import Fi_T

class Fi_TTests: XCTestCase {
    
    func workoutInitializationPass() {
        let bench = Workout.init(name:"Bench", sets:"3x10", weight:"135lbs.")
        XCTAssertNil(bench)
        
        let squat = Workout.init(name:"Squat", sets:"4x8", weight:"215lbs.")
        XCTAssertNotNil(squat)
    }
    
}
