CodeGenerator.configure do |code|
  code.length         = 6               # length of the tokens to be generated. (default: 10)
  code.use_chars      = :alpha_numeric        # type of token to be generated. (default: :alpha_numeric)
  code.repeat_chars   = false           # characters should be repeated. (default: true)
end