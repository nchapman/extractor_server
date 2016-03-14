require_relative 'attribute_extractors/title_extractor'
require_relative 'attribute_extractors/description_extractor'
require_relative 'attribute_extractors/images_extractor'
require_relative 'attribute_extractors/favicon_extractor'
require_relative 'attribute_extractors/provider_extractor'

class Extractor
  ATTRIBUTE_EXTRACTORS = [
    TitleExtractor,
    DescriptionExtractor,
    ImagesExtractor,
    FaviconExtractor,
    ProviderExtractor
  ]

  def initialize(url)
    @url = url
  end

  def extract
    if $cache.has_key?(@url)
      puts "CACHE HIT"
      return $cache[@url]
    end

    begin
      Timeout.timeout(15) do
        fetch

        attributes = {
          url: @url
        }

        ATTRIBUTE_EXTRACTORS.each { |ae| extract_attribute(ae, attributes) }

        $cache[@url] = attributes

        return attributes
      end
    rescue
      puts $!
    end
  end

  private

    def fetch
      @source = RestClient.get(@url)
      @doc = Nokogiri::HTML(@source)
      @readability = Readability::Document.new(@doc, tags: %w[div p img a pre], attributes: %w[src href], remove_empty_nodes: false)
    end

    def extract_attribute(attribute_extractor, attributes)
      e = attribute_extractor.new(@doc, @readability, attributes)
      attributes.merge!(e.extract)
    rescue
      puts "ERROR: extract_attribute: #{$!}"
    end
end
