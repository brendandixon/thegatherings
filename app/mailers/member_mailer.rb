class MemberMailer < ApplicationMailer

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.member_mailer.answer_membership_request.subject
  #
  def answer_membership_request(responder, membership_request, answer)
    return unless responder.present? && membership_request.present? && membership_request.answered?
    
    @responder = responder
    @membership_request = membership_request
    @answer = answer

    mail to: @membership_request.member.email, from: @responder.email, subject: I18n.t(:subject, scope:[:mailers, :answer_membership_request], name: @membership_request.gathering.name)
  end
end
