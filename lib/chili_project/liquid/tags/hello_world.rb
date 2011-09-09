module ChiliProject::Liquid::Tags
  class HelloWorld < BaseTag
    def initialize(tag_name, markup, tokens)
      super
    end

    def render(context)
      "Hello world!"
    end
  end
end