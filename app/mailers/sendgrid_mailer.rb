require 'sendgrid-ruby'

class SendgridMailer
  include SendGrid

  def self.send_email(to:, subject:, html_content:)
    from = Email.new(email: "paulohab2004@gmail.com")
    to = Email.new(email: to)

    content = Content.new(type: 'text/html', value: html_content)
    mail = Mail.new(from, subject, to, content)

    sg = SendGrid::API.new(api_key: ENV['SENDGRID_API_KEY'])
    response = sg.client.mail._('send').post(request_body: mail.to_json)

    return response.status_code.to_i < 300
  rescue => e
    Rails.logger.error "SendGrid API Error: #{e.message}"
    false
  end
end
