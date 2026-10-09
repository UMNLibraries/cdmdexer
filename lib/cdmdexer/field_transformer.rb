require 'hash_at_path'

module CDMDEXER
  class FieldTransformer
    attr_reader :field_value, :field_mapping, :formatter_klass
    def initialize(field_mapping: FieldMapping.new,
                   record: {},
                   formatter_klass: FieldFormatter)
      @field_mapping   = field_mapping
      @field_value     = compact(record.at_path(origin_path))
      @formatter_klass = formatter_klass
    end

    def reduce
      (blank?(value)) ? {} : { "#{dest_path}" => value }
    end

    def value
      @value ||= (!blank?(field_value)) ? transform_field : nil
    end

    private

    def origin_path
      @field_mapping.origin_path
    end

    def dest_path
      @field_mapping.dest_path
    end

    def formatters
      @field_mapping.formatters
    end

    def compact(record)
      (record.respond_to?(:compact)) ? record.compact : record
    end

    # File activesupport/lib/active_support/core_ext/object/blank.rb, line 14
    def blank?(val)
      val.respond_to?(:empty?) ? !!val.empty? : !val
    end

    def transform_field
      formatter_klass.new(value: field_value, formatters: formatters).format!
    rescue StandardError => e
      raise "Mapping: #{field_mapping.config} Error:#{e.message}"
    end
  end
end