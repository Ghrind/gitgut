# Gitgut

Display PR and JIRA tickets info about the branches that are currently checked out on your git repository.

## Expected features

* Show how many commits are not merged in staging/develop
* Show all commits for the branch only
* Allow to checkout a branch from the jira number
* Show if branch has one or more PR and the state of the PR
* Categorize branches by JIRA/NO JIRA, developer/reviewer, JIRA status
* Automatically delete branches that are merged in develop
* Display time retrieving various info

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'gitgut'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install gitgut

## Usage

Add a .gitgut file to the working directory of your application

    # .gitgut
    jira:
      username: first_name.last_name
      password: 'p@$$W0rd'
      endpoint: https://[companyname].atlassian.net/rest/api/2/search

    github:
      login: username
      password: 'p@$$W0rd'
      repo:
        name: name_of_the_repository
        owner: repo_owner_username

And then run gitgut from the same directory

    $ gitgut

### Interactive console

    $ bin/console

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/Ghrind/gitgut.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

