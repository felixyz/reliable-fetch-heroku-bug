require 'sidekiq'
require './redis_connection'

Sidekiq.configure_server do |config|
  require 'sidekiq/pro/reliable_fetch'
  config.redis = { size: 10, namespace: 'sidekiq-hk-bug' }
end

class DutifulWorker
  include Sidekiq::Worker

  sidekiq_retries_exhausted do |msg|
    puts "<DutifulWorker> Exhausted retries for '#{keyphrase}' (#{tries} tries)."
  end

  def debug_string_template
    "**DEBUG** jid:#{self.jid}\tuuid:#{@uuid}\tdyno: #{ENV['DYNO']}\t- "
  end

  def get_old_val
    old_val = (redis.get(@uuid) || '0').to_i
    puts debug_string_template + "!!! --This job has already been executed-- !!!" if old_val > 0
    old_val
  end

  def perform(uuid)
    @uuid = uuid
    puts debug_string_template + "START"

    val = get_old_val
    sleep rand(10..20)
    #One more chance to get a log line, and mimics the precaution an actual app must make to a race condition
    val = get_old_val if val == 0

    redis.set @uuid, val + 1
    puts debug_string_template + "DONE"
  end

  def redis
    @@redis_connection ||= RedisConnection.new.redis('sidekiq-hk-bug-results')
  end
end
