require "mongoid/enum_attribute/configuration"
require "mongoid/enum_attribute/validators/multiple_validator"
require "mongoid/enum_attribute/version"

module Mongoid
  module EnumAttribute
    extend ActiveSupport::Concern

    module ClassMethods
      def enum(name, values, options = {})
        field_name = name.to_s
        options = default_options(values).merge(options)

        set_values_constant(name, values)
        field_name = create_field(field_name, options)

        create_validations(field_name, values, options)
        define_value_scopes_and_accessors(name, field_name, values, options)
        define_field_accessor(name, field_name, options)
      end

      private

      def default_options(values)
        { multiple: false,
          default: values.first,
          required: true,
          validate: true,
          prefix: Mongoid::EnumAttribute.configuration.prefix,
          suffix: Mongoid::EnumAttribute.configuration.suffix,
          field_name_prefix: Mongoid::EnumAttribute.configuration.field_name_prefix
        }
      end

      def set_values_constant(name, values)
        const_name = name.to_s.upcase
        const_set(const_name, values)
      end

      def create_field(field_name, options)
        type = options[:multiple] && Array || String
        field_name = "#{options[:field_name_prefix]}#{field_name}"
        field field_name, type: type, default: options[:default]
        field_name
      end

      def create_validations(field_name, values, options)
        if options[:multiple] && options[:validate]
          validates(
            field_name,
            "mongoid/enum_attribute/validators/multiple".to_sym => {
              in: values.map(&:to_sym),
              allow_nil: !options[:required]
            }
          )
        elsif options[:validate]
          validates(
            field_name,
            inclusion: { in: values.map(&:to_s) },
            allow_nil: !options[:required]
          )
        end
      end

      def define_value_scopes_and_accessors(name, field_name, values, options)
        values.each do |value|
          scope(value, -> { where(field_name => value) })

          accessor_name = value
          accessor_name = apply_prefix(accessor_name, name, value, options[:prefix]) if options[:prefix]
          accessor_name = apply_suffix(accessor_name, name, value, options[:suffix]) if options[:suffix]

          if options[:multiple]
            define_array_accessor(accessor_name, field_name, value)
          else
            define_string_accessor(accessor_name, field_name, value)
          end
        end
      end

      def apply_prefix(accessor_name, name, value, prefix)
        return "#{prefix}_#{value}" if prefix.is_a?(String)
        "#{name}_#{value}"
      end

      def apply_suffix(accessor_name, name, value, suffix)
        return "#{value}_#{suffix}" if suffix.is_a?(String)
        "#{value}_#{name}"
      end

      def define_field_accessor(name, field_name, options)
        if options[:multiple]
          define_array_field_accessor(name, field_name)
        else
          define_string_field_accessor(name, field_name)
        end
      end

      def define_array_field_accessor(name, field_name)
        class_eval "def #{name}=(vals) self.write_attribute(:#{field_name}, Array(vals).compact.map(&:to_sym)) end"
        class_eval "
          def #{name}()
            return self.send(:#{field_name}).map{ |i| i.try(:to_sym) } if name != field_name
            field_name.map{ |i| i.try(:to_sym) }
          end"
      end

      def define_string_field_accessor(name, field_name)
        class_eval "def #{name}=(val) self.write_attribute(:#{field_name}, val && val.to_sym || nil) end"
        class_eval "
          def #{name}()
            return self.send(:#{field_name}).to_sym if name != field_name
            field_name.to_sym
          end"
      end

      def define_array_accessor(accessor_name, field_name, value)
        class_eval "def #{accessor_name}?() self.#{field_name}.include?(:#{value}) end"
        class_eval "def #{accessor_name}!() update_attributes! :#{field_name} => (self.#{field_name} || []) + [:#{value}] end"
      end

      def define_string_accessor(accessor_name, field_name, value)
        class_eval "def #{accessor_name}?() self.#{field_name}.to_sym == :#{value} end"
        class_eval "def #{accessor_name}!() update_attributes! :#{field_name} => :#{value} end"
      end
    end
  end
end
