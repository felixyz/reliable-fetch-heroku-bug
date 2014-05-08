require './dutiful_worker'
require 'sinatra'

get '/' do
<<-HTML
  <script type="text/javascript">
    window.triggerJob = function() {
      var httpRequest = new XMLHttpRequest();
      httpRequest.open('GET', '/addJob');
      httpRequest.send();
    }
  </script>
  <h2>This app illustrates a bug that causes Sidekiq jobs to be executed multiple times on Heroku</h2>
  <button type="button" onclick="triggerJob();">Click to add a job</button>
HTML
end

get '/addJob' do
  DutifulWorker.perform_async(5)
end