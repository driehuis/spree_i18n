# TODO: Add code to detect the case where this rake task is run in the context of the spree_i18n gem itself.
# It should be run from your app dir.
# What it does is clean up the Dutch to use a slightly more formal style ("Wilt u" instead of "Wil je").
namespace :lang do
  desc "Formalize Dutch translation"
  task :formalize_dutch => :environment do
    i18n_dir = `bundle show spree_i18n`.chomp
    infile = i18n_dir + "/config/locales/nl.yml"
    outfile = "#{File.dirname(__FILE__)}/../../config/locales/nl.yml"
    outfiletmp = "#{outfile}.tmp"
    infd = File.open infile
    outfd = File.open outfiletmp, mode="w"
    infd.each do |line|
      line.gsub!(/je (account|adres|betaalgegevens|bestelling|e-mail|gegevens|huidige|order|wachtwoord|winkelwagen)/, 'uw \1')
      line.gsub!(/Je (account|adres|betaalgegevens|bestelling|e-mail|gegevens|huidige|order|wachtwoord|winkelwagen)/, 'Uw \1')
      line.gsub!(/je (bent|hebt)/, 'u \1')
      line.gsub!(/Je (bent|hebt)/, 'U \1')
      line.gsub!(/Je kan/, 'U kunt')
      line.gsub!(/(Weet|Als|als|voordat|dat|naar) je/, '\1 u')
      line.gsub!(/(Wil|dien) je/, '\1t u')
      line.gsub!(/Wilt je/, 'Wilt u')  # tijdelijk
      outfd.write(line)
    end
    infd.close
    outfd.close
    File.rename outfiletmp, outfile
  end
end
