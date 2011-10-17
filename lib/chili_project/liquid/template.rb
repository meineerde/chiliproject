module ChiliProject
  module Liquid
    class Template < ::Liquid::Template
      # creates a new <tt>Template</tt> object from liquid source code
      def self.parse(source)
        template = self.new
        template.parse(source)
        template
      end

      # Render takes a hash with local variables.
      #
      # if you use the same filters over and over again consider registering them globally
      # with <tt>Template.register_filter</tt>
      #
      # Following options can be passed:
      #
      #  * <tt>filters</tt> : array with local filters
      #  * <tt>registers</tt> : hash with register variables. Those can be accessed from
      #    filters and tags and might be useful to integrate liquid more with its host application
      #
      def render(*args)
        # Force the html_tag_result variable to nil
        # This is a safety measure to make sure that the internal rendered HTML
        # can not be accessed on the outside during the Liquid rendering phase
        #
        # It is used internally to move handle the output of HTML producing
        # tags. These are included at the very last stage, after the Wiki markup
        # to HTML transformation
        case args.first
        when ::Liquid::Context
          args.first.environments[0]['html_tag_result'] = nil
        when Hash
          args.first['html_results'] = nil
        when nil
          args.first = {'html_results' => nil}
        end

        case args.last
        when Hash
          options = args.last
        when Module, Array
          options = args.last = {:filters => args.last}
        else
          options = args.last = {}
        end

        # We get hold of the registers hash here for later usage.
        # Yes, this is a bit ugly but required as we have no access to the
        # actually used context object here which holds the values.
        options[:registers] ||= {}
        options[:registers][:html_results] = html_results = {}

        obj = options[:registers][:object]
        attr = options[:registers][:attribute]

        # ENTER THE RENDERING STAGE

        # 1. Render the input as Liquid
        #    Some tags might register final HTML output in this stage.
        text = super(*args)

        # 2. Perform the Wiki markup transformation (e.g. Textile)
        text = Redmine::WikiFormatting.to_html(Setting.text_formatting, text, :object => obj, :attribute => attr)

        # 3. Now finally, replace the captured raw HTML bits in the final content
        html_results.each_pair do |key, value|
          text.sub!(/\{\{html_results\.#{key}\}\}/, value)
        end
        text
      end
    end
  end
end
