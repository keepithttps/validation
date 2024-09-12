# Написать модуль Validation, который:

# Содержит метод класса validate. Этот метод принимает в качестве параметров имя проверяемого атрибута,
# а также тип валидации и при необходимости дополнительные параметры.Возможные типы валидаций:

#    - presence - требует, чтобы значение атрибута было не nil и не пустой строкой. Пример использования:  
  
# validate :name, :presence
 
#   - format (при этом отдельным параметром задается регулярное выражение для формата).
# Треубет соответствия значения атрибута заданному регулярному выражению. Пример:  

# validate :number, :format, /A-Z{0,3}/

#  - type (третий параметр - класс атрибута). Требует соответствия значения атрибута заданному классу. Пример:  
 
# validate :station, :type, RailwayStation

#      Содержит инстанс-метод validate!, который запускает все проверки (валидации), указанные в классе через метод класса validate. 
# В случае ошибки валидации выбрасывает исключение с сообщением о том, какая именно валидация не прошла
#     Содержит инстанс-метод valid? который возвращает true, если все проверки валидации прошли успешно и false, если есть ошибки валидации.
#     К любому атрибуту можно применить несколько разных валидаторов, например

#     validate :name, :presence
#     validate :name, :format, /A-Z/
#     validate :name, :type, String

#      Все указанные валидаторы должны применяться к атрибуту
#     Допустимо, что модуль не будет работать с наследниками.


# Подключить эти модули в свои классы и продемонстрировать их использование. Валидации заменить на методы из модуля Validation. 

module Validation
      
  def self.included(base)
    base.extend(ClassMethods)
  end

  module ClassMethods
    def validate(attribute, type, *args)
      @validators ||= []
      @validators << { attribute: attribute, type: type, args: args }
    end
  end

  def validate!
    self.class.instance_variable_get(:@validators).each do |validator|
      value = send(validator[:attribute])
      case validator[:type]
      when :presence
        raise "#{validator[:attribute]} must be present" if value.nil? || value.to_s.empty?
      when :format
        raise "#{validator[:attribute]} must match format #{validator[:args][0]}" unless value.to_s.match?(validator[:args][0])
      when :type
        raise "#{validator[:attribute]} must be a #{validator[:args][0]}" unless value.is_a?(validator[:args][0])
      end
    end
  end

  def valid?
    validate!
    true
  rescue
    false
  end
end


class User
  include Validation

  attr_accessor :name, :number, :station

  validate :name, :presence
  validate :name, :format, /^[A-Z]/
  validate :number, :format, /^[A-Z]{0,3}$/
  validate :station, :type, String

  def initialize(name, number, station)
    @name = name
    @number = number
    @station = station
  end
end

# Пример использования
user1 = User.new("John", "ABC", "Central Station")
puts user1.valid?  # true

user2 = User.new("", "1234", "Central Station")
puts user2.valid?  # false

begin
  user2.validate!
rescue => e
  puts e.message  # "name must be present"
end

user3 = User.new("john", "ABCD", 123)
puts user3.valid?  # false

begin
  user3.validate!
rescue => e
  puts e.message  # "name must match format (?-mix:^[A-Z])"
end

