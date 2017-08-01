# Contributing
Bugcrowd welcomes community feedback and direct contributions to the Bugcrowd VRT Ruby Wrapper. We accept comments for public discussion via GitHub Issues.

## Process
Please open your feedback as an **Issue** and label it as either a `bug` or an `enhancement`. Large or systemic changes should first be discussed in an Issue rather than be submitted as a pull request directly.

Prior to opening a pull request please ensure your suggested changes pass specs. The repository uses [`rspec`](https://github.com/rspec/rspec) for spec running, run it with `bundle install && bundle exec rspec`.

### Updating the VRT version
When a new version of the VRT is released, we follow these steps:
1. Add new submodule of the new version tag
2. Cut new version of the gem
3. Push new version to rubygems
4. `bundle update vrt` in dependent applications
