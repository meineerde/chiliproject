module ChiliProject
  module Liquid
    class FileSystem
      def read_template_file(template_name, context)
        raise ::Liquid::FileSystemError.new("Page not found") if template_name.blank?
        project = context['project'].object if context['project'].present?

        cross_project_page = template_name.include?(':')
        page = Wiki.find_page(template_name.to_s.strip, :project => (cross_project_page ? nil : project))
        raise ::Liquid::FileSystemError.new("So such page '#{template_name}'") if page.nil? || !User.current.allowed_to?(:view_wiki_pages, page.wiki.project)

        # Call textilizable on the view so all of the helpers are loaded
        # based on the view and not this tag
        context.registers[:view].textilizable(page.content, :text, :attachments => page.attachments, :headings => false)
      end
    end
  end
end