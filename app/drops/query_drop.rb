class QueryDrop < BaseDrop
  allowed_methods :issues
  allowed_methods :count

  def issues
    @object.issues(
      :include => [:assigned_to, :tracker, :priority, :category, :fixed_version],
      :order => "#{Issue.table_name}.id ASC"
    )
  end

  def count
    @object.issue_count
  end
end



