require "issues_helper"

module RelatedAssigneeIssuesHelperPatch
  # Renders the list of related issues on the issue details view
  def render_issue_relations(issue, relations)
    manage_relations = User.current.allowed_to?(:manage_issue_relations, issue.project)

    s = ''.html_safe
    relations.each do |relation|
      other_issue = relation.other_issue(issue)
      css = "issue hascontextmenu #{other_issue.css_classes}"
      link = manage_relations ? link_to(l(:label_relation_delete),
                                        relation_path(relation),
                                        :remote => true,
                                        :method => :delete,
                                        :data => {:confirm => l(:text_are_you_sure)},
                                        :title => l(:label_relation_delete),
                                        :class => 'icon-only icon-link-break'
      ) : nil

      s << content_tag('tr',
                       content_tag('td', check_box_tag("ids[]", other_issue.id, false, :id => nil), :class => 'checkbox') +
                           content_tag('td', relation.to_s(@issue) {|other| link_to_issue(other, :project => Setting.cross_project_issue_relations?)}.html_safe, :class => 'subject', :style => 'width: 50%') +
                           content_tag('td', other_issue.status, :class => 'status') +
                           content_tag('td', other_issue.start_date, :class => 'start_date') +
                           content_tag('td', other_issue.due_date, :class => 'due_date') +
                           content_tag('td', other_issue.disabled_core_fields.include?('done_ratio') ? '' : progress_bar(other_issue.done_ratio), :class=> 'done_ratio') +
                           content_tag('td', link_to_user(other_issue.assigned_to)) +
                           content_tag('td', link, :class => 'buttons'),
                       :id => "relation-#{relation.id}",
                       :class => css)
    end

    content_tag('table', s, :class => 'list issues odd-even')
  end
end

Rails.application.config.to_prepare do
  IssuesHelper.prepend(RelatedAssigneeIssuesHelperPatch)
end