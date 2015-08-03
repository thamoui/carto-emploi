require 'open-uri'

namespace :dokku do

  desc "Relance l'app sur dokku s'il y a une erreur 500"
  task :restart_ango_app  do
    io = open('http://ango.simplon.co')
    io.status #=> ["200", "OK"]
    puts "status de http://ango.simplon.co : #{io.status[0]}"
    if io.status[0].match('5') != nil   #si le code commence par 5
      puts 'lance la commande dokku restart ango'
      puts "status : #{io.status[0]}"
      sh "dokku ps:restart ango"
    end

  end
end
