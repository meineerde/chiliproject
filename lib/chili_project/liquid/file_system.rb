module ChiliProject
  module Liquid
    class FileSystem
      def read_template_file(template_name, context)
        raise ::Liquid::FileSystemError.new("Page not found") if template_name.blank?
        project = Project.find(context['project'].identifier) if context['project'].present?

        cross_project_page = template_name.include?(':')
        page = Wiki.find_page(template_name.to_s.strip, :project => (cross_project_page ? nil : project))
        raise ::Liquid::FileSystemError.new("So such page '#{template_name}'") if page.nil? || !User.current.allowed_to?(:view_wiki_pages, page.wiki.project)

        page.content
      end
    end
  end
end