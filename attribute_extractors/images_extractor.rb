require_relative 'attribute_extractor'

class ImagesExtractor < AttributeExtractor
  def extract
    {
      images: get_images_with_dimensions
    }
  end

  private

    def get_images_with_dimensions
      images = []

      @readability.images.slice(0, 1).each do |i|
        width, height = FastImage.size(i)

        images << {
          url: i,
          width: width,
          height: height,
          entropy: 1
        }
      end

      images
    end
end
