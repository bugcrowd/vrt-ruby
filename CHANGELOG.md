# Change Log
All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](http://keepachangelog.com/) and this project adheres to [Semantic Versioning](http://semver.org/)

## [Unreleased]
### Added

### Changed

### Removed

## [v0.8.1](https://github.com/bugcrowd/vrt-ruby/compare/v0.8.0...v0.8.1) - 2019-04-25
### Added
- Support for VRT 1.7.1 (includes automotive mappings)

## [v0.8.0](https://github.com/bugcrowd/vrt-ruby/compare/v0.7.0...v0.8.0) - 2019-03-15
### Added
- Support for nested mappings: https://github.com/bugcrowd/vrt-ruby/pull/43
- Support for VRT v1.7

### Changed
- Upgrade ruby version to 2.5.3

## [v0.7.0](https://github.com/bugcrowd/vrt-ruby/compare/v0.6.0...v0.7.0) - 2018-11-05
### Added
- Support for VRT v1.6

## [v0.6.0](https://github.com/bugcrowd/vrt-ruby/compare/v0.5.1...v0.6.0) - 2018-09-27
### Changed
- Fixed bug for mappings with multiple keys and a default (resolves: [#26](https://github.com/bugcrowd/vrt-ruby/issues/26))

### Removed
- Removed `Gemfile.lock` from source control

## [v0.5.1](https://github.com/bugcrowd/vrt-ruby/compare/v0.5.0...v0.5.1) - 2018-05-15
### Changed
- Mappings with array values will no longer coalesce the mapping default.
  The mapping default will only be used in the case where no value is mapped.

## [v0.5.0](https://github.com/bugcrowd/vrt-ruby/compare/v0.4.6...v0.5.0) - 2018-05-01
### Added
- VRT 1.4 data
- Support for mappings with `keys` metadata
- CWE mapping
- Bugcrowd Remediation Advice mapping

### Changed
- Mappings with array values now coalesce downwards.
  Child VRT nodes will include values from parent nodes if a mapping
  provides node data as an array.

## [v0.4.6](https://github.com/bugcrowd/vrt-ruby/compare/v0.4.5...v0.4.6) - 2018-02-05
### Changed
- Cache VRT::Map objects (#18)
