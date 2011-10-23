#-- copyright
# ChiliProject is a project management system.
#
# Copyright (C) 2010-2011 the ChiliProject Team
#
# This program is free software; you can redistribute it and/or
# modify it under the terms of the GNU General Public License
# as published by the Free Software Foundation; either version 2
# of the License, or (at your option) any later version.
#
# See doc/COPYRIGHT.rdoc for more details.
#++

module ChiliProject
  module SyntaxHighlighting
    class << self
      def highlighter=(name_or_module)
        @highlighter = name.is_a?(Module) ? name : const_get(name)
      end

      def highlighter
        @highlighter ||= ChiliProject::SyntaxHighlighting::CodeRay
      end

      def highlight_by_filename(text, filename)
        highlighter.highlight_by_filename(text, filename)
      end

      def highlight_by_language(text, language)
        highlighter.highlight_by_language(text, language)
      end
    end
  end
end
