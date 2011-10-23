module ChiliProject
  module SyntaxHighlighting
    class CodeRay
      # Highlights +text+ as the content of +filename+
      # Should not return line numbers nor outer pre tag
      def self.highlight_by_filename(text, filename)
        language = ::CodeRay::FileType[filename]
        language ? ::CodeRay.scan(text, language).html : ERB::Util.h(text)
      end

      # Highlights +text+ using +language+ syntax
      # Should not return outer pre tag
      def self.highlight_by_language(text, language)
        ::CodeRay.scan(text, language).html(:line_numbers => :inline, :wrap => :span)
      end
    end
  end
end