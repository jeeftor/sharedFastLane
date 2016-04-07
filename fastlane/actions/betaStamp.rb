# Based on: https://gist.github.com/rgm/5377144
# Requires ImageMagick: `brew install imagemagick ghostscript`

module Fastlane
  module Actions

    class NoSourceFileError < ArgumentError; end

    class BetaIcon
      attr_accessor :src, :dst
      def src= path
        if File.exist? path
          @src = path
        else
          raise NoSourceFileError, "no icon file at #{path}"
        end
      end
      def stamp_icon_with str

        puts banner_dims

        density1 = dims[:wd].to_i * 1.98
        density2 = dims[:wd].to_i * 1.32

puts "#{str}"
        # puts "`convert  #{@src} -background '#0008' -fill white -font Helvetica -density 300 -gravity Center -size #{banner_dims} -stroke black -strokewidth 5 -annotate 0 \'BETA\' -fill yellow -stroke none -annotate 0  \'BETA\' -gravity South -density 200 -stroke black -strokewidth 5 -annotate 0 \'#{str}\' -fill yellow -stroke none -annotate 0  \'#{str}\' #{@dst}`"
        `convert  "#{@src}" -background '#0008' -fill white -font Helvetica -density #{density1} -gravity Center -size #{banner_dims} -stroke black -strokewidth 5 -annotate 0 \'BETA\' -fill yellow -stroke none -annotate 0  \'BETA\' -gravity South -density #{density2} -stroke black -strokewidth 5 -annotate 0 \'#{str}\' -fill yellow -stroke none -annotate 0  \'#{str}\' "#{@dst}"`
        #puts "convert -background '#0008' -fill white -font Helvetica -density 300 -gravity Center -size #{banner_dims} caption:\"#{str}\" \"#{@src}\" +swap -gravity South -composite \"#{@dst}\""
        #{}`convert -background '#0008' -fill white -font Helvetica -density 300 -gravity Center -size #{banner_dims} caption:"#{str}" "#{@src}" +swap -gravity South -composite "#{@dst}"`
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

    class BetastampAction < Action
      def self.run(params)
        icons = sh("find . -iname 'Icon-*'")
        # icons = sh("find . -iname 'AppIcon*.png'")
        icons.each_line do |stem|
          begin
            source = stem.strip
            i = BetaIcon.new
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
        "Stamps build wiht Beta info"
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