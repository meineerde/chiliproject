module ChiliProject
  module Liquid
    module LiquidExt
      module Context
        def self.included(base)
          base.send(:include, InstanceMethods)
          base.class_eval do
            alias_method_chain :handle_error, :formatting
          end
        end

        module InstanceMethods
          def handle_error_with_formatting(e)
            error = handle_error_without_formatting(e)
            escaped_error = registers[:view].send(:h, error) rescue CGI::escapeHTML(error)

            html = '<div class="flash error">' + escaped_error + '</div>'
            html_result(html)
          end
        end
      end
    end
  end
end