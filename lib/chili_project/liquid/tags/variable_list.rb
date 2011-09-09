module ChiliProject::Liquid::Tags
  class VariableList < BaseTag
    include ActionView::Helpers::TagHelper

    def initialize(tag_name, markup, tokens)
      super
    end

    def render(context)
      out = ''
      context.environments.first.keys.sort.each do |liquid_variable|
        next if liquid_variable == 'text' # internal variable
        out << content_tag('li', content_tag('code', h(liquid_variable)))
      end if context.environments.present?

      content_tag('p', "Variables:") +
        content_tag('ul', out)
    end
  end
end