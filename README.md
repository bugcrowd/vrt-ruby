<p align="center">
  <img src="https://user-images.githubusercontent.com/1854876/28642569-b44a823a-7207-11e7-8f26-af023adc5d22.png" />
</p>
<p align="center">
  <img src="https://badge.fury.io/rb/vrt.svg" />
  <img src="https://badge.buildkite.com/d9023f789854d9a40404670f02871ffe89f8ac214524e1cbdf.svg?branch=master" />
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
