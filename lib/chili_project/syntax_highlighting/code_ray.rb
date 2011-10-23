module ChiliProject
  module SyntaxHighlighting
    class CodeRay
      # Highlights +text+ as the content of +filename+
      # Should not return line numbers nor outer pre tag
      def self.highlight_by_filename(text, filename, options={})
        language = ::CodeRay::FileType[filename]
        if language
          # options[:line_numbers] = nil unless options.has_key?(:line_numbers)
          ::CodeRay.scan(text, language).html(options)
        else
          ERB::Util.h(text)
        end
      end

      # Highlights +text+ using +language+ syntax
      # Should not return outer pre tag
      def self.highlight_by_language(text, language, options={})
        default_options = {
          :line_numbers => :inline,
          :line_number_anchors => false,
          :wrap => :span
        }

        options = default_options.merge options
        ::CodeRay.scan(text, language).html(options)
      end
    end
  end
end