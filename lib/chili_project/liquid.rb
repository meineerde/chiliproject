module ChiliProject
  module Liquid
  end
end

Liquid::Template.file_system = ChiliProject::Liquid::FileSystem.new
