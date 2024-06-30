//
//  API.swift
//  Rockout
//
//  Created by Kostya Lee on 17/01/24.
//

import Foundation

typealias Exercises = [API.Exercise]

public struct API {
    public struct Exercise: Codable {
        var bodyPart: String
        var equipment: String
        var gifUrl: String
        var id: String
        var name: String
        var target: String
        var secondaryMuscles: [String]
        var instructions: [String]
    }
}
