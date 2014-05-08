This app attempts to provide a minimal case for illustrating a bug in Sidekiq Pro, causing jobs to be picked up multiple times when using reliable fetch (on Heroku).

The Gemfile.lock is not present in the repo, because it contains a secret customer-specific URL for fetching the sidekiq-pro gem. If you want to run this app yourself, you need to a) be a Sidekiq Pro customer, b) place your private Sidekiq Pro gem URL (`http://<usr>:<pwd>@www.mikeperham.com/rubygems/`) in the `SIDEKIQ_PRO_GEM_SERVER` environment variable, c) run `bundle update`