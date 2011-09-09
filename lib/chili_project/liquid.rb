require 'chili_project/liquid/variables'
require 'chili_project/liquid/filters'
require 'chili_project/liquid/liquid_ext'
require 'chili_project/liquid/tags'
require 'chili_project/liquid/legacy'

module ChiliProject
  module Liquid
  end
end

Liquid::Template.file_system = ChiliProject::Liquid::FileSystem.new
