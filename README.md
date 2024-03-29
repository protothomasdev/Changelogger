# Changelogger

A command line tool to manage a changelog.

This tool is written in Swift using the [swift argument parser](https://github.com/apple/swift-argument-parser) from apple. It is a fun little experiment to use Swift for writing command line tools instead of writing scripts.


## Prerequisite

Before you can use the command line tool, you first have to make sure the changeloge you want to manage has a certain format.
The required format is loosely following the [conventinal commits specification](https://www.conventionalcommits.org/en/v1.0.0/) by grouping the changes into several catagories. It is using [markdown](https://daringfireball.net/projects/markdown/syntax), which makes it easy to read in Texteditors and on plattforms like Github with automatic formatting.

The changelog must have a format like this:

```
# Changelog

All notable changes to this project will be documented in this file.

## Unreleased // A section containing all unreleased changes to the project

### <Kind of change> // A headline to group changes

- <Ticket with description>

#### <Noteworthy dependency version info> // One or more lines of versions of important dependency
    
--- // Seperates the different versions
    
## Version 1.0.0 (1) // A section containing all changes to a specific version

### Improved

### <Kind of change>

- <Ticket with description>

#### <Noteworthy dependency version info>

---

...

```

The tickets have to have a certain format as well, if you want to take advantage of the changelogger's feature to add weblinks to each specific ticket in your project management system.

```
// Jira ticket
- [TICKET-123]: short description
// -> - [TICKET-123](https://jira.atlassian.com/browse/TICKET-123): short description

// Github issue
- [#123]: short description
// -> [#123](https://github.com/username/project/issues/123): short description
```

## How to install

First you have to create a binary using the command line. The easiest way to do that is to use the Makefile:

```
make install
```

This will install the tool on your system.

If you want to use it on your CI, you can simply create the binary with another command of the Makefile:

```
make release
```

You can find the binary in `.build/release`. To use it on a CI server, simple copy the binary into your project folder.


## How to use

### Make a release

If you want to release a new version of your project and you want to close the unreleased section in you changelog, you can use the `release` command:

```
changelogger release <version-number> <build-number>
```
This will close the previous unreleased serction and mark it with the provided version and build number. And it will create a new and empty unreleased section with the previous dependency info.

### Extract unreleased changes

If you want to get all the unreleased changes, for example to generate a version specific changelog for Testflight releases, you can use the `extract` command:
```
changelogger extract
```
By using this command the changelogger will generate a `CHANGES.md` file containing all changes of the unreleased section.

### Resolve weblinks

To resolve the provided ticket numbers to markdown links to the corresponding weblinks of the tickets, use the command `resolve`:
```
changelogger extract <config-file-path>
```


## Further information

For more information, see the help section

```
$ Changelogger --help
OVERVIEW: A Swift command-line tool to manage the changelog

USAGE: changelogger <subcommand>

OPTIONS:
  -h, --help              Show help information.

SUBCOMMANDS:
  release                 Extracts the unreleased changes and closes the
                          current 'Unreleased' section by renaming the section
                          to the given version and build number and create a
                          new 'Unreleased' section atop
  extract                 Extract the changes of current 'Unreleased' section
  resolve                 Resolve the provided ticket numbers to markdown links
                          to the corresponding URLs to the tickets
  close-unreleased        Rename the current 'Unreleased' section to the given
                          version and build number and create a new
                          'Unreleased' section atop
  version                 Shows the current version of the Changelogger

  See 'changelogger help <subcommand>' for detailed help.

```
