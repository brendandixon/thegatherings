class MemberMailer < ApplicationMailer

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.member_mailer.answer_request.subject
  #
  def answer_request(responder, request, answer)
    return unless responder.present? && request.present? && request.answered?
    
    @responder = responder
    @request = request
    @answer = answer

    mail to: @request.member.email, from: @responder.email, subject: I18n.t(:subject, scope:[:mailers, :answer_request], name: @request.gathering.name)
  end
end
