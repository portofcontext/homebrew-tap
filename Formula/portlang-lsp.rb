class PortlangLsp < Formula
  desc "The portlang-lsp application"
  homepage "https://github.com/portofcontext/portlang"
  version "0.1.17"
  if OS.mac? && Hardware::CPU.arm?
    url "https://github.com/portofcontext/portlang/releases/download/v0.1.17/portlang-lsp-aarch64-apple-darwin.tar.gz"
    sha256 "264eb267ce714c2bb13aed691e7366a0215b05f66d1e13f0655e09b1b62c2c1e"
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/portofcontext/portlang/releases/download/v0.1.17/portlang-lsp-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "187a69a8f1e52dedcd8dd33b89e29b34062fd49e991f13a7e064da162425a10c"
    end
    if Hardware::CPU.intel?
      url "https://github.com/portofcontext/portlang/releases/download/v0.1.17/portlang-lsp-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "4b74bcdec5e1865aea133e5400791cc596550a170f2d822b601a0f6618b810f0"
    end
  end
  license any_of: ["MIT", "Apache-2.0"]

  BINARY_ALIASES = {
    "aarch64-apple-darwin":      {},
    "aarch64-unknown-linux-gnu": {},
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
    bin.install "portlang-lsp" if OS.mac? && Hardware::CPU.arm?
    bin.install "portlang-lsp" if OS.linux? && Hardware::CPU.arm?
    bin.install "portlang-lsp" if OS.linux? && Hardware::CPU.intel?

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
