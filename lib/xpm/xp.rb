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
    
    def init(name)
      install("simple", name)
      rvm(name)
    end

    def new(name, *args)
      install("master", name)
      rvm(name)
    end

    private 

    def install(branch, name)
      tarball = "#{branch}.tar.gz"
      url = "https://github.com/capi5k/capi5k-init/tarball/#{branch}"

      @logger.info "Downloading project skeleton"
      # begin / rescue...
      open(tarball, 'w') do |local_file|
        open(url) do |remote_file|
          local_file.write(Zlib::GzipReader.new(remote_file).read)
        end
      end

      cmd = "tar -xvzf #{branch}.tar.gz"
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

    def rvm(name)
      File.open("#{name}/.ruby-version", 'w') { |file| file.write("#{RUBY_VERSION}-p#{RUBY_PATCHLEVEL}") }
      File.open("#{name}/.ruby-gemset", 'w') { |file| file.write("capi5k-#{name}") }
    end



  end
end

