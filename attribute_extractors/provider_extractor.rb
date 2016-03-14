require_relative 'attribute_extractor'

class ProviderExtractor < AttributeExtractor
  def extract
    uri = URI.parse(@attributes[:url])

    {
      provider_name: @attributes[:title] ? @attributes[:title].split(/[^\w\s]/).first.strip : uri.host
    }
  end
end
