class Pctx < Formula
  desc "Open source framework to connect AI agents to tools and services with code mode"
  homepage "https://portofcontext.com"
  version "0.1.3"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/portofcontext/pctx/releases/download/v0.1.3/pctx-aarch64-apple-darwin.tar.gz"
      sha256 "cb6998626782eb1846563ddc59428a2cd3d479a8b5dcffe89fc274fa900aff6c"
    end
    if Hardware::CPU.intel?
      url "https://github.com/portofcontext/pctx/releases/download/v0.1.3/pctx-x86_64-apple-darwin.tar.gz"
      sha256 "108081c2964831a060e65c03ff7e2951a968d909b13b9558c4831b6409630c52"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/portofcontext/pctx/releases/download/v0.1.3/pctx-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "19bdedd19346dc3185f972c6d98eb243faede13a8451f5ecebf996d365263b2a"
    end
    if Hardware::CPU.intel?
      url "https://github.com/portofcontext/pctx/releases/download/v0.1.3/pctx-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "5009d11358e5815db31f99fe8758ed914f2fbf87a61f6a3fa1e1c14a6824fdef"
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
