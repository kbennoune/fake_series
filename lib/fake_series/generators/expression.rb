require "fake_series/summable_value_map"

module FakeSeries::Generators
  class Expression
    attr_reader :terms

    def initialize(*terms)
      @terms = terms.map { |term| [term.object_id, term] }.to_h
    end

    def hidden_variables(prev, duration)
      terms.map do |k, term|
        p = FakeSeries::Element.new(prev.time, term, prev.hidden_variables[k] || {}, value: prev.value[k])
        [k, term.hidden_variables(p, duration)]
      end.to_h
    end

    def value(prev, elt)
      value = terms.map do |k, term|
        p = FakeSeries::Element.new(prev.time, term, prev.hidden_variables[k], value: prev.value[k])
        e = element_for(elt, k, term)
        [k, term.value(p, e)]
      end.to_h

      value.extend(SummableValueMap)
    end

    private

    def element_for(elt, k, generator)
      value = (elt.value.respond_to?(:[]) && elt.value[k]) || {}
      FakeSeries::Element.new(
        elt.time, generator, elt.hidden_variables[k],
        value:
      )
    end
  end
end
