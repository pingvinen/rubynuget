# encoding: UTF-8
require 'rubygems'
require 'zip/zip'
require 'zip/zipfilesystem'

module Nuget
	##
	# Wrapper around the RubyZip library
	##
	class ZipHelper

		def initialize(path)
			@path = path
			@zipfile = Zip::ZipFile.open(@path)

			ObjectSpace.define_finalizer(self, proc { @zipfile.self_destruct! })
		end


		##
		# Get the content of a file in the zipfile
		#
		# @param {String} zip_path The filepath within the zipfile to get
		#
		# @returns {String}
		##
		def get_content(zip_path)
			return self.get_entry_content(self.get_entry(zip_path))
		end


		##
		# Get the Zip::ZipEntry for the given path
		#
		# @param {String} zip_path The filepath within the zipfile to get
		#
		# @returns {Zip::ZipEntry}
		##
		def get_entry(zip_path)
			@zipfile.each do |entry|
				next if entry.name =~ /__MACOSX/ or entry.name =~ /\.DS_Store/ or !entry.file?

				return entry if entry.name == zip_path
			end
		end


		##
		# Get a list of entries in a given directory
		#
		# @param {String} zip_path The path of the directory within the zipfile
		#
		# @returns {Zip::ZipEntry[]}
		##
		def get_entries_from_dir(zip_path)
			res = []

			@zipfile.each do |entry|
				next if entry.name =~ /__MACOSX/ or entry.name =~ /\.DS_Store/ or !entry.file?

				next if !entry.name.start_with?(zip_path)

				res.push(entry)
			end

			return res
		end


		##
		# Get a zipentry for the first entry with a given extension
		#
		# @param {String} ext The extension (e.g. "nuspec")
		#
		# @returns {Zip::ZipEntry}
		##
		def get_entry_with_extension(ext)
			@zipfile.each do |entry|
				next if entry.name =~ /__MACOSX/ or entry.name =~ /\.DS_Store/ or !entry.file?

				return entry if entry.name.end_with?(".#{ext}")
			end

			return nil
		end


		##
		# Get the content for a given entry
		#
		# @param {Zip::ZipEntry} entry The entry
		#
		# @returns {String}
		##
		def get_entry_content(entry)
			return entry.get_input_stream.read()
		end

	end
end