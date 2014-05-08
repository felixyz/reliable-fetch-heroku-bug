require 'sinatra'
require 'securerandom'
require './dutiful_worker'
require './redis_connection'

def redis
  $redis_connection ||= RedisConnection.new.redis('sidekiq-hk-bug-results')
end

get '/' do
body = <<-HTML
<html>
  <body>
    <script type="text/javascript">
      window.triggerJobs = function() {
        var httpRequest = new XMLHttpRequest();
        httpRequest.open('GET', '/addJob');
        httpRequest.send();
      }
    </script>
    <h2>This app illustrates a bug that causes Sidekiq jobs to be executed multiple times on Heroku</h2>
    <button type="button" onclick="triggerJobs();">Click to add 20 jobs</button>
    <h3>Duplicate jobs listed belows (refresh page)</h3>
  </body>
</html>
HTML
  keys = redis.keys '*'
  keys.each do |key|
    val = redis.get key
    if val.to_i > 1
      body << "<p>#{key} ==> #{val}</p>"
    end
  end
  body
end

get '/addJob' do
  20.times do
    DutifulWorker.perform_async(SecureRandom.uuid)
  end
  200
end