<p align="center">
  <img src="https://gist.githubusercontent.com/adamrdavid/c5d4e0faab7801c828962487f3e5b924/raw/2ab968922aa658e37b458fd07c67591ca98b77a9/vrt.svg" />
</p>
<p align="center">
  <a href="https://rubygems.org/gems/vrt">
    <img src="https://badge.fury.io/rb/vrt.svg" />
  </a>
  <a href="https://github.com/bugcrowd/vrt-ruby/actions">
    <img src="https://github.com/bugcrowd/vrt-ruby/workflows/Build/badge.svg" />
  </a>
  <a href="https://www.rubydoc.info/gems/vrt/">
    <img src="https://img.shields.io/badge/doc-rubydoc-informational" />
  </a>
</p>

# VRT Ruby Wrapper
While the Content and Structure is defined in the [Vulnerability Rating Taxonomy Repository](https://github.com/bugcrowd/vulnerability-rating-taxonomy), this defines methods to allow for easy handling of VRT logic.  This gem is used and maintained by [Bugcrowd Engineering](https://bugcrowd.com).

## Getting Started
Add this line to your application's Gemfile:
```ruby
gem 'vrt'
```

To create the initializer:
```bash
rails generate vrt:install
```

## Usage

For convenience in development, we provide a utility for spinning up a
playground for playing with the gem. You can invoke it with:

```bash
bin/console
```

When one has a VRT Classification ID, one can check it's validity:
```ruby
vrt = VRT::Map.new

vrt.valid?('server_side_injection')
=> true

vrt.valid?('test_vrt_classification')
=> false
```

Get a pretty output for its lineage:
```ruby
vrt = VRT::Map.new

vrt.get_lineage('server_side_injection.file_inclusion.local')
=> "Server-Side Injection > File Inclusion > Local"
```

The information within that node:
```ruby
vrt = VRT::Map.new

vrt.find_node('server_side_injection.file_inclusion.local')
```
Which returns the corresponding [`VRT::Node`](https://github.com/bugcrowd/vrt-ruby/blob/master/lib/vrt/node.rb).  This node has a variety of methods:
```ruby
vrt_map = VRT::Map.new

node = vrt_map.find_node('server_side_injection.file_inclusion.local')

node.children # Returns Child Nodes

node.parent # Returns Parent Node

node.priority

node.id

node.name

node.mappings
```

### If you need to deal with mappings between versions
VRT module also has a `find_node` method that is version agnostic.  This is used to find the best
match for a node under any version and has options to specify a preferred version.

#### Examples:
```ruby
# Find a node in a given preferred version that best maps to the given id
VRT.find_node(
  vrt_id: 'social_engineering',
  preferred_version: '1.1'
)
# returns 'other'

# Aggregate vulnerabilities by category
VRT.find_node(
  vrt_id: vrt_id,
  max_depth: 'category'
)

# Query for vulnerabilities by category while maintaining deprecated mappings by adding
# deprecated ids to the search with `all_matching_categories`
categories_to_search_for += VRT.all_matching_categories(categories_to_search_for)
```
