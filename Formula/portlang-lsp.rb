class PortlangLsp < Formula
  desc "The portlang-lsp application"
  homepage "https://github.com/portofcontext/portlang"
  version "0.1.14"
  if OS.mac? && Hardware::CPU.arm?
    url "https://github.com/portofcontext/portlang/releases/download/v0.1.14/portlang-lsp-aarch64-apple-darwin.tar.gz"
    sha256 "5a995f92d946ebc48a7db1eab1b539c45fefbb55b69b92fe48a64365824f02fb"
  end
  license any_of: ["MIT", "Apache-2.0"]

  BINARY_ALIASES = {
    "aarch64-apple-darwin": {},
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

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
