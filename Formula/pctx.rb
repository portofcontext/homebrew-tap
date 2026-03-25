class Pctx < Formula
  desc "Open source framework to connect AI agents to tools and services with code mode"
  homepage "https://portofcontext.com"
  version "0.7.0"
  if OS.mac? && Hardware::CPU.arm?
    url "https://github.com/portofcontext/pctx/releases/download/v0.7.0/pctx-aarch64-apple-darwin.tar.gz"
    sha256 "165b8cfed2efea6a57e789b89922e475e822c93f1f0d6294829ddeff262ae17b"
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/portofcontext/pctx/releases/download/v0.7.0/pctx-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "6a9deb6f4a41941036452f438a66f030f3daac3039267e56da0f215f9ea72eab"
    end
    if Hardware::CPU.intel?
      url "https://github.com/portofcontext/pctx/releases/download/v0.7.0/pctx-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "caf510d273f37b60644ba9755f5191e520b8ae121c227a651728a4bd6e6fa837"
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
    bin.install "generate-cli-docs", "pctx" if OS.mac? && Hardware::CPU.arm?
    bin.install "generate-cli-docs", "pctx" if OS.linux? && Hardware::CPU.arm?
    bin.install "generate-cli-docs", "pctx" if OS.linux? && Hardware::CPU.intel?

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
