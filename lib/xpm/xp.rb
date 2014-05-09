require 'open-uri'
require 'zlib'
require 'open3'
require 'logger'
require 'json'
require 'fileutils'

module XPM
  class XP


    def initialize(options = {})
      @logger = options[:logger] || Logger.new(STDOUT)
    end
    
    def new(name, *args)
      tarball = "master.tar.gz"
      url = "https://github.com/capi5k/capi5k-init/tarball/master"

      @logger.info "Downloading project skeleton"
      # begin / rescue...
      open(tarball, 'w') do |local_file|
        open(url) do |remote_file|
          local_file.write(Zlib::GzipReader.new(remote_file).read)
        end
      end

      cmd = 'tar -xvzf master.tar.gz'
      Open3.popen3(cmd) do |stdin, stdout, stderr, wait_thr|
        @logger.info "Extracting project skeleton"
        err = stderr.read
        @logger.error err unless err.empty?
      end

      FileUtils.rm tarball

      temp= %r{.*capi5k-init.*}
      all_files = Dir.glob("*")
      my_files  = all_files.grep(temp)
      
      if my_files.length != 1
        puts "error"
      else
        FileUtils.mv my_files[0], name
      end
      @logger.info "New project initialized"

    end # init

    def install(package = nil)
      
      # TODO @depmanager.preinstall ?

      cmd = 'bower install ' + package.to_s
      # TODO abstract this (@depmanager.install)
      Open3.popen3(cmd) do |stdin, stdout, stderr, wait_thr|
        @logger.info "installing dependencies"
        @logger.info stdout.read
        err = stderr.read
        @logger.error err unless err.empty?
      end

      # TODO hook postinstall (@depmanager.postinstall)
      # for now loop over bower_components/* and export
      # files to ./exports/<module name>/.
      mpath = "bower_components"
      bowers = Dir.glob("#{mpath}/*");

      # TODO rescue
      bowers.each do |bower|
        desc = File.read(File.join(bower, "bower.json"))
        desc = JSON.parse(desc)
        mname = File.basename(bower)
        destination_directory = File.join("exports", mname, ".")
        exports = desc["exports"]
        @logger.debug exports
        exports.each do |export|
          source_file = File.join(bower, export)
          FileUtils.mkdir_p destination_directory
          FileUtils.cp source_file, destination_directory
        end unless exports.nil?
      end

    end # install

  end
end

