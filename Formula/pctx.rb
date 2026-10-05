class Pctx < Formula
  desc "Open source framework to connect AI agents to tools and services with code mode"
  homepage "https://portofcontext.com"
  version "0.7.6"
  if OS.mac? && Hardware::CPU.arm?
    url "https://github.com/portofcontext/pctx/releases/download/v0.7.6/pctx-aarch64-apple-darwin.tar.gz"
    sha256 "d516196d0d95456634935fc6c47c3ff3b287a6948a68d6fe2616a874b8c8db0f"
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/portofcontext/pctx/releases/download/v0.7.6/pctx-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "5269bd297aa9d9e171fd9f91b3b0f0d75436442db33b612d569885c18988deb4"
    end
    if Hardware::CPU.intel?
      url "https://github.com/portofcontext/pctx/releases/download/v0.7.6/pctx-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "0efac2e034305799bea00414e5cc48ecee122e98faee63b70084b1179d795c30"
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
