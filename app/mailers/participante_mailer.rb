class ParticipanteMailer < ApplicationMailer
  
  def inscricao_realizada(participante)
    @participante = participante
    @url_pagamento = url_pagamento(participante)
    mail(to: participante.email, subject: '[IV SECITEX] Inscrição realizada com sucesso!')
  end

  def trabalho_submetido(participante, trabalho)
    @participante = participante
    @trabalho = trabalho
    mail(to: participante.email, subject: '[IV SECITEX] Trabalho submetido com sucesso!')
  end

  def equipe_inscrita(participante, equipe)
    @participante = participante
    @equipe = equipe
    mail(to: participante.email, subject: '[IV SECITEX] Equipe inscrita com sucesso!')
  end

  def minicurso_proposto(participante, minicurso)
    @participante = participante
    @minicurso = minicurso
    mail(to: participante.email, subject: '[IV SECITEX] Minicurso proposto com sucesso!')
  end

  def isencao_aprovada(participante)
    @participante = participante
    mail(to: participante.email, subject: '[IV SECITEX] Isenção da taxa de inscrição aprovada!')
  end

  def isencao_rejeitada(participante)
    @participante = participante
    mail(to: participante.email, subject: '[IV SECITEX] Isenção da taxa de inscrição rejeitada')
  end

  def nota_empenho_aprovada(participante)
    @participante = participante
    mail(to: participante.email, subject: '[IV SECITEX] Nota da empenho aprovada')
  end

end
