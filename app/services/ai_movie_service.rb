# app/services/ai_movie_service.rb
require 'net/http'
require 'json'
require 'timeout'

class AiMovieService
  GEMINI_MODEL = "gemini-2.0-flash"
  API_URL = "https://generativelanguage.googleapis.com/v1/models/#{GEMINI_MODEL}:generateContent"
  TIMEOUT_SECONDS = 15

  def initialize
    @api_key = ENV['GEMINI_API_KEY']
    raise "GEMINI_API_KEY não está definido" if @api_key.blank?
  end

  def fetch_movie_information(title)
    return { error: "Título não pode estar vazio" } if title.blank?

    prompt = <<~PROMPT
      Você deve retornar **APENAS** um JSON válido.  
      NUNCA inclua texto adicional, comentários ou marcações (markdown).  
      Preencha os campos abaixo sobre o filme "#{title}":

      {
        "title": "",
        "synopsis": "",
        "year": "",
        "director": "",
        "duration": ""
      }

      Se não souber algum dado, escreva "Desconhecido".  
      Se não conseguir identificar o filme, retorne todos os campos como "Desconhecido".
    PROMPT

    begin
      response_body = nil

      Timeout.timeout(TIMEOUT_SECONDS) do
        uri = URI("#{API_URL}?key=#{@api_key}")
        req = Net::HTTP::Post.new(uri, { "Content-Type" => "application/json" })
        req.body = {
        contents: [
            {
                parts: [
                    { text: prompt }
                ]
            }
        ],
        generation_config: {
            temperature: 0.2,
            top_p: 1,
            top_k: 1,
            max_output_tokens: 500
        }
        }.to_json




        res = Net::HTTP.start(uri.host, uri.port, use_ssl: true) do |http|
          http.request(req)
        end

        response_body = res.body
      end

      Rails.logger.info "Gemini FULL BODY: #{response_body.inspect}"

      body = JSON.parse(response_body)

      candidate = body.dig("candidates", 0)
      Rails.logger.info "Gemini candidate: #{candidate.inspect}"

      raw_content = candidate.dig("content", "parts", 0, "text").to_s
      Rails.logger.info "Gemini raw_content: #{raw_content.inspect}"

      # remover eventuais blocos de código ou markdown
      clean_content = raw_content.gsub(/```json/i, "").gsub(/```/, "").strip
      Rails.logger.info "Gemini clean_content: #{clean_content.inspect}"

      # Se quiser ver o que está chegando mesmo vazio, comente a linha abaixo:
      return { error: "Resposta vazia da IA" } if clean_content.blank?

      parsed = JSON.parse(clean_content)
      Rails.logger.info "Parsed JSON: #{parsed.inspect}"

      parsed

    rescue Timeout::Error => e
      Rails.logger.error "AI Service Timeout: #{e.message}"
      { error: "Tempo esgotado na comunicação com a IA" }
    rescue JSON::ParserError => e
      Rails.logger.error "JSON Parse Error: #{e.message} – clean_content=#{clean_content.inspect}"
      { error: "Falha ao interpretar a resposta da IA" }
    rescue => e
      Rails.logger.error "AI Service Error: #{e.message}"
      { error: "Erro na comunicação com a IA: #{e.message}" }
    end
  end
end
