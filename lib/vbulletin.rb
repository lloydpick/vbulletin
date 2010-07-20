require 'rubygems'

gem 'nokogiri', '1.4.2'
gem 'mechanize', '1.0.0'
gem 'chronic', '0.2.3'
require 'activesupport'
require 'chronic'
require 'mechanize'

require 'uri'
require 'cgi'

require "#{File.dirname(__FILE__)}/vbulletin/base.rb"
require "#{File.dirname(__FILE__)}/vbulletin/forum.rb"
require "#{File.dirname(__FILE__)}/vbulletin/search.rb"
require "#{File.dirname(__FILE__)}/vbulletin/thread.rb"
require "#{File.dirname(__FILE__)}/vbulletin/post.rb"