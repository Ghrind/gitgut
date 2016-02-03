module Gitgut
  class Branch
    def initialize(name)
      @raw_name = name
    end

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
      matches = name.match /^jt-(?<id>\d+)/i
      if matches
        return 'JT-' + matches[:id]
      end
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
      if valid?
        (!pull_requests.empty? && pull_requests.all?(&:merged?)) ? :green : :white
      else
        :red
      end
    end

    def valid?
      return false if develop_is_ahead_of_staging?
      return false if should_be_merged_in_staging?
      true
    end

    def develop_is_ahead_of_staging?
      to_develop > 0 && to_develop < to_staging
    end

    def should_be_merged_in_staging?
      return false unless ticket
      if ['In Functional Review', 'In Review', 'Ready for Release'].include?(ticket.status) &&
        to_staging > 0
        return true
      end
      false
    end

    def merged_everywhere?
      to_staging.zero? && to_develop.zero?
    end

    def action_suggestion
      return 'Review the PR' if ticket && ticket.assigned_to_me? && ticket.in_review?
      return 'Merge into staging' if should_be_merged_in_staging?
      return 'Merge into staging or update your staging branch' if develop_is_ahead_of_staging?
      if ticket
        return 'Do some code' if ticket.assigned_to_me?
        return 'Assign the ticket to me (and start the development)' if ticket.assignee.nil?
      end
      return 'Delete the local branch' if merged_everywhere? && (!ticket || ticket.ready_for_release?)
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
