DEAD
====

I no longer maintain this repository. I have started using a simple bash script instead

```bash
#!/usr/bin/env bash

TMPZIP=/tmp/from_nuget.zip
TMPDIR=/tmp/from_nuget
DEST=libs/

function get_package() {
  local name=$1
	local version=$2
	local dir=$3
	echo "$name $version"
	wget --quiet -O $TMPZIP http://packages.nuget.org/api/v2/package/$name/$version
	unzip -q -o $TMPZIP lib/* -d $TMPDIR

	find $TMPDIR/lib/$dir -type f \( -iname "*.dll" -o -iname "*.xml" \) -exec mv '{}' $DEST \;

	rm $TMPDIR -rf
	rm $TMPZIP
}


get_package "ServiceStack" "3.9.56" "net35"
```


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

n = Nuget::NugetHelper.new()
n.get_package("ServiceStack", "3.9.49")
n.get_files("net35", "path/where/you/want/the/files")

n.get_package("MySql.Data", "6.6.5")
n.get_files("net40", "path/where/you/want/the/files")
```



### Figuring out which lib/ subdir to get files from

The following will write the full path of all files in the package to the console.

```ruby
# encoding: UTF-8
require './nuget'

n = Nuget::NugetHelper.new()
n.get_package("ServiceStack", "3.9.49")
n.list_all_files()
```
