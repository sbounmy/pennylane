module WithVCR
  private

  def vcr expire: true
    names = self.class.name.split("::")
    cassette_path = [names, description].flatten.map { |s| s.gsub(/[^A-Z0-9]+/i, "_") }.join("/")

    VCR.use_cassette(cassette_path) do |cassette|
      if expire && File.exist?(cassette.file)
        age = Time.now - File.mtime(cassette.file)
        FileUtils.rm(cassette.file) if age > 60 * 60 * 24
      end
      begin
        yield(cassette)
      rescue StandardError
        FileUtils.rm(cassette.file) if File.exist?(cassette.file)
        raise
      end
    end
  end
end