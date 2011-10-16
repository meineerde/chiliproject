module ChiliProject::Liquid::Tags
  class BaseTag < ::Liquid::Tag
    # @param args [Array, String] An array of strings in "key=value" format
    # @param keys [Hash, Symbol] List of keyword args to extract
    def extract_options(args, *keys)
      options = {}
      args.each do |arg|
        if arg.to_s.gsub(/["']/,'').strip =~ %r{^(.+)\=(.+)$} && keys.include?($1.downcase.to_sym)
          options[$1.downcase.to_sym] = $2
        end
      end
      return options
    end
  end
end
