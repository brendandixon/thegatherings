# Preview all emails at http://localhost:3000/rails/mailers/member_mailer
class MemberMailerPreview < ActionMailer::Preview

  # Preview this email at http://localhost:3000/rails/mailers/member_mailer/answer_membership_request
  def answer_membership_request
    MemberMailer.answer_membership_request(Member.first, MembershipRequest.first, "Yo! This works!")
  end

end
