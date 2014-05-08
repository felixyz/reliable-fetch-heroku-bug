require 'sidekiq'
require 'redis/namespace'

Sidekiq.configure_server do |config|
  require 'sidekiq/pro/reliable_fetch'
  config.redis = { size: 10, namespace: 'sidekiq-hk-bug' }
end

class DutifulWorker
  include Sidekiq::Worker

  sidekiq_retries_exhausted do |msg|
    puts "<DutifulWorker> Exhausted retries for '#{keyphrase}' (#{tries} tries)."
  end

  def perform(a_number)
    puts "**DEBUG** jid:#{self.jid}\tnumber:#{a_number}\t- START in dyno #{ENV['DYNO']}"
    sleep rand(15..20)
    puts "**DEBUG** jid:#{self.jid}\tnumber:#{a_number}\t- DONE in dyno #{ENV['DYNO']}"
  end
end
