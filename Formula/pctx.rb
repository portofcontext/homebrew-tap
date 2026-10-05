class Pctx < Formula
  desc "Open source framework to connect AI agents to tools and services with code mode"
  homepage "https://portofcontext.com"
  version "0.7.5"
  if OS.mac? && Hardware::CPU.arm?
    url "https://github.com/portofcontext/pctx/releases/download/v0.7.5/pctx-aarch64-apple-darwin.tar.gz"
    sha256 "fb166311db77aae2222318f1f28b6aab0c68093b6d8e3a0777b3c29cf42e54dc"
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/portofcontext/pctx/releases/download/v0.7.5/pctx-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "63f43c70a6a96f6d13895cdd22d791c15683c86eb1d32d42c0ede1d195f06c19"
    end
    if Hardware::CPU.intel?
      url "https://github.com/portofcontext/pctx/releases/download/v0.7.5/pctx-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "b8f8d12bb7b5cef3597242f0fac3dd8e5e77ab944242a4997d1871a2d69910a3"
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
