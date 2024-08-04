//
//  PreviewCommand.swift
//
//
//  Created by Andrew Barba on 8/4/24.
//

import ArgumentParser
import Foundation
import Yams

extension Command {
    struct Preview: RunCommand {
        static let configuration = CommandConfiguration(abstract: "Preview changes to your application")

        @OptionGroup var options: Options

        func invoke(with project: any Project) async throws {
            let prepared = try await prepare(with: project)
            let output = try await prepared.client.invoke(command: "preview")
            print(output)
        }
    }
}
