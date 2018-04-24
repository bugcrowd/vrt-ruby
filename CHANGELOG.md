# Change Log
All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](http://keepachangelog.com/) and this project adheres to [Semantic Versioning](http://semver.org/)

## [Unreleased]
### Added
- VRT 1.4 data
- Support for mappings with `keys` metadata
- VRT to CWE mapping
- VRT to Bugcrowd Remediation Advice mapping

### Changed
- Mappings with array and hash values now caolesce downwards.
  Child VRT nodes will include values from parent nodes if a mapping
  provides data for a node in an array or a hash.

## [v0.4.6](https://github.com/bugcrowd/vrt-ruby/compare/v0.4.5...v0.4.6) - 2018-02-05
### Changed
- Cache VRT::Map objects (#18)
