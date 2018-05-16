# Change Log
All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](http://keepachangelog.com/) and this project adheres to [Semantic Versioning](http://semver.org/)

## [Unreleased]
### Added

### Changed

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
