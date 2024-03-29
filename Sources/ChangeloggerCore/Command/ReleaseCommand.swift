//
//  ReleaseCommand.swift
//  ChangeloggerCore
//
//  Created by Thomas Meyer on 14.06.20.
//

import ArgumentParser
import Files
import Foundation

struct ReleaseCommand: ParsableCommand {

    public static let configuration = CommandConfiguration(commandName: "release",
                                                           abstract:
                                                           """
                                                           Extracts the unreleased changes and closes the current 'Unreleased' section by renaming
                                                           the section to the given version and build number and create a new 'Unreleased' section atop
                                                           """)

    @Argument(help: "The version number")
    private var versionNumber: String

    @Argument(help: "The build number")
    private var buildNumber: String

    @Argument(help: "The path to the changelog file. If set, the links within the unreleased changes will be resolved")
    private var changelog: String = "CHANGELOG.md"

    @Option(name: .shortAndLong,
            help: "The path to the folder to which the extracted content should be saved to")
    private var output: String = "CHANGES.md"

    @Option(name: .shortAndLong,
            help: "The path to the changelog config file. If set, the links within the unreleased changes will be resolved")
    private var config: String?

    @Flag(name: .shortAndLong,
          inversion: .prefixedNo,
          help: "Show extra logging for debugging purposes")
    private var verbose: Bool

    @Flag(name: .shortAndLong,
          inversion: .prefixedNo,
          help: "Show result without saving it")
    private var dryRun: Bool

    func run() throws {
        Log.isVerbose = verbose

        var changelog = try Changelog(changelogPath: changelog, configPath: config)

        if config != nil {
            try changelog.updateAllTicketLinks()
        }

        let unreleasedChanges = try changelog.unreleasedChanges(resolveLinks: false)

        try changelog.createVersion(versionNumber: versionNumber, buildNumber: buildNumber)

        if dryRun {
            Log.message("Changelog: \(changelog.text)")
            Log.message("Unreleased: \(unreleasedChanges)")
        } else {
            Log.debug("Changelog: \(changelog.text)")
            Log.debug("Unreleased: \(unreleasedChanges)")
            try changelog.save()

            let folder = Folder.current
            let file = try folder.createFileIfNeeded(at: output)
            let path = file.path

            try unreleasedChanges.write(toFile: path, atomically: true, encoding: .utf8)
        }
    }

}
