class JwtService
  # Mã này nằm trong file config/master.key
  SECRET_KEY = Rails.application.secret_key_base
  ALGORITHM = "HS256" # Encoding algorithm for JWT by HS256

  def self.encode(payload, exp = 24.hours.from_now)
    payload[:exp] = exp.to_i
    JWT.encode(payload, SECRET_KEY, ALGORITHM)
  end

  def self.decode(token)
    decoded = JWT.decode(token, SECRET_KEY, true, { algorithm: ALGORITHM })
    #  => [
    #       {"data"=>"test"}, # payload
    #       {"alg"=>"none"} # header
    #     ]
    # decoded[0] là payload
    # .with_indifferent_access cho phép truy cập key bằng cả :symbol hoặc "string".
    decoded[0].with_indifferent_access
  rescue JWT::DecodeError
    nil
  end
end
