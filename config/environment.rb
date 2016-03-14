require 'rubygems'
require 'bundler/setup'

Bundler.require(:default)

$cache = {}

Miro.options[:resolution] = '16x16'
