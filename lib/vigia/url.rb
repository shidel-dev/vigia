require 'uri'
require 'addressable/template'
require 'addressable/uri'


module Vigia
  class Url
    class << self
      def template_defines_url?(template, url)
        url_object      = Addressable::URI.parse(url)
        template_object = Addressable::Template.new(template)
        url_parameters  = template_object.extract(url_object) || {}
        # recreate url and see if matches
        template_object.expand(url_parameters) == url_object
      end
    end

    attr_reader :uri_template

    # ApiBluprint uses RFC6570 in all its resource's uri_templates
    # https://github.com/apiaryio/api-blueprint/blob/master/API%20Blueprint%20Specification.md#1-uri-templates
    def initialize(apib_uri_template)
      @uri_template = Addressable::Template.new(apib_uri_template)
    end

    def expand(parameters)
      absolute_url uri_template.expand(valid_parameters(parameters).to_hash)
    end

    def absolute_url path
      URI.join(host, path).to_s
    end

    def host
      Vigia.config.host
    end

    private

    def valid_parameters(parameters)
      Vigia::Parameters.new(parameters)
    end
  end
end
