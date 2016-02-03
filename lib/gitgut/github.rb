require 'octokit'

module Gitgut
  # A wrapper around an octokit client
  module Github
    def self.client
      @client ||= Octokit::Client.new(login: Settings.github.login, password: Settings.github.password)
    end

    # A Github pull request
    class PullRequest
      attr_reader :number, :state, :merged_at

      def initialize(payload)
        @number = payload[:number].to_s
        @state = payload[:state]
        # @url = payload[:url]
        # @title = payload[:title]
        @merged_at = payload[:merged_at]
        # @closed_at = payload[:closed_at]
      end

      def color
        case state
        when 'open'
          :white
        when 'closed'
          merged? ? :green : :light_black
        end
      end

      def merged?
        !@merged_at.nil?
      end
    end
  end
end
