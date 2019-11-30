# frozen_string_literal: true

RSpec::Matchers.define :be_json_response_with_keys do |*expected_keys|
  match do |response|
    expected_keys = expected_keys.flatten.map(&:to_s)
    body = response.body
    if body.present?
      parsed = JSON.parse(body)
      parsed_keys = parsed.keys
      (parsed_keys - expected_keys).empty? && (expected_keys - parsed_keys).empty?
    else
      false
    end
  end
end

RSpec::Matchers.define :include_json do |hash|
  match do |response|
    expected_keys = hash.keys
    body = response.body
    if body.present?
      parsed = JSON.parse(body)
      expected_keys.all? { |k| hash[k].respond_to?(:call) ? hash[k].call(parsed[k.to_s]) : parsed[k.to_s] == hash[k] }
    else
      false
    end
  end
end
