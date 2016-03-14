require_relative 'attribute_extractor'

class TitleExtractor < AttributeExtractor
  def extract
    {
      title: @doc.at_css('title').text
    }
  end
end
