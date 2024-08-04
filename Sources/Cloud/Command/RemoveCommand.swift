//
//  RemoveCommand.swift
//
//
//  Created by Andrew Barba on 8/4/24.
//

import ArgumentParser
import Foundation
import Yams

extension Command {
    struct Remove: RunCommand {
        static let configuration = CommandConfiguration(abstract: "Remove your application")

        @OptionGroup var options: Options

        func invoke(with project: any Project) async throws {
            let prepared = try await prepare(with: project)
            let output = try await prepared.client.invoke(command: "destroy", arguments: ["--continue-on-error", "--skip-preview", "--yes"])
            print(output)
        }
    }
}
