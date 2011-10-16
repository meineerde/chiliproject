module ChiliProject::Liquid
  module Tags

    def self.register_tag(name, klass, options={})
      if options[:html]
        html_class = Class.new do
          def render(context)
            result = @tag.render(context)

            context.registers[:html_tag_result] ||= []
            length = context.registers[:html_tag_result].length
            context.registers[:html_tag_result] << result

            "{{html_tag_result.#{length}}}"
          end

          def method_missing(*args, &block)
            @tag.send(*args, &block)
          end
        end
        html_class.send :define_method, :initialize do |*args|
          @tag = klass.new(*args)
        end
        Liquid::Template.register_tag(name, html_class)
      else
        Liquid::Template.register_tag(name, klass)
      end
    end

    register_tag('hello_world', HelloWorld)
    register_tag('variable_list', VariableList, :html => true)
    register_tag('tag_list', TagList)
    register_tag('child_pages', ChildPages, :html => true)
  end
end

# ChiliProject::Liquid::Legacy.add('child_pages', :tag)
# ChiliProject::Liquid::Legacy.add('include', :tag)
