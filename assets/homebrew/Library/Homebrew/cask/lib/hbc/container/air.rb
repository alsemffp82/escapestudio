require "hbc/container/base"

module Hbc
  class Container
    class Air < Base
      INSTALLER_PATHNAME =
        Pathname("/Applications/Utilities/Adobe AIR Application Installer.app" \
                 "/Contents/MacOS/Adobe AIR Application Installer")

      def self.me?(criteria)
        %w[.air].include?(criteria.path.extname)
      end

      def self.installer_cmd
        return @installer_cmd ||= INSTALLER_PATHNAME if installer_exist?
        raise CaskError, <<-EOS.undent
          Adobe AIR runtime not present, try installing it via

              brew cask install adobe-air

        EOS
      end

      def self.installer_exist?
        INSTALLER_PATHNAME.exist?
      end

      def extract
        install = @command.run(self.class.installer_cmd,
                               args: ["-silent", "-location", @cask.staged_path, Pathname.new(@path).realpath])

        return unless install.exit_status == 9
        raise CaskError, "Adobe AIR application #{@cask} already exists on the system, and cannot be reinstalled."
      end
    end
  end
end
