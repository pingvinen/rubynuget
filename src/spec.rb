# encoding: UTF-8

require 'rexml/document'
include REXML

module Nuget
	##
	# Nuspec
	##
	class Spec
		
		def initialize(xml)
			@xml = xml

			@doc = REXML::Document.new(@xml)
		end

		##
		# Get the list of dependencies
		#
		# @returns {String[]}
		##
		def get_dependencies()
			res = []
			
			XPath.each(@doc, "/package/metadata/dependencies/dependency") do |element|
				res.push(element.attribute("id"))
			end

			return res
		end
	end
end