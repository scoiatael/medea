# frozen_string_literal: true

# Make it more obvious that a PR is a work in progress and shouldn't be merged yet
warn('PR is classed as Work in Progress') if github.pr_title.include? '[WIP]'

# Warn when there is a big PR
warn('Big PR') if git.lines_of_code > 500

# Don't let testing shortcuts get into master by accident
raise('fdescribe left in tests') if `grep -r fdescribe spec/ `.length > 1
raise('fit left in tests') if `grep -r fit spec/ `.length > 1

commit_lint.check warn: :all

github.dismiss_out_of_range_messages
rubocop.lint(inline_comment: true)

changelog.format = :keep_a_changelog
changelog.check!
