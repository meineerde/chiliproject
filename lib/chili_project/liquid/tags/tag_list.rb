module ChiliProject::Liquid::Tags
  class TagList < BaseTag
    include ActionView::Helpers::TagHelper

    def render(context)
      "\np. Tags:\n\n" +
      ::Liquid::Template.tags.keys.sort.collect {|tag_name|
        "* <code>#{tag_name}</code>"
      }.join("\n") + "\n"
    end
  end
end