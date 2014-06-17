require 'open-uri'
require 'zlib'
require 'open3'
require 'logger'
require 'json'
require 'fileutils'

module XPM
    
  module Depmanager
  
    class Bower < Abstract
    
      def initialize(options = {})
        @logger = options[:logger] || Logger.new(STDOUT)
      end
    
    
      def install(package=nil)
        _preinstall(package)
        _install(package)
        _postinstall(package)
      end

      def link(package=nil)
        cmd = 'bower link ' + package.to_s
        Open3.popen3(cmd) do |stdin, stdout, stderr, wait_thr|
          @logger.info "Linking " + package.to_s
          @logger.info stdout.read
          err = stderr.read
          @logger.error err unless err.empty?
        end
      end

      def cacheclean
        cmd = 'bower cache clean ' 
        Open3.popen3(cmd) do |stdin, stdout, stderr, wait_thr|
          @logger.info "Cleaning the cache "
          @logger.info stdout.read
          err = stderr.read
          @logger.error err unless err.empty?
        end
      end

      def cachelist
        cmd = 'bower cache list ' 
        Open3.popen3(cmd) do |stdin, stdout, stderr, wait_thr|
          @logger.info "Linking " 
          @logger.info stdout.read
          err = stderr.read
          @logger.error err unless err.empty?
        end
      end

      def export
        _postinstall
      end

      private

      def _preinstall(package=nil)
      end

      def _install(package=nil)
        cmd = 'bower install ' + package.to_s
        # TODO abstract this (@depmanager.install)
        Open3.popen3(cmd) do |stdin, stdout, stderr, wait_thr|
          @logger.info "Installing dependencies"
          @logger.info stdout.read
          err = stderr.read
          @logger.error err unless err.empty?
        end
      end

      def _postinstall(package=nil)
        mpath = "xpm_modules"
        bowers = Dir.glob("#{mpath}/*");

        # TODO rescue
        bowers.each do |bower|
          desc = File.read(File.join(bower, "bower.json"))
          desc = JSON.parse(desc)
          mname = File.basename(bower)
          exports = desc["exports"]
          @logger.debug "exporting files for #{mname}" 
          exports.each do |export|
            source_file = File.join(bower, export)
            destination_file = File.join("exports", mname, export)
            destination_directory = File.dirname(destination_file)
            FileUtils.mkdir_p destination_directory
            if (!File.exist?(destination_file))
              @logger.debug "exporting #{export}" 
              FileUtils.cp source_file, destination_file
            end
          end unless exports.nil?
        end
      end

    end

  end

end

