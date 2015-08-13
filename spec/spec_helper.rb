# binary/executable
$LOAD_PATH.unshift File.expand_path('../../bin', __FILE__)
# main module
$LOAD_PATH.unshift File.expand_path('../../lib/gemwarrior', __FILE__)
require 'pry'
require 'game'
