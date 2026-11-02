class Pctx < Formula
  desc "Open source framework to connect AI agents to tools and services with code mode"
  homepage "https://portofcontext.com"
  version "1.0.0"
  if OS.mac? && Hardware::CPU.arm?
    url "https://github.com/portofcontext/pctx/releases/download/v1.0.0/pctx-aarch64-apple-darwin.tar.gz"
    sha256 "34577923ecb7826e81310c1404e7cf196d5df7322adfb310b5e8b1ff76384d29"
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/portofcontext/pctx/releases/download/v1.0.0/pctx-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "40060e124782f35408466609b8d31773dbf1e93fd62f3d92aea9e4f70075e6d1"
    end
    if Hardware::CPU.intel?
      url "https://github.com/portofcontext/pctx/releases/download/v1.0.0/pctx-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "5bf1dc5d6931a16078bdaefb8586f37b332bb1ce9ccd4086916608f523e0373d"
    end
  end
  license "MIT"

  BINARY_ALIASES = {
    "aarch64-apple-darwin":      {},
    "aarch64-unknown-linux-gnu": {},
    "x86_64-pc-windows-gnu":     {},
    "x86_64-unknown-linux-gnu":  {},
  }.freeze

  def target_triple
    cpu = Hardware::CPU.arm? ? "aarch64" : "x86_64"
    os = OS.mac? ? "apple-darwin" : "unknown-linux-gnu"

    "#{cpu}-#{os}"
  end

  def install_binary_aliases!
    BINARY_ALIASES[target_triple.to_sym].each do |source, dests|
      dests.each do |dest|
        bin.install_symlink bin/source.to_s => dest
      end
    end
  end

  def install
    if OS.mac? && Hardware::CPU.arm?
      bin.install "generate-cli-docs", "pctx"
    end
    if OS.linux? && Hardware::CPU.arm?
      bin.install "generate-cli-docs", "pctx"
    end
    if OS.linux? && Hardware::CPU.intel?
      bin.install "generate-cli-docs", "pctx"
    end

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
