class SendgridMailer
  include SendGrid

  def self.send_email(to:, subject:, html_content:)
    Rails.logger.info "=== SENDGRID MAILER CALLED ==="
    Rails.logger.info "To: #{to}"
    Rails.logger.info "Subject: #{subject}"
    
    from = Email.new(email: "paulohab2004@gmail.com")
    to_email = Email.new(email: to)
    content = Content.new(type: 'text/html', value: html_content)
    
    mail = Mail.new(from, subject, to_email, content)

    sg = SendGrid::API.new(api_key: ENV['SENDGRID_API_KEY'])
    
    Rails.logger.info "Sending to SendGrid API..."
    
    begin
      response = sg.client.mail._('send').post(request_body: mail.to_json)
      
      Rails.logger.info "SendGrid API Response: #{response.status_code}"
      Rails.logger.info "SendGrid API Headers: #{response.headers}"
      
      success = response.status_code.to_i < 300
      Rails.logger.info "SendGrid result: #{success ? 'SUCCESS' : 'FAILED'}"
      
      return success
    rescue => e
      Rails.logger.error "SendGrid API Error: #{e.message}"
      Rails.logger.error e.backtrace.join("\n")
      false
    end
  end
end