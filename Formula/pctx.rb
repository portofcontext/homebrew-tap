class Pctx < Formula
  desc "Open source framework to connect AI agents to tools and services with code mode"
  homepage "https://portofcontext.com"
  version "0.1.1"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/portofcontext/pctx/releases/download/v0.1.1/pctx-aarch64-apple-darwin.tar.gz"
      sha256 "aca8c71edbd74e22ab9822f0ee6d0bbc66ed5d10c49568142a3abeef02df5b6f"
    end
    if Hardware::CPU.intel?
      url "https://github.com/portofcontext/pctx/releases/download/v0.1.1/pctx-x86_64-apple-darwin.tar.gz"
      sha256 "4486d5a77649ebee9d7a1ee78411efebf31e0143cbaad59eb2fc8284985e6c43"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/portofcontext/pctx/releases/download/v0.1.1/pctx-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "8232450005a8b1ebdd59ef3f2cddbc4ef7226e23ede80e50cb9f7323835d504f"
    end
    if Hardware::CPU.intel?
      url "https://github.com/portofcontext/pctx/releases/download/v0.1.1/pctx-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "77e6dbc24c65d63d307e9a01c14e966862ed8ab3b92c7e1e83a4ea6136674841"
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
    bin.install "generate-cli-docs", "pctx" if OS.mac? && Hardware::CPU.arm?
    bin.install "generate-cli-docs", "pctx" if OS.mac? && Hardware::CPU.intel?
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
