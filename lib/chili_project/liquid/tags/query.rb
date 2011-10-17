module ChiliProject::Liquid::Tags
  class Query < ::Liquid::Block
    def initialize(tag_name, markup, tokens)
      if markup =~ /(#{::Liquid::VariableSegment}+)/
        @to = $1
      else
        raise SyntaxError.new("Syntax Error in 'query' - Valid syntax: query [var]")
      end

      super
    end

    def render(context)
      query_str = super
      parser = ChiliProject::QueryLanguage::QueryLanguageParser.new
      filters = parser.parse(query_str)
      raise TagError.new(parser.failure_reason) if filters.nil?

      project = context['project'].object if context['project'].present?
      query = ::Query.new(:project => project, :name => "_", :group_by => "")
      filters.value.each do |f|
        # FIXME: This is very incomplete! Find a general way to normalize the
        # operator - value combinations
        case f[:operator]
        when "o"
          f[:values] = ["1"]
        end

        query.add_filter(f[:attribute], f[:operator], f[:values])
      end

      context.scopes.last[@to] = query.to_liquid
      ""
    end
  end
end
