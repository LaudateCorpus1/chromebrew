require 'package'

class Monero_gui < Package
  description 'Private, decentralized cryptocurrency that keeps your finances confidential and secure.'
  homepage 'https://www.getmonero.org/'
  version '0.17.3.0'
  license 'The Cryptonote developers,The Boolberry developers,MIT'
  compatibility 'x86_64'
  source_url 'https://downloads.getmonero.org/gui/monero-gui-linux-x64-v0.17.3.0.tar.bz2'
  source_sha256 'ca41cc213b3e1a82e375030bba1f46bf154b6c2ec7f858d207cf1f6dee233cd4'

  depends_on 'monero'
  depends_on 'xcb_util_image'
  depends_on 'xcb_util_keysyms'
  depends_on 'xcb_util_renderutil'
  depends_on 'xcb_util_wm'
  depends_on 'sommelier'

  def self.build
    monero = <<~EOF
    #!/bin/bash
    GDK_BACKEND=x11 #{CREW_PREFIX}/bin/monero-wallet-gui "$@"
    EOF
    File.write('monero.sh', monero)
  end

  def self.install
    FileUtils.mkdir_p "#{CREW_DEST_PREFIX}/bin"
    FileUtils.mkdir_p "#{CREW_DEST_PREFIX}/share/monero"
    FileUtils.mv 'monero-wallet-gui', "#{CREW_DEST_PREFIX}/bin"
    FileUtils.install 'monero.sh', "#{CREW_DEST_PREFIX}/bin/monero", mode: 0o755
    FileUtils.mv 'monero-gui-wallet-guide.pdf', "#{CREW_DEST_PREFIX}/share/monero"
  end

  def self.postinstall
    puts "\nType 'monero' to get started.".lightblue
    puts "\nTo view the user guide, execute the following:".lightblue
    puts "crew install zathura && zathura #{CREW_PREFIX}/share/monero/monero-gui-wallet-guide.pdf\n".lightblue
  end
end
