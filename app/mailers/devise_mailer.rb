class DeviseMailer < Devise::Mailer
  default from: 'paulohab2004@gmail.com'
  layout 'mailer'

  def reset_password_instructions(record, token, opts = {})
    Rails.logger.info "=== DEVISE MAILER CALLED ==="
    Rails.logger.info "Record: #{record.email}"
    Rails.logger.info "Token: #{token}"
    
    opts[:subject] = "Redefinir sua senha"

    @resource = record
    @token = token

    begin
      html_content = render_to_string(
        template: 'devise/mailer/reset_password_instructions',
        layout: false
      )
      
      Rails.logger.info "HTML content rendered successfully, length: #{html_content.length}"
      
      success = SendgridMailer.send_email(
        to: record.email,
        subject: opts[:subject],
        html_content: html_content
      )
      
      Rails.logger.info "SendGrid response: #{success ? 'SUCCESS' : 'FAILED'}"
      
    rescue => e
      Rails.logger.error "Error in DeviseMailer: #{e.message}"
      Rails.logger.error e.backtrace.join("\n")
    end
  end
end