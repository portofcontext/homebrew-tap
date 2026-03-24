class Portlang < Formula
  desc "A CLI for building reliable, model-agnostic agents"
  homepage "https://github.com/portofcontext/portlang"
  version "0.1.18"
  if OS.mac? && Hardware::CPU.arm?
    url "https://github.com/portofcontext/portlang/releases/download/v0.1.18/portlang-aarch64-apple-darwin.tar.gz"
    sha256 "0624753c332d5bf8c43aa033f8689e8091ddcae611c5a0da1f21be2e48038132"
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/portofcontext/portlang/releases/download/v0.1.18/portlang-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "ea49737907c12bdefde1a0ce95cc57235cdf14ca99a259edacc7765758b5ab13"
    end
    if Hardware::CPU.intel?
      url "https://github.com/portofcontext/portlang/releases/download/v0.1.18/portlang-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "4e38a76a72dbacfcd0ea715bd55fe260710f08e6415d811367b780057fc1bd9d"
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
    bin.install "portlang" if OS.mac? && Hardware::CPU.arm?
    bin.install "portlang" if OS.linux? && Hardware::CPU.arm?
    bin.install "portlang" if OS.linux? && Hardware::CPU.intel?

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
