module Gitgut
  # A local git branch
  class Branch
    def initialize(name)
      @raw_name = name
    end

    # TODO: Sanitization should be done elsewhere
    def name
      return @name if @name
      match_data = /[ *]+(?<branch>[^\s]*)/.match @raw_name
      @name = match_data[:branch]
    end

    def to_develop
      Gitgut::Git.missing_commits_count('develop', name)
    end

    def from_develop
      Gitgut::Git.missing_commits_count(name, 'develop')
    end

    def to_staging
      Gitgut::Git.missing_commits_count('staging', name)
    end

    def from_staging
      Gitgut::Git.missing_commits_count(name, 'staging')
    end

    def pull_requests
      @pull_requests ||= Gitgut::Github.client.pull_requests("#{Settings.github.repo.owner}/#{Settings.github.repo.name}", state: 'all', head: "#{Settings.github.repo.owner}:#{name}").map { |pr| Gitgut::Github::PullRequest.new(pr) }
    end

    def jira_ticket_number
      matches = name.match(/^jt-(?<id>\d+)/i)
      return 'JT-' + matches[:id] if matches
    end

    def ticket
      return @ticket if defined?(@ticket)
      if jira_ticket_number
        payload = Gitgut::Jira.request 'id=' + jira_ticket_number
        return @ticket = nil if payload['issues'].empty?
        @ticket = Gitgut::Jira::Ticket.new(payload['issues'].first)
      else
        @ticket = nil
      end
    end

    def color
      return :red unless valid?
      if has_pull_requests? && all_pull_requests_merged?
        :green
      else
        :white
      end
    end

    def all_pull_requests_merged?
      pull_requests.all?(&:merged?)
    end

    def has_pull_requests?
      !pull_requests.empty?
    end

    def valid?
      return false if develop_is_ahead_of_staging?
      return false if merge_in_staging_required_by_ticket_status?
      true
    end

    def develop_is_ahead_of_staging?
      to_develop > 0 && to_develop < to_staging
    end

    def merge_in_staging_required_by_ticket_status?
      return false unless ticket
      if ['In Functional Review', 'In Review', 'Ready for Release'].include?(ticket.status) && to_staging > 0
        return true
      end
      false
    end

    def merged_everywhere?
      to_staging.zero? && to_develop.zero?
    end

    def action_suggestion
      return 'Review the PR' if ticket && ticket.assigned_to_me? && ticket.in_review?
      return 'Merge into staging' if merge_in_staging_required_by_ticket_status?
      return 'Merge into staging or update your staging branch' if develop_is_ahead_of_staging?
      if ticket
        return 'Do some code' if ticket.assigned_to_me?
        return 'Assign the ticket to me (and start the development)' if ticket.assignee.nil? && !ticket.done?
      end
      return 'Delete the local branch' if (merged_everywhere? && (!ticket || ticket.done?)) || (ticket && ticket.closed?)
    end

    def preload!
      ticket
      pull_requests
      to_staging
      to_develop
      self
    end
  end
end
