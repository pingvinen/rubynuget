# encoding: UTF-8
require './nuget'

n = Nuget::NugetHelper::new()
n.get_package("ServiceStack", "3.9.49")
n.get_files("net35", "tmp")

n.get_package("MySql.Data", "6.6.5")
n.get_files("net40", "tmp")