module Gitgut
  # Wrapper around git commands
  #
  # Show commits only on this branch
  # git log --no-merges HEAD --not develop --pretty=oneline
  module Git
    def self.missing_commits_count(from, to)
      `git rev-list #{from}..#{to} --count --no-merges`.to_i
    end
  end
end
