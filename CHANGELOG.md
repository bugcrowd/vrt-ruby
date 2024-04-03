# Change Log
All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](http://keepachangelog.com/) and this project adheres to [Semantic Versioning](http://semver.org/)

## [Unreleased]
### Added
- Find the [Secure Code Warrior](https://www.securecodewarrior.com/) remediation training associated with a VRT node

### Changed

### Removed

## [v0.12.6](https://github.com/bugcrowd/vrt-ruby/compare/v0.12.5...v0.12.6) - 2024-04-02

### Added
- Support for VRT 1.13

## [v0.12.5](https://github.com/bugcrowd/vrt-ruby/compare/v0.12.4...v0.12.5) - 2023-12-18

### Added
- Support for VRT 1.12 and some fixes

## [v0.12.4](https://github.com/bugcrowd/vrt-ruby/compare/v0.12.3...v0.12.4) - 2023-12-18

### Added
- Support for VRT 1.12 and some fixes

## [v0.12.3](https://github.com/bugcrowd/vrt-ruby/compare/v0.12.2...v0.12.3) - 2023-12-18

### Added
- Support for VRT 1.12

## [v0.12.2](https://github.com/bugcrowd/vrt-ruby/compare/v0.12.1...v0.12.2) - 2023-11-20

### Added
- Support for VRT 1.11 and some fixes

## [v0.12.1](https://github.com/bugcrowd/vrt-ruby/compare/v0.12.0...v0.12.1) - 2023-11-20

### Added
- Support for VRT 1.11 and some minor fixes

## [v0.12.0](https://github.com/bugcrowd/vrt-ruby/compare/v0.11.0...v0.12.0) - 2023-11-16

### Added
- Support for VRT 1.11

## [v0.11.0](https://github.com/bugcrowd/vrt-ruby/compare/v0.10.0...v0.11.0) - 2021-03-31

### Added
- Support for VRT 1.10
- Support for VRT 1.10.1 (updated spelling in scw mapping)

## [v0.10.0](https://github.com/bugcrowd/vrt-ruby/compare/v0.9.0...v0.10.0) - 2020-07-09
### Added
- Support for VRT 1.9

## [v0.9.0](https://github.com/bugcrowd/vrt-ruby/compare/v0.8.1...v0.9.0) - 2019-10-04
### Added
- Support for VRT 1.8

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
