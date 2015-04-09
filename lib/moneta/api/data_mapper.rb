module Moneta
  module Api
    module DataMapper
      def self.included(base)
        base.extend ClassMethods

        base.class_eval do
          def fill(data)
            properties.each do |property, type|
              value = data[ property ]
              if value
                property_value = type.nil? ? value : build_complex_value(type, value)
                instance_variable_set("@#{ property }", property_value)
              end
            end

            self
          end

          def to_hash
            properties.each_with_object({}) do |(property, _), hash|
              value = send(property)
              unless value.nil?
                hash[ classify_with_lower(property.to_s) ] = to_hash_complex_value(value)
              end
            end
          end

          def classify_with_lower(str)
            str = classify(str)
            str[0] = str[0].downcase

            str
          end

          def classify(str)
            str.split('_').map(&:capitalize).join
          end

          private

          def build_complex_value(type, value)
            value.kind_of?(Array) ?
              value.map { |v| type.build(v) } :
              type.build(value)
          end

          def to_hash_complex_value(value)
            if value.kind_of?(Array)
              value.map(&:to_hash)
            elsif value.respond_to?(:to_hash)
              value.to_hash
            else
              value
            end
          end
        end
      end

      module ClassMethods
        def property(name, base_type=nil)
          attr_accessor(name)

          # Сохраняем свойста и перезаписываем instance метод
          current_properties = instance_variable_get('@properties') || {}
          properties = instance_variable_set('@properties', current_properties.merge(name => base_type))

          send(:define_method, :properties) { properties }
        end

        def build(data)
          self.new.tap { |object| object.fill(data) }
        end
      end
    end
  end
end