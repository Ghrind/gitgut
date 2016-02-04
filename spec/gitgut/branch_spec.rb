require 'spec_helper'

RSpec.describe Gitgut::Branch do
  subject { Gitgut::Branch.new 'my-branch' }

  describe '#color' do
    context 'when the branch is not valid' do
      before do
        expect(subject).to receive(:valid?).and_return false
      end
      it 'should return :red' do
        expect(subject.color).to eq :red
      end
    end
    context 'when the branch is valid' do
      before do
        expect(subject).to receive(:valid?).and_return true
      end
      context 'when all the PR of the branch are merged' do
        before do
          expect(subject).to receive(:has_pull_requests?).and_return true
          expect(subject).to receive(:all_pull_requests_merged?).and_return true
        end
        it 'should return :green' do
          expect(subject.color).to eq :green
        end
      end
      context 'when the branch has no pull requests' do
        before do
          expect(subject).to receive(:has_pull_requests?).and_return false
        end
        it 'should return :white' do
          expect(subject.color).to eq :white
        end
      end
      context 'when the all the PR are not merged' do
        before do
          expect(subject).to receive(:has_pull_requests?).and_return true
          expect(subject).to receive(:all_pull_requests_merged?).and_return false
        end
        it 'should return :white' do
          expect(subject.color).to eq :white
        end
      end
    end
  end

  describe '#ticket' do
    it 'should be memoized even if the ticket is nil'
  end

  describe '#all_pull_requests_merged?' do
    context 'when all pull requests are merged' do
      it 'should return true'
    end
    context 'when a pull request is not merged' do
      it 'should return false'
    end
  end

  describe '#has_pull_requests' do
    context 'when there is no PR' do
      it 'should return false'
    end
    context 'when there is a PR' do
      it 'should return true'
    end
  end

  describe '#develop_is_ahead_of_staging?' do
    context 'when develop is at the same level as staging' do
      it 'should return false'
    end
    context 'when develop is ahead of staging' do
      it 'should return true'
    end
    context 'when staging is ahead of develop' do
      it 'should return false'
    end
  end

  describe '#merge_in_staging_required_by_ticket_status?' do
    context 'when there is not ticket' do
      it 'should return false'
    end
    context 'when there is a ticket' do
      context 'when ticket has a development status' do
        it 'should return false'
      end
      context 'when ticket has a post-development status' do
        context 'when staging is up to date' do
          it 'should return false'
        end
        context 'when staging is not up to date' do
          it 'should return true'
        end
      end
    end
  end

  describe '#merged_everywhere?' do
    context 'when staging is not up to date' do
      it 'should return false'
    end
    context 'when develop is not up to date' do
      it 'should return false'
    end
    it 'should return true'
  end

  describe '#preload' do
    it 'should load ticket'
    it 'should load PRs'
    it 'should load staging status'
    it 'should load develop status'
  end

  describe '#valid?' do
    it 'should return true'
    context 'when develop_is_ahead_of_staging? is false' do
      it 'should return false'
    end
    context 'when merge_in_staging_required_by_ticket_status? is false' do
      it 'should return false'
    end
  end

  describe '#jira_ticket_number' do
    it 'should return nil'
    context 'when the branch name is prefixed by a jira key' do
      it 'should return the jira key'
    end
  end
end
