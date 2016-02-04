# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'gitgut/version'

Gem::Specification.new do |spec|
  spec.name          = "gitgut"
  spec.version       = Gitgut::VERSION
  spec.authors       = ["Benoit Dinocourt"]
  spec.email         = ["ghrind@gmail.com"]

  spec.summary       = %q{See your branches, Github PRs and JIRA tickets in one glance!}
  spec.description   = %q{Display PR and JIRA tickets info about the branches that are currently checked out on your git repository.}
  spec.homepage      = "https://github.com/Ghrind/gitgut"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  # TODO: Add required versions
  spec.add_dependency 'colorize'
  spec.add_dependency 'httparty'
  spec.add_dependency 'parallel'
  spec.add_dependency 'terminal-table'
  spec.add_dependency 'octokit'
  spec.add_dependency 'settingslogic'

  spec.add_development_dependency "bundler", "~> 1.11"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.0"
  spec.add_development_dependency 'webmock'
  spec.add_development_dependency 'simplecov'
  # spec.add_development_dependency 'pry-byebug'
end
