#-- copyright
# ChiliProject is a project management system.
#
# Copyright (C) 2010-2011 the ChiliProject Team
#
# This program is free software; you can redistribute it and/or
# modify it under the terms of the GNU General Public License
# as published by the Free Software Foundation; either version 2
# of the License, or (at your option) any later version.
#
# See doc/COPYRIGHT.rdoc for more details.
#++

# DECREACATED SINCE 3.0 - TO BE REMOVED IN 4.0
# The whole macro concept is deprecated. It is to be completely replaced by
# Liquid tags and variables.

module Redmine
  module WikiFormatting
    module Macros
      @available_macros = {}

      class << self
        def register(&block)
          ActiveSupport::Deprecation.warn("Macros are deprecated. Use Liquid filters and tags instead")
          class_eval(&block) if block_given?
        end

      private
        # Sets description for the next macro to be defined
        def desc(txt)
          @desc = txt
        end

        # Defines a new macro with the given name and block.
        def macro(name, &block)
          name = name.to_sym if name.is_a?(String)
          @available_macros[name] = @desc || ''
          @desc = nil
          raise "Can not create a macro without a block!" unless block_given?

          tag = Class.new(::Liquid::Tag) do
            def initialize(tag_name, markup, tokens)
              if markup =~ self.class::Syntax
                @args = $1[1..-2].split(',').collect(&:strip)
              else
                raise ::Liquid::SyntaxError.new("Syntax error in tag '#{name}'")
              end
            end

            # to allow macros to access functions in the current view scope
            def method_missing(method, *args)
              @_context.registers[:view].send(method, *args)
            end
          end
          tag.send :define_method, :render do |context|
            @_context = context
            @project = context['project'].object if context['project'].present?
            instance_exec nil, @args, &block
          end
          tag.const_set 'Syntax', /(#{::Liquid::QuotedFragment})/

          Dispatcher.to_prepare do
            Liquid::Template.register_tag(name, tag)
            ChiliProject::Liquid::Legacy.add(name, :tag)
          end
        end
      end
    end
  end
end
