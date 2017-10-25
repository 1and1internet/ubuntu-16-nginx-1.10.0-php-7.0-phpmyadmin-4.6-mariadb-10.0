require 'rspec'
require 'serverspec'
require 'docker'
require_relative '../../drone-tests/shared/jemonkeypatch.rb'

#Include Tests
base_spec_dir = Pathname.new(File.join(File.dirname(__FILE__)))
Dir[base_spec_dir.join('../../drone-tests/shared/**/*.rb')].sort.each { |f| require_relative f }

if not ENV['IMAGE'] then
  puts "You must provide an IMAGE env variable"
end

PACKAGE_NAME='mariadb-server'
LISTEN_PORT=8080
MARIADB_PORT=3306
CONTAINER_START_DELAY=30

set :backend, :docker
@image = Docker::Image.get(ENV['IMAGE'])
set :docker_image, @image.id
#set :docker_debug, true
set :docker_container_start_timeout, 120
set :docker_container_ready_regex, /mysqld_safe Logging to syslog/
set :docker_container_create_options, {
  'Image'      => @image.id,
  'User'       => '100000',
  'HostConfig' => {
     'Memory' => 1073741824
  },
  'Env' => [
      'MYSQL_ROOT_PASSWORD=In$ecureTe$t1ngPa$$w0rd'
  ]
}

RSpec.configure do |c|
  describe "tests" do
    include_examples 'docker-ubuntu-16'
    include_examples 'docker-ubuntu-16-nginx-1.10.0'
    include_examples 'php-7.0-tests'
    include_examples 'phpmyadmin-4.6-tests'
    include_examples 'mariadb-tests'
  end
end
