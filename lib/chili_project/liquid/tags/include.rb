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

module ChiliProject::Liquid::Tags
  class Include < ::Liquid::Include

    # This method overrides the default in liquid
    def render(context)
      context.stack do
        template = _read_template_from_file_system(context)
        partial = Liquid::Template.parse _template_source(template)
        variable = context[@variable_name || @template_name[1..-2]]

        @attributes.each do |key, value|
          context[key] = context[value]
        end

        if variable.is_a?(Array)
          variable.collect do |variable|
            context[@template_name[1..-2]] = variable
            _render_partial(partial, template, context)
          end
        else
          context[@template_name[1..-2]] = variable
          _render_partial(partial, template, context)
        end
      end
    end

  private
    def _template_source(wiki_content)
      wiki_content.text
    end

    def _render_partial(partial, template, context)
      textile = partial.render(context)

      # Call textilizable on the view so all of the helpers are loaded
      # based on the view and not this tag
      context.registers[:view].textilizable(textile, :attachments => template.page.attachments, :headings => false)
    end

    def _read_template_from_file_system(context)
      wiki_content = super

      # Set the new project to that additional includes use the correct
      # base project
      context['project'] = wiki_content.page.wiki.project
      wiki_content
    end
  end
end
