# Contributing
Bugcrowd welcomes community feedback and direct contributions to the Bugcrowd VRT Ruby Wrapper. We accept comments for public discussion via GitHub Issues.

## Process
Please open your feedback as an **Issue** and label it as either a `bug` or an `enhancement`. Large or systemic changes should first be discussed in an Issue rather than be submitted as a pull request directly.

Prior to opening a pull request please ensure your suggested changes pass specs. The repository uses [`rspec`](https://github.com/rspec/rspec) for spec running, run it with `bundle install && bundle exec rspec`.

### Updating the VRT version
When a new version of the VRT is released, we follow these steps:
1. Add new submodule of the new version tag
    - `git submodule add git@github.com:bugcrowd/vulnerability-rating-taxonomy.git lib/data/X.X`
    - `cd lib/data/X.X`
    - `git checkout vX.X`
2. Cut new version of the gem
    - update Vrt::VERSION
    - `rake release`
3. Update dependent applications
    - `bundle update vrt`

If you need access to push the gem, create an account on rubygems (if you don't have one already) and then ask one of the existing owners to run gem owner vrt --add <your-rubygems-email>
