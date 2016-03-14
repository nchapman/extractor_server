require_relative 'attribute_extractor'

class FaviconExtractor < AttributeExtractor
  def extract
    @uri = URI.parse(@attributes[:url])

    favicon_url = get_favicon_url
    favicon_colors = get_favicon_colors(favicon_url)

    {
      favicon_url: favicon_url,
      favicon_colors: favicon_colors
    }
  end

  private

    def get_favicon_url
      puts get_largest_icon_from_source
      get_largest_icon_from_source || get_default_favicon_from_server
    end

    def get_largest_icon_from_source
      if element = @doc.css('link[rel*=icon]').sort { |a, b| a['sizes'].to_i <=> b['sizes'].to_i  }.last
        # cover relative urls
        (@uri + element['href']).to_s
      else
        nil
      end
    end

    def get_default_favicon_from_server
      default_favicon_url = "#{@uri.scheme}://#{@uri.host}/favicon.ico"

      begin
        exists = RestClient.head(default_favicon_url).code == 200
      rescue RestClient::Exception => error
        exists = (error.http_code != 404)
      end

      exists ? default_favicon_url : nil
    end

    def get_favicon_colors(favicon_url)
      if favicon_url
        colors = Miro::DominantColors.new(favicon_url)

        colors.to_rgb.zip(colors.by_percentage).collect { |c| { color: c[0], weight: c[1] } }
      else
        nil
      end
    end
end
