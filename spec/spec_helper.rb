require 'serverspec'
require 'docker'

#Include Tests
base_spec_dir = Pathname.new(File.join(File.dirname(__FILE__)))
Dir[base_spec_dir.join('../../drone-tests/shared/**/*.rb')].sort.each { |f| require_relative f }

if not ENV['IMAGE'] then
  puts "You must provide an IMAGE env variable"
end

PACKAGE_NAME='mariadb-server'
LISTEN_PORT=8080
MYSQL_PORT=3306
CONTAINER_START_DELAY=10

RSpec.configure do |c|
  @image = Docker::Image.get(ENV['IMAGE'])
  set :backend, :docker
  set :docker_image, @image.id
  set :docker_container_create_options, {
    'User'     => '100000',
    'HostConfig'   => {
      'PortBindings' => {
        "#{LISTEN_PORT}/tcp" => [ { 'HostPort' => "#{LISTEN_PORT}" } ],
        "#{MYSQL_PORT}/tcp" => [ { 'HostPort' => "#{MYSQL_PORT}" } ]
      }
    }
  }

  describe command("sleep #{CONTAINER_START_DELAY}") do
    its(:stdout) { should eq "" }
  end

  describe "tests" do
    include_examples 'docker-ubuntu-16'
    include_examples 'docker-ubuntu-16-nginx-1.10.0'
    include_examples 'php-7.0-tests'
    include_examples 'phpmyadmin-4.6-tests'
    include_examples 'mariadb-tests'
  end
end
