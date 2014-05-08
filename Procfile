web: bundle exec rackup -s puma -p $PORT
sidekiq: sidekiq -i ${DYNO:-1} -c 10 -q default -r ./dutiful_worker.rb
