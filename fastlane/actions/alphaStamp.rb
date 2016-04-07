# Based on: https://gist.github.com/rgm/5377144
# Requires ImageMagick: `brew install imagemagick ghostscript`

module Fastlane
  module Actions

    class NoSourceFileError < ArgumentError; end

    class AlphaIcon
      attr_accessor :src, :dst
      def src= path
        if File.exist? path
          @src = path
        else
          raise NoSourceFileError, "no icon file at #{path}"
        end
      end
      def stamp_icon_with str
        density1 = dims[:wd].to_i * 1.78
        density2 = dims[:wd].to_i * 1.32
        `convert  "#{@src}" -background '#0008' -fill white -font Helvetica -density #{density1} -gravity Center -size #{banner_dims} -stroke black -strokewidth 5 -annotate 0 \'ALPHA\' -fill SkyBlue1 -stroke none -annotate 0  \'ALPHA\' -gravity South -density #{density2} -stroke black -strokewidth 5 -annotate 0 \'#{str}\' -fill SkyBlue1 -stroke none -annotate 0  \'#{str}\' "#{@dst}"`
      end
      
      def banner_dims
        banner_ht = (dims[:ht] * 0.2).floor
        "#{dims[:wd]}x#{banner_ht}" # imagemagick-style format string
      end
      def dims
        return @dims if @dims
        data = `identify -format "%w %h" "#{@src}"`.strip.split.map(&:to_i)
        @dims = {:wd => data[0], :ht => data[1]}
      end
    end

    class AlphastampAction < Action
      def self.run(params)
        icons = sh("find . -iname 'Icon-*'")
        # icons = sh("find . -iname 'Icon-*.png'")
        icons.each_line do |stem|
          begin
            source = stem.strip
            i = AlphaIcon.new
            i.src = source
            i.dst = "#{source}-edit"
            version = ENV["BUILD_NUMBER"] || "1234"
            i.stamp_icon_with "#{version}"
            FileUtils.cp i.dst, i.src
            FileUtils.rm i.dst
          rescue NoSourceFileError => msg
            STDERR.puts "Warning: #{msg}"
          end
        end
      end

      #####################################################
      # @!group Documentation
      #####################################################

      def self.description
        "Stamps build wiht Alpha info"
      end

      def self.authors
        ["@jstein"]
      end

      def self.is_supported?(platform)
        platform == :ios
      end
    end
  end
end