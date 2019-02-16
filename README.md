# Programming Challenge

## Objective

**Implement a ToDo Service** which can be used via a RESTful API. For an example frontend application have
a look [here](http://todomvc.com/examples/react/). The task is to only focus on the API layer.

Key features:
 * Store ToDo-Items in a database.
 * A ToDo-Item consists of at least a `title` (string, required) and `read` flag (boolean, default: false)
 * Provide a [CRUD](https://en.wikipedia.org/wiki/Create,_read,_update_and_delete)- and [RESTful](https://en.wikipedia.org/wiki/Representational_state_transfer)-API-Endpoint for a ToDo-List
 * Write tests for your API & Models
 * Write meaningful commit messages

Nice to haves:
 * [JSON API Spec](http://jsonapi.org/) compliance
 * Provide a meaningful API documentation

## Installation

### Prerequisites

The installation process assumes that you are running on macOS with [homebrew](http://brew.sh/) installed. For other systems (Linux, etc),
please adhere to their best practices.

### Project Setup

```sh
# Install system dependencies via Homebrew
$ brew install mysql
$ brew install ruby-build rbenv rbenv-readline rbenv-ctags
$ rbenv install `cat .ruby-version`

# Install the local ruby version and do the setup
$ bin/bootstrap

# start the project
$ bin/foreman start
```

### Git Hooks (powered by [`overcommit`](https://github.com/brigade/overcommit))

In case you bootstrap the project via `bin/setup`, you can skip this. Otherwise, you have the run the following command after cloning this repository to activate the Git Hooks.

There is also a custom commit hook, called `commit-msg`. This will aid the developer with the commit message format. When working on a feature branch (e.g. `feature/ABC-870-something-awesome`), this hook will add the ticket ID before the actual commit message.

```sh
$ bundle exec overcommit --install

# We are using a custom pre-commit hook for overcommit: It has to be "signed"
# before overcommit executes it...
$ bundle exec overcommit --sign commit-msg
```

This project uses two hooks:

1. `pre-push` -- it runs `rspec` before you push. Your push is rejected if one or more tests fail. Please fix all failing tests and try again.
2. `pre-commit` -- it runs `rubocop` to lint and style-check the entire codebase. Your commit is rejected if `rubocop` detected any offenses. Please fix all offenses and try again.


## Development

This project follows the [gitflow](https://github.com/nvie/gitflow) branching model. Also, we broadly follow the [Github Flow](https://guides.github.com/introduction/flow/) with regard to pull-requests and code reviews.

```sh
$ brew install git-flow
$ git flow init -d
```

### .env (poweredby [`dotenv`](https://github.com/bkeepers/dotenv))

The project uses `.env`-files for configuration. There is the hierarchy on how they get loded:

```ruby
# taken from https://github.com/bkeepers/dotenv/blob/master/lib/dotenv/rails.rb

Dotenv.load(
  root.join(".env.local"),
  root.join(".env.#{Rails.env}"),
  root.join(".env")
)
```

As a rule:
* The `.env`-file MUST have every basic configuration defined (this is your starting point when wirking with the repository)
* The `.env.#{Rails.env}`-files SHALL ONLY have environment specific overrides
* The `.env.local` may have any configuration needed to run locally
