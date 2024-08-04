//
//  Context.swift
//  
//
//  Created by Andrew Barba on 8/1/24.
//

public struct Context {
    @TaskLocal public static var current: Context!

    public internal(set) var stage: String
}
