require 'package'

class Acli < Package
  description 'Acquia CLI - The official command-line tool for interacting with the Drupal Cloud Platform and services.'
  homepage 'https://github.com/acquia/cli'
  version '1.22.0'
  license 'GPL-2.0'
  compatibility 'all'
  source_url 'SKIP'

  depends_on 'php74' unless File.exists? "#{CREW_PREFIX}/bin/php"

  def self.preflight
    major = `php -v 2> /dev/null | head -1 | cut -d' ' -f2 | cut -d'.' -f1`
    minor = `php -v 2> /dev/null | head -1 | cut -d' ' -f2 | cut -d'.' -f2`
    unless major.empty? or minor.empty? or (major.to_i >= 7 and minor.to_i >= 3)
      abort "acli requires php >= 7.3. php #{major.chomp}.#{minor.chomp} does not meet the minimum requirement.".lightred
    end
  end

  def self.install
    system "curl -#LO https://github.com/acquia/cli/releases/download/#{version}/acli.phar"
    abort 'Checksum mismatch. :/ Try again.'.lightred unless Digest::SHA256.hexdigest( File.read('acli.phar') ) == 'ec6368888922d4d036917b033261920423352c4c40d702c00a316a6553263e7c'
    FileUtils.mkdir_p "#{CREW_DEST_PREFIX}/bin"
    FileUtils.install 'acli.phar', "#{CREW_DEST_PREFIX}/bin/acli", mode: 0o755
  end
end
