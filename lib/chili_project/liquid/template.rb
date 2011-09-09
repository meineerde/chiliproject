module ChiliProject
  module Liquid
    class Template < ::Liquid::Template
      # creates a new <tt>Template</tt> object from liquid source code
      def self.parse(source)
        template = self.new
        template.parse(source)
        template
      end

      def render(*args)
        # force the html_tag_result variable to nil
        # it is used internally to move handle the output of HTML producing
        # tags. These are included at the very last stage, after the Textile
        # to HTML transformation
        case args.first
        when ::Liquid::Context
          args.first.environments[0]['html_tag_result'] = nil
        when Hash
          args.first['html_tag_result'] = nil
        when nil
          args.first = {'html_tag_result' => nil}
        end

        options = args.last
        options[:registers] ||= {}
        options[:registers][:html_tag_result] = html_tag_result = []
        obj = options[:registers][:object]
        attr = options[:registers][:attribute]

        text = super(*args)

        text = Redmine::WikiFormatting.to_html(Setting.text_formatting, text, :object => obj, :attribute => attr)
        text.gsub(/\{\{html_tag_result\.(\d+)\}\}/) do |match|
          html_tag_result[$1.to_i]
        end
      end
    end
  end
end
