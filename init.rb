require "redmine"
require "related_assignee_issues_helper_patch"

Redmine::Plugin.register :related_issues_assignee do
  name "Redmine Related Issues Assignee"
  author "Senya"
  description "Adds 'Assigned To' column to 'Related Issues' list"
  version "0.1.0"
end