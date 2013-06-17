Ruby Nuget tools
================

I work with Linux and is tired of downloading Nuget packages by hand, so I have written this small tool that lets you create a ruby-script that downloads and extracts a Nuget package. Nothing fancy!

This should become a ruby gem some day, but I do not normally create gems so I have to figure out what to do first :)


Dependencies
------------

```
gem install rubyzip
```


Examples
--------

### ServiceStack and MySql.Data

```ruby
# encoding: UTF-8
require './nuget'

n = Nuget::NugetHelper::new()
n.get_package("ServiceStack", "3.9.49")
n.get_files("net35", "path/where/you/want/the/files")

n.get_package("MySql.Data", "6.6.5")
n.get_files("net40", "path/where/you/want/the/files")
```