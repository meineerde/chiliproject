require 'chili_project/liquid/liquid_ext'
require 'chili_project/liquid/variables'
require 'chili_project/liquid/filters'
require 'chili_project/liquid/tags'
require 'chili_project/liquid/legacy'

module ChiliProject
  module Liquid
    Liquid::Template.file_system = FileSystem.new
  end
end