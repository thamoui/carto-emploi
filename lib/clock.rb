# require File.expand_path('../../config/boot',        __FILE__)
require File.expand_path('../../config/environment', __FILE__)

require 'clockwork'
require 'sidekiq'

Dir["lib/jobs/*"].each {|f| load f }

# INTERESSANT require 'clockwork/database_events' >> des events pour les db !!#https://github.com/tomykaira/clockwork


module Clockwork

  every(1.day, 'parse_url.job', :at => '00:00'){
    ParseUrl.perform_async
  }

  every 1.day, 'my_worker.late_night_work', :at => '4:30 am' do
    MyWorker.late_night_work
  end

  every 1.hour do
    HourlyWorker.perform_async
  end

end

#ParseUrl est défini dans le dossier WORKERS


#aller voir cet ex https://github.com/pzula/greenhouse-watchman/tree/f3f216dbc11600d2d72a5a480bc8d27261a2219c
# avec son tuto :http://www.codeadventurer.com/2014/06/23/build-your-own-api-data-vacuum-with-sinatra

#https://github.com/tomykaira/clockwork

# load all jobs from app/jobs directory
# no need to load rails env, we only care about classes
# (#perform method is not invoked in this process)
