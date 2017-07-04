class Tmux < Formula
  desc "Terminal multiplexer"
  homepage "https://tmux.github.io/"
  url "https://github.com/tmux/tmux/releases/download/2.5/tmux-2.5.tar.gz"
  sha256 "ae135ec37c1bf6b7750a84e3a35e93d91033a806943e034521c8af51b12d95df"

  head do
    url "https://github.com/tmux/tmux.git"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  patch :p1 do
    url "https://gist.githubusercontent.com/choppsv1/352421a9f49262ad5c93/raw/5d29be026e11f75a9f570f354149c913c749a699/tmux-2.1-24bit.diff"
    sha256 "6d92559da2bf7433f505efd785404fe055772c7cd8c49d208d7522b169c09903"
  end

  depends_on "pkg-config" => :build
  depends_on "libevent"

  def install
    system "sh", "autogen.sh" if build.head?

    ENV.append "LDFLAGS", "-lresolv"
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--sysconfdir=#{etc}"
    system "make", "install"

    bash_completion.install "examples/bash_completion_tmux.sh" => "tmux"
    pkgshare.install "examples"
  end

  def caveats; <<-EOS.undent
    Example configurations have been installed to:
      #{pkgshare}/examples
    EOS
  end

  test do
    system "#{bin}/tmux", "-V"
  end
end
