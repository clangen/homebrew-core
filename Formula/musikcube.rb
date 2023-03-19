class Musikcube < Formula
  desc "Terminal-based audio engine, library, player and server"
  homepage "https://musikcube.com"
  url "https://github.com/clangen/musikcube/archive/0.99.6.tar.gz"
  sha256 "739375d47414ad1d8c68facb2d8a975b67584432c2b4d57504d99beffe6922e9"
  license "BSD-3-Clause"
  head "https://github.com/clangen/musikcube.git", branch: "master"

  depends_on "asio" => :build
  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "ffmpeg"
  depends_on "game-music-emu"
  depends_on "gnutls"
  depends_on "lame"
  depends_on "libev"
  depends_on "libmicrohttpd"
  depends_on "libogg"
  depends_on "libopenmpt"
  depends_on "libvorbis"
  depends_on "openssl@1.1"
  depends_on "taglib"
  uses_from_macos "curl"
  uses_from_macos "ncurses"

  def install
    platform_specific_args = []
    if OS.mac?
      platform_specific_args = [
        "-DNO_NCURSESW=true",
        "-DENABLE_MACOS_SYSTEM_NCURSES=true",
      ]
    end
    system "cmake",
      ".",
      *platform_specific_args,
      *std_cmake_args
    system "make"
    system "make", "install"
  end

  test do
    system "#{bin}/musikcubed", "--start"
    # if there is no lockfile then the daemon was unable to start properly
    assert_path_exists "/tmp/musikcubed.lock"
    system "#{bin}/musikcubed", "--stop"
  end
end
