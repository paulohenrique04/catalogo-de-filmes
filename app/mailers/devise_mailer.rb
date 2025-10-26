class DeviseMailer < Devise::Mailer
  def reset_password_instructions(record, token, opts = {})
    opts[:subject] = "Redefinir sua senha"

    @resource = record
    @token = token

    html_content = render_to_string(
      template: 'devise/mailer/reset_password_instructions'
    )

    SendgridMailer.send_email(
      to: record.email,
      subject: opts[:subject],
      html_content: html_content
    )
  end
end
