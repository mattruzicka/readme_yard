# frozen_string_literal: true

class ReadmeYard
  class YardOptsManager
    class << self
      YARDOPTS_FILE = ".yardopts"

      def upsert_yardopts
        File.exist?(YARDOPTS_FILE) ? update_yardopts_file : create_yardopts_file
      end

      def update_yardopts_file
        text = File.read(YARDOPTS_FILE)
        text_addition = build_yardopts_text_addition(text)
        File.open(YARDOPTS_FILE, "a") { |f| f.write(text_addition) } if text_addition
      end

      def build_yardopts_text_addition(yardopts_text)
        return if yardopts_text.match?(/\s*--plugin\s+readme\W/)

        readme_plugin_opts = default_readme_plugin_opts(yardopts_text)
        case yardopts_text
        when /\s*--markup\s+markdown/, /\s*-m\s+markdown/
          readme_plugin_opts
        when /\s*--markup\s/, /\s*-m\s/
          warn_about_supported_markdown
          readme_plugin_opts
        else
          readme_plugin_opts << "--markup markdown\n"
        end
      end

      def default_readme_plugin_opts(yardopts_text)
        readme_opts = +""
        readme_opts << "\n" unless yardopts_text.lines.last.include?("\n")
        readme_opts << "--plugin readme\n"
      end

      def create_yardopts_file
        File.write(YARDOPTS_FILE, "--plugin readme\n--markup markdown\n")
      end

      def warn_about_supported_markdown
        Logger.warn "*Readme Yard* works best with markdown. " \
                    "Consider adding `--markup markdown` to your `.yardopts` file."
      end
    end
  end
end
