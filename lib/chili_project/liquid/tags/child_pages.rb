module ChiliProject::Liquid::Tags
  class ChildPages < BaseTag
    def initialize(tag_name, markup, tokens)
      if markup.present?
        tag_args = markup.split(',')
        @page_name = tag_args.shift.gsub(/["']/,'') # strip quotes
        @page_name.strip!

        @options = extract_options(tag_args, :parent)
        @options[:parent] ||= false
      end
      super
    end

    def render(context)
      # inside of a project
      @project = context['project'].object if context['project'].present?

      if @page_name.present? &&
          (@project.present? || @page_name.include?(':')) # Allow cross project use with project:page_name
        return render_child_pages_from_single_page(context)
      elsif @project.present?
        return render_all_pages(context)
      else
        raise TagError.new('With no argument, this tag can be called from projects only.')
      end

    end

  private

    def render_child_pages_from_single_page(context)
      cross_project_page = @page_name.include?(':')
      page = Wiki.find_page(@page_name.to_s, :project => (cross_project_page ? nil : @project))

      raise TagError.new("No such page '#{@page_name.to_s}'") if page.nil? || !User.current.allowed_to?(:view_wiki_pages, page.wiki.project)

      pages = ([page] + page.descendants).group_by(&:parent_id)
      context.registers[:view].render_page_hierarchy(pages, @options[:parent] ? page.parent_id : page.id)
    end

    def render_all_pages(context)
      return '' unless @project.wiki.present? && @project.wiki.pages.present?
      raise TagError.new('child_pages', 'Page not found') if !User.current.allowed_to?(:view_wiki_pages, @project)

      context.registers[:view].render_page_hierarchy(@project.wiki.pages.group_by(&:parent_id))
    end
  end
end