class Pctx < Formula
  desc "Open source framework to connect AI agents to tools and services with code mode"
  homepage "https://portofcontext.com"
  version "0.1.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/portofcontext/pctx/releases/download/v0.1.0/pctx-aarch64-apple-darwin.tar.gz"
      sha256 "a84795c8bfb7f223449d87d92b82d57314236b24ea436297ce479712257f2dd9"
    end
    if Hardware::CPU.intel?
      url "https://github.com/portofcontext/pctx/releases/download/v0.1.0/pctx-x86_64-apple-darwin.tar.gz"
      sha256 "eeacff6c5da51b0f8a8c458023a67ad47d673086344ca5391bcdf1f202a930e9"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/portofcontext/pctx/releases/download/v0.1.0/pctx-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "c0bae5480df5da2e150d8b50f1b52f432450a1fe9f1138d3b310cf7e031ab9d7"
    end
    if Hardware::CPU.intel?
      url "https://github.com/portofcontext/pctx/releases/download/v0.1.0/pctx-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "61044ff99c879d68f959b3dda944324d5a9ca8ea656653b800e229367c022f10"
    end
  end
  license "MIT"

  BINARY_ALIASES = {
    "aarch64-apple-darwin":      {},
    "aarch64-unknown-linux-gnu": {},
    "x86_64-apple-darwin":       {},
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
    bin.install "pctx" if OS.mac? && Hardware::CPU.arm?
    bin.install "pctx" if OS.mac? && Hardware::CPU.intel?
    bin.install "pctx" if OS.linux? && Hardware::CPU.arm?
    bin.install "pctx" if OS.linux? && Hardware::CPU.intel?

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
