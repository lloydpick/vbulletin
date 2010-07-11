require 'rubygems'

gem 'eventmachine', '>= 0.12.10'
require 'eventmachine'
include EM::Deferrable

require 'uri'
require 'cgi'

require "#{File.dirname(__FILE__)}/vbulletin/base.rb"
require "#{File.dirname(__FILE__)}/vbulletin/forum.rb"