class Macmaint < Formula
  include Language::Python::Virtualenv

  desc "AI-powered conversational CLI maintenance agent for macOS"
  homepage "https://github.com/nusretmemic/macmaint"

  url "https://github.com/nusretmemic/macmaint/archive/refs/tags/v0.5.2.tar.gz"
  sha256 "a7153ce1c7b169bf02e6a191bc3f424984f5255439c1e437215d366b97c436a6"
  license "MIT"
  version "0.5.2"

  # Development HEAD — install with: brew install --HEAD macmaint
  head "https://github.com/nusretmemic/macmaint.git", branch: "main"

  depends_on "python@3.12"

  def install
    python = Formula["python@3.12"].opt_bin/"python3.12"

    # Create virtualenv
    system python, "-m", "venv", libexec

    # Install dependencies
    system libexec/"bin/pip", "install", "--upgrade", "pip"
    system libexec/"bin/pip", "install",
           "click>=8.1.0",
           "rich>=13.0.0",
           "psutil>=5.9.0",
           "openai>=1.0.0",
           "pydantic>=2.0.0",
           "pyyaml>=6.0.0",
           "python-dotenv>=1.0.0"

    # Install the package itself (no deps — already installed above)
    system libexec/"bin/pip", "install", "--no-deps", buildpath

    bin.install_symlink libexec/"bin/macmaint"
  end

  def caveats
    <<~EOS
      To get started with MacMaint:
        1. Add your OpenAI API key to ~/.macmaint/.env:
             OPENAI_API_KEY=sk-...
        2. Run 'macmaint init' to set up your configuration (first-time setup)
        3. Launch the conversational AI REPL:
             macmaint chat

      Key commands inside the REPL:
        help      — show available actions
        status    — current session info
        history   — recent conversation
        exit      — quit the session

      Configuration and session history are stored in: ~/.macmaint/
    EOS
  end

  test do
    assert_match "Usage:", shell_output("#{bin}/macmaint --help")
    assert_match "chat", shell_output("#{bin}/macmaint --help")
  end
end
