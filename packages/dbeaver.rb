require 'package'

class Dbeaver < Package
  description 'Free Universal Database Tool'
  homepage 'https://dbeaver.io'
  version '21.3.1'
  license 'Apache-2.0'
  compatibility 'x86_64'
  source_url ({
    x86_64: 'https://github.com/dbeaver/dbeaver/releases/download/21.3.1/dbeaver-ce-21.3.1-linux.gtk.x86_64.tar.gz'
  })
  source_sha256 ({
    x86_64: '5080e2ccd4800b6ff7da26cd665f4d02d38ddf5c60d8c059e12b2ba31b1287f8'
  })

  depends_on 'gtk3'
  depends_on 'xdg_base'
  depends_on 'sommelier'

  def self.patch
    system "sed -i 's,/usr/share/dbeaver-ce,#{CREW_PREFIX}/share/dbeaver,g' dbeaver-ce.desktop"
    system "sed -i 's,#{CREW_PREFIX}/share/dbeaver/dbeaver.png,dbeaver.png,' dbeaver-ce.desktop"
  end

  def self.install
    FileUtils.mkdir_p "#{CREW_DEST_PREFIX}/bin"
    FileUtils.mkdir_p "#{CREW_DEST_PREFIX}/share/dbeaver"
    FileUtils.mkdir_p "#{CREW_DEST_PREFIX}/share/applications"
    FileUtils.mkdir_p "#{CREW_DEST_PREFIX}/share/applications"
    FileUtils.mkdir_p "#{CREW_DEST_PREFIX}/share/icons/hicolor/256x256/apps"
    FileUtils.mv 'dbeaver-ce.desktop', "#{CREW_DEST_PREFIX}/share/applications"
    FileUtils.mv 'dbeaver.png', "#{CREW_DEST_PREFIX}/share/icons/hicolor/256x256/apps"
    FileUtils.cp_r Dir['.'], "#{CREW_DEST_PREFIX}/share/dbeaver"
    FileUtils.ln_s "#{CREW_PREFIX}/share/dbeaver/dbeaver", "#{CREW_DEST_PREFIX}/bin/dbeaver"
  end

  def self.postinstall
    puts "\nType 'dbeaver' to get started.\n".lightblue
  end

  def self.remove
    config_dir = "#{HOME}/.local/share/DBeaverData"
    if Dir.exists? config_dir
      print "Would you like to remove the #{config_dir} directory? [y/N] "
      case STDIN.getc
      when "y", "Y"
        FileUtils.rm_rf config_dir
        puts "#{config_dir} removed.".lightred
      else
        puts "#{config_dir} saved.".lightgreen
      end
    end
  end
end
