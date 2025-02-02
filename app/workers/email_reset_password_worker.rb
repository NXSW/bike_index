class EmailResetPasswordWorker < ApplicationWorker
  sidekiq_options queue: "notify"

  def perform(user_id)
    user = User.find(user_id)
    raise "Missing password_reset_token token for user: #{user_id}" unless user.password_reset_token.present?
    CustomerMailer.password_reset_email(user).deliver_now
  end
end
