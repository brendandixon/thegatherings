# Preview all emails at http://localhost:3000/rails/mailers/member_mailer
class MemberMailerPreview < ActionMailer::Preview

  # Preview this email at http://localhost:3000/rails/mailers/member_mailer/answer_request
  def answer_request
    MemberMailer.answer_request(Member.first, MembershipRequest.first, "Yo! This works!")
  end

end
