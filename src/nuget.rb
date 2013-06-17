# encoding: UTF-8
require 'rubygems'
require 'zip/zip'
require 'zip/zipfilesystem'
require 'net/http'

require './spec'
require './ziphelper'

module Nuget
	##
	# Nuget helper class.
	# This downloads and extracts packages
	##
	class NugetHelper

		def initialize()
			@apiversion = "v2"
			@tmp = "/tmp/rubynugettmp.nupkg"
		end

		##
		# Get package
		#
		# @param {String} name The name of the package (e.g. "ServiceStack")
		# @param {String} version The package version to get (e.g. "3.9.49")
		#
		# @returns {void}
		##
		def get_package(name, version)
			self.download("http://packages.nuget.org/api/#{@apiversion}/package/#{name}/#{version}", @tmp)
			@zip = Nuget::ZipHelper.new(@tmp)
		end


		##
		# Get Nuspec
		#
		# @returns {Nuget::Spec}
		##
		def get_spec()
			@zip = Nuget::ZipHelper.new(@tmp) if @zip == nil
			entry = @zip.get_entry_with_extension("nuspec")
			return Nuget::Spec.new(@zip.get_entry_content(entry))
		end



		##
		# Get files from the lib/ dir
		#
		# @param {String} libdir The directory under lib/ from which to get files
		# @param {String} destination Path to the directory to which files should be extracted
		#
		# @returns {void}
		##
		def get_files(libdir, destination)
			@zip = Nuget::ZipHelper.new(@tmp) if @zip == nil
			@zip.get_entries_from_dir("lib/#{libdir}").each do |entry|
				open("#{destination}/#{File.basename(entry.name)}", 'w') do |io|
					io.write(@zip.get_entry_content(entry))
				end
			end
		end



		##
		# Download package
		#
		# @param {String} url The URL of the package
		# @param {String} download_destination Where to store the file on disk
		# @param {Number} location_jump_limit How many redirects to allow
		##
		def download(url, download_destination, location_jump_limit = 10)
	  		raise ArgumentError, 'too many HTTP redirects' if location_jump_limit == 0

			uri = URI(url)

			Net::HTTP.start(uri.host, uri.port) do |http|
				request = Net::HTTP::Get.new(uri.request_uri)

				http.request request do |response|

					case response
					when Net::HTTPSuccess then
						open(download_destination, 'w') do |io|
							response.read_body do |chunk|
								io.write chunk
							end
						end

					when Net::HTTPRedirection then
						self.download(response['location'], download_destination, location_jump_limit - 1)
					end
				end
			end
		end
	end
end