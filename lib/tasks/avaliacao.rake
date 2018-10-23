namespace :avaliacao do

  desc "Comunicar autores sobre a aprovação e reprovação de trabalhos"
  task notificar_trabalhos: :environment do
    print "Enviando mensagem para os autores de trabalhos... "
    Trabalho.all.each do |trabalho|
      if trabalho.aprovado?
        AvaliacaoMailer.trabalho_aprovado(trabalho).deliver_now
      else
        AvaliacaoMailer.trabalho_reprovado(trabalho).deliver_now
      end
    end
    puts "Concluído!"
  end

  desc "Notificar proponentes de minicursos sobre aprovação e reprovação de propostas"
  task notificar_minicursos: :environment do
    puts "Enviando mensagem para os proponentes de minicursos... "
    Minicurso.all.each_with_index do |minicurso,index|
      if minicurso.aprovado? and index >=10
        puts "Enviando email para "+minicurso.titulo
        AvaliacaoMailer.minicurso_aprovado(minicurso).deliver_now
        sleep(20)
      else
      #  AvaliacaoMailer.minicurso_reprovado(minicurso).deliver_now
      end
    end
    puts "Concluído!"
  end

  desc "Notificar proponentes de equipes sobre validação de propostas"
  task notificar_equipes: :environment do
    puts "Enviando mensagem para os proponentes de equipes... "
    Equipe.all.each_with_index do |equipe,index|
      if equipe.validada?
        puts index.to_s+" Enviando email para "+equipe.nome
        AvaliacaoMailer.equipe_validada(equipe).deliver_now
        sleep(20)
      else
      #  AvaliacaoMailer.minicurso_reprovado(minicurso).deliver_now
      end
    end
    puts "Concluído!"
  end

end
