# encoding: utf-8

class Participante < ApplicationRecord
  include Selectable
  include GoogleDriveAPI

  belongs_to :tipo_participante
  belongs_to :cidade
  belongs_to :pais
  belongs_to :campus
  has_one :usuario, as: :autenticavel, dependent: :destroy
  has_many :trabalhos, dependent: :destroy
  has_many :pagamentos, dependent: :destroy
  has_many :minicursos_propostos, dependent: :destroy, class_name: 'Minicurso'
  has_many :inscricoes
  has_many :minicursos, through: :inscricoes
  has_many :equipes

  has_attached_file :nota_empenho, {
    path: "public/system/:class/:attachment/:id/:style/:filename",
    url: "system/:class/:attachment/:id/:style/:filename"
  }

  #validates :pais_id, :documento, :tipo_participante_id, :instituicao, presence: true
  # linha abaixo
  validates :tipo_participante_id, :instituicao, :campus_id, presence: true
  validates :cidade_id, presence: true, if: :brasileiro?
  #validates :documento, cpf: true, if: :brasileiro?
  #validates :documento, uniqueness: true, on: :create
  validates :necessidades_especiais, presence: true, if: :possui_necessidades_especiais?
  validates_attachment :nota_empenho, presence: true, content_type: { content_type: "application/pdf" }, if: :pagamento_por_empenho?
  validates :motivo_isencao, presence: true, if: :isento?

  accepts_nested_attributes_for :usuario

  before_create :atribuir_perfil
  after_create :isencao_automatica

  ISENCAO = {
    :rejeitado => 0,
    :solicitado => 1,
    :aprovado => 2
  }

  def download_nota_empenho
    if Rails.env.production?
      return "/semead/#{self.nota_empenho.url}"
    else
      return "/#{self.nota_empenho.url}"
    end
  end

  def possui_necessidades_especiais?
    self.possui_necessidades_especiais.present?
  end

  def email
    self.usuario.email
  end

  def nome
    self.usuario.nome
  end

  def brasileiro?
    self.pais.brasil?
  end
  
  def ifrn?
    self.instituicao == 'IFRN'
  end

  def atribuir_perfil
    self.usuario.perfil = Perfil.find_by_slug('participante')
  end

  def tipo?(tipo)
    return self.tipo_participante.slug == tipo
  end

  def pagamento_por_empenho?
    return self.pagamento_por_empenho
  end

  def aprovar_nota_empenho
    self.update_attribute(:pago, true)
    ParticipanteMailer.nota_empenho_aprovada(self).deliver_now
  end

  def pago?
    return self.pago
  end

  def tipo_documento
    if brasileiro?
      "CPF"
    else
      "passaporte"
    end
  end

  def isento?
    self.isento == ISENCAO[:aprovado]
  end

  def avaliar_isencao(avaliacao)
    self.update_attribute(:isento, avaliacao)
    if self.isencao_aprovada?
      ParticipanteMailer.isencao_aprovada(self).deliver_now
    else
      ParticipanteMailer.isencao_rejeitada(self).deliver_now
    end
  end

  def isencao_automatica
    if Isento.verificar(self.documento)
      self.avaliar_isencao(ISENCAO[:aprovado])
    end
  end

  def credenciar
    self.update_attribute(:credenciado, true)
  end

  def solicitou_isencao?
    self.isento == ISENCAO[:solicitado]
  end

  def isencao_aprovada?
    self.isento == ISENCAO[:aprovado]
  end

  def confirmado?
    self.pago? or self.isento? or true
  end

  def credenciado?
    self.credenciado
  end

  def respondeu_questionario?
    #if self.respondeu_questionario
      return true
    #else
    #  if questionario_respondido_por?(self.documento)
    #    self.update_attribute(:respondeu_questionario, true)
    #    return true
    #  end
    #  return false
    #end
  end

  def self.select2(params)
    participantes = Array.new
    self.joins(:usuario).where("nome LIKE '%#{params}%'").each do |participante|
      participantes << { id: participante.id, nome: participante.nome }
    end
    return participantes
  end

  def self.confirmados
    self.joins(:usuario).where("pago = true OR isento = 2 OR 1=1")
  end

  def self.credenciados
    self.joins(:usuario).where("credenciado = true")
  end

  def self.isentos
    self.joins(:usuario).where(isento: ISENCAO[:aprovado])
  end

  def self.pagantes
    self.joins(:usuario).where(pago: true)
  end

  def icons_listagem_participante
  participante = self
    html = ""
    if participante.possui_necessidades_especiais?
      html += fa_icon('wheelchair', title: 'Possui necessidades especiais')
      html += "&nbsp".html_safe
    end
=begin
    if participante.pagamento_por_empenho?
      html += fa_icon('file-text-o', title: 'Pagamento da taxa de inscrição por empenho')
      html += "&nbsp".html_safe
    elsif participante.isento? or participante.solicitou_isencao? or participante.isencao_aprovada?
      html += fa_icon('credit-card', classes: 'fa-disabled', title: 'Solicitou isenção/isento')
      html += "&nbsp".html_safe
    else
      html += fa_icon('credit-card', title: 'Pagamento da taxa de inscrição tradicional')
      html += "&nbsp".html_safe
    end
    if participante.confirmado?
      html += fa_icon('thumbs-up', title: 'Confirmado')
      html += "&nbsp".html_safe
    else
      html += fa_icon('thumbs-up', classes: 'fa-disabled', title: 'Não confirmado')
      html += "&nbsp".html_safe
    end
=end
    if participante.credenciado?
      html += fa_icon('address-card-o', classes: 'alert-success', title: 'Credenciado')
      html += "&nbsp".html_safe
    else
      html += fa_icon('address-card-o', classes: 'fa-disabled', title: 'Não credenciado')
      html += "&nbsp".html_safe
    end
    return html
  end

  def fa_icon(icon, title: '', classes: '')
    "<i class='fa fa-#{icon} #{classes}' title='#{title}' aria-hidden='true'></i>".html_safe
  end
end
