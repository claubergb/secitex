class AvaliacaoMailer < ApplicationMailer

  def avaliacao_atribuida(avaliador, trabalho)
    @avaliador = avaliador
    @trabalho = trabalho

    if Rails.env.development?
      @download = "http://localhost:3000" + @trabalho.download
    else
      @download = "http://submissaosecitex.ifrn.edu.br" + @trabalho.download
    end

    mail to: avaliador.email, subject: '[IV SECITEX] Avaliação do trabalho #'+trabalho.id.to_s+' atribuída para você'
  end

  def avaliacao_removida(avaliador, trabalho)
    @avaliador = avaliador
    @trabalho = trabalho

    mail to: avaliador.email, subject: '[IV SECITEX] Avaliação removida de você'
  end

  def trabalho_aprovado(trabalho)
    @trabalho = trabalho

    mail to: trabalho.participante.email, subject: '[IV SECITEX] Seu trabalho foi selecionado!'
  end

  def trabalho_reprovado(trabalho)
    @trabalho = trabalho

    mail to: trabalho.participante.email, subject: '[IV SECITEX] Avaliação do seu trabalho'
  end

  def trabalho_final(trabalho)
    @trabalho = trabalho

    mail to: trabalho.participante.email, subject: '[IV SECITEX] Envio da versão final do trabalho #'+trabalho.id.to_s+'!'
  end

  def minicurso_aprovado(minicurso)
    @minicurso = minicurso

    mail to: minicurso.participante.email, subject: '[IV SECITEX] Sua proposta de minicurso/oficina foi aceita!'
  end

  def minicurso_reprovado(minicurso)
    @minicurso = minicurso

    mail to: minicurso.participante.email, subject: '[IV SECITEX] Avaliação da sua proposta de minicurso'
  end

  def equipe_validada(equipe)
    @equipe = equipe

    mail to: equipe.participante.email, subject: '[IV SECITEX] Sua equipe para a olimpíada de robótica foi validada!'
  end

end
