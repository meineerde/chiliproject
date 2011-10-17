module ChiliProject::Liquid
  module Tags
    class TagError < StandardError; end

    def self.register_tag(name, klass, options={})
      if options[:html]
        html_class = Class.new do
          def render(context)
            result = @tag.render(context)
            context.html_result(result)
          end

          def method_missing(*args, &block)
            @tag.send(*args, &block)
          end
        end
        html_class.send :define_method, :initialize do |*args|
          @tag = klass.new(*args)
        end
        ::Liquid::Template.register_tag(name, html_class)
      else
        ::Liquid::Template.register_tag(name, klass)
      end
    end

    # Overwrite the built-in include tag with our adapted version
    register_tag('include', Include, :html => true)

    register_tag('hello_world', HelloWorld)
    register_tag('variable_list', VariableList, :html => true)
    register_tag('tag_list', TagList)
    register_tag('child_pages', ChildPages, :html => true)
  end
end

# FIXME: remove the old syntax soon, provide a way to migrate existing pages
# to the new syntax.
# {{child_pages(Foo)}} --> {% child_pages 'Foo' %}
ChiliProject::Liquid::Legacy.add('child_pages', :tag)
# {{include(Foo)}} --> {% include 'Foo' %}
ChiliProject::Liquid::Legacy.add('include', :tag)
