require_relative 'attribute_extractor'

class DescriptionExtractor < AttributeExtractor
  MIN_WORD_COUNT = 30

  def extract
    {
      description: extract_blocks.find { |b| b.split(/\b/).size >= MIN_WORD_COUNT }
    }
  end

  private

    def extract_blocks
      Nokogiri::HTML(@readability.content).text.split(/\n+/).map(&:strip).reject(&:empty?)
    end
end
