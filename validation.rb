module Validation
      NUMBER_FORMAT = /^\d{0,3}$/i   # формат по типу "123"

  def validate(name, atribute)
    if name == "string"
      raise "atribute can't be nil" if atribute.nil?
      raise "atribute can't be not a string" if atribute == ''
    elsif name == "number"
      raise "atribute should be at least 3 symbols" if atribute == NUMBER_FORMAT
    elsif name == "wagon"
      raise "atribute can't be not a passenger" if atribute != "passenger"
    end
    true
  end
end

class Vali
  extend Validation

  def validate?(name, atribute)
    validate(name, atribute)
  rescue
    false
  end

end
