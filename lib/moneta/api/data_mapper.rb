module Moneta
  module Api
    module DataMapper
      def self.included(base)
        base.extend ClassMethods

        base.class_eval do
          include Support

          def load_from(data)
            properties.each { |attr| instance_variable_set("@#{ attr }", data[ attr ]) }
          end

          def to_h
            properties.each_with_object({}) do |key, hash|
              hash[ capitalize_with_lower(key.to_s) ] = send(key)
            end
          end
        end
      end

      module ClassMethods
        def property(name)
          attr_accessor(name)

          # Сохраняем свойста и перезаписываем instance метод
          current_properties = instance_variable_get('@properties') || []
          properties = instance_variable_set('@properties', current_properties + [ name ])

          send(:define_method, :properties) { properties }
        end
      end
    end
  end
end
