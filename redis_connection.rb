require 'redis'
require 'redis/namespace'

class RedisConnection
  def redis(namespace)
    @redis ||= redis_connection(namespace)
  end

  def redis_connection(namespace)
    client = Redis.new(url:ENV['REDIS_URL'])
    Redis::Namespace.new(namespace, redis: client)
  end
end