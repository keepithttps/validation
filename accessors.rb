# Написать модуль Acсessors, содержащий следующие методы, которые можно вызывать на уровне класса:

#   метод   
#   attr_accessor_with_history
#   Этот метод динамически создает геттеры и сеттеры для любого кол-ва атрибутов, при этом сеттер сохраняет все значения 
#   инстанс-переменной при изменении этого значения. 

#   Также в класс, в который подключается модуль должен добавляться инстанс-метод  
#     <имя_атрибута>_history
#   который возвращает массив всех значений данной переменной.

#     метод  
#     strong_attr_accessor
#  который принимает имя атрибута и его класс. При этом создается геттер и сеттер для одноименной инстанс-переменной, но сеттер проверяет тип 
# присваемоего значения. Если тип отличается от того, который указан вторым параметром, то выбрасывается исключение.
 # Если тип совпадает, то значение присваивается.


module Accessors

  def attr_accessor_with_history(*names)
    names.each do |name|
      sym_name = "@#{name}".to_sym
      define_method(name) { instance_variable_get(sym_name) }
      define_method("#{name}=".to_sym) { |value| instance_variable_set(sym_name, value) }
    end
  end

  def name_history(name)
    sym_name = "@#{name}_history".to_sym 
    self.class_variable_set(sym_name) 
    Bee.class_variables
  end

  def strong_attr_accessor(name, name_class)
    sym_name = "@#{name}".to_sym
    define_method(name) { instance_variable_get(sym_name) }
    define_method("#{name}=".to_sym) do |value|
      if value.class.to_s == name_class.capitalize
        instance_variable_set(sym_name, value)
      else
        puts "name class can't be #{value.class}"
      end
    end
  end
end

class Bee
  extend Accessors

  attr_accessor_with_history :bunbl_bee
  strong_attr_accessor('bunble_free', "string")

end
