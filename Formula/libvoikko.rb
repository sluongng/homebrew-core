class Libvoikko < Formula
  desc "Linguistic software and Finnish dictionary"
  homepage "https://voikko.puimula.org/"
  url "https://www.puimula.org/voikko-sources/libvoikko/libvoikko-4.2.tar.gz"
  sha256 "f13c59825f36152f388cd96f638e447744199775277f4e6bcd0b9483f0eebeca"
  revision 1

  bottle do
    cellar :any
    sha256 "00d30a497ca4a6887f88cdefdd459fed0ca503a3b485d3586660767b0be885c5" => :mojave
    sha256 "af7ed79bbb228c0b422c0956d4ec4acf95a7832482b835c900501bb77b8aebb6" => :high_sierra
    sha256 "91b08ddb3f25562420d1b135cf5dd026698c27d5c0dbd4fc5dc5000e6585e932" => :sierra
  end

  depends_on "foma" => :build
  depends_on "pkg-config" => :build
  depends_on "python" => :build
  depends_on "hfstospell"

  resource "voikko-fi" do
    url "https://www.puimula.org/voikko-sources/voikko-fi/voikko-fi-2.1.tar.gz"
    sha256 "71a823120a35ade6f20eaa7d00db27ec7355aa46a45a5b1a4a1f687a42134496"
  end

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}",
                          "--with-dictionary-path=#{HOMEBREW_PREFIX}/lib/voikko"
    system "make", "install"

    resource("voikko-fi").stage do
      ENV.append_path "PATH", bin.to_s
      system "make", "vvfst"
      system "make", "vvfst-install", "DESTDIR=#{lib}/voikko"
      lib.install_symlink "voikko"
    end
  end

  test do
    pipe_output("#{bin}/voikkospell -m", "onkohan\n")
  end
end
