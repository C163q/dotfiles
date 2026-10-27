"""Run setup.sh against temporary homes and local Git repositories."""

import os
from pathlib import Path
import shutil
import subprocess
import sys
import tempfile
import unittest


SETUP_SCRIPT = Path(__file__).resolve().parents[1] / "setup.sh"
REAL_GIT = shutil.which("git")


class SetupTests(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        cls.seeds = tempfile.TemporaryDirectory(prefix="dotfiles-setup-seeds-")
        cls.addClassCleanup(cls.seeds.cleanup)
        cls.git_env = {key: value for key, value in os.environ.items() if not key.startswith("GIT_")}
        cls.git_env.update(GIT_CONFIG_GLOBAL=os.devnull, GIT_CONFIG_NOSYSTEM="1")
        for name, entrypoint in (
            ("ohmyzsh", "oh-my-zsh.sh"),
            ("powerlevel10k", "powerlevel10k.zsh-theme"),
        ):
            seed = Path(cls.seeds.name) / name
            seed.mkdir()
            (seed / entrypoint).write_text("# Installed from a local test repository.\n")
            cls.git("init", "-q", str(seed))
            cls.git("-C", str(seed), "add", entrypoint)
            cls.git(
                "-C", str(seed), "-c", "user.name=Setup Test",
                "-c", "user.email=setup@example.invalid",
                "-c", "commit.gpgsign=false", "commit", "-qm", "Test installation",
            )

    @classmethod
    def git(cls, *args):
        return subprocess.run(
            [REAL_GIT, *args], env=cls.git_env, check=True, capture_output=True, text=True
        )

    def setUp(self):
        temporary = tempfile.TemporaryDirectory(prefix="dotfiles-setup-")
        self.addCleanup(temporary.cleanup)
        self.base = Path(temporary.name)
        self.repo = self.base / "repository with spaces"
        self.repo.mkdir()
        shutil.copyfile(SETUP_SCRIPT, self.repo / "setup.sh")
        for directory in ("nvim/config", "vim/.vim", "fastfetch", "zsh/config", "yazi", "kitty"):
            (self.repo / directory).mkdir(parents=True)
        for filename in ("tmux/tmux.conf", "vim/.vimrc", "zsh/.zshrc", "zsh/.zshenv"):
            source = self.repo / filename
            source.parent.mkdir(parents=True, exist_ok=True)
            source.write_text("# Test configuration.\n")

        self.home = self.base / "home with spaces"
        self.home.mkdir()
        self.config = self.home / ".config"
        self.cache = self.home / ".cache"
        self.cwd = self.base / "unrelated working directory"
        self.cwd.mkdir()
        bin_dir = self.base / "bin"
        bin_dir.mkdir()

        # Replace only the network boundary: use real Git clones of local seeds.
        git_wrapper = bin_dir / "git"
        git_wrapper.write_text(
            f"#!{sys.executable}\n"
            "import os, sys\n"
            "args = sys.argv[1:]\n"
            "sources = {\n"
            f"    'https://github.com/ohmyzsh/ohmyzsh.git': {str(Path(self.seeds.name) / 'ohmyzsh')!r},\n"
            f"    'https://github.com/romkatv/powerlevel10k.git': {str(Path(self.seeds.name) / 'powerlevel10k')!r},\n"
            "}\n"
            "if args and args[0] == 'clone':\n"
            "    for index, arg in enumerate(args):\n"
            "        if arg in sources:\n"
            "            if os.environ.get('SETUP_TEST_FAIL_CLONE') == arg:\n"
            "                sys.stderr.write('Simulated clone failure\\n')\n"
            "                sys.exit(23)\n"
            "            args[index] = sources[arg]\n"
            f"os.execv({REAL_GIT!r}, [{REAL_GIT!r}, *args])\n"
        )
        git_wrapper.chmod(0o755)
        self.env = dict(
            self.git_env,
            HOME=str(self.home),
            PATH=str(bin_dir) + os.pathsep + os.environ["PATH"],
        )
        self.env.pop("XDG_CONFIG_HOME", None)
        self.env.pop("XDG_CACHE_HOME", None)
        self.env.pop("BASH_ENV", None)

    def run_setup(self, *, relative=False):
        # Also confine the original script, whose invalid top-level `local`
        # leaves CONFIG_DIR unset, while reproducing its other failures.
        self.env["CONFIG_DIR"] = str(self.config)
        script = self.repo / "setup.sh"
        if relative:
            script = os.path.relpath(script, self.cwd)
        return subprocess.run(
            ["bash", str(script)], cwd=self.cwd, env=self.env,
            capture_output=True, text=True, timeout=20,
        )

    def assert_success(self, result):
        self.assertEqual(result.returncode, 0, result.stdout + result.stderr)

    def assert_installed(self):
        expected = {
            self.config / "nvim": "nvim/config",
            self.config / "tmux/tmux.conf": "tmux/tmux.conf",
            self.home / ".vimrc": "vim/.vimrc",
            self.home / ".vim": "vim/.vim",
            self.config / "fastfetch": "fastfetch",
            self.home / ".zshrc": "zsh/.zshrc",
            self.home / ".zshenv": "zsh/.zshenv",
            self.config / "zsh": "zsh/config",
            self.config / "yazi": "yazi",
            self.config / "kitty": "kitty",
        }
        for target, source in expected.items():
            with self.subTest(target=target):
                self.assertTrue(target.is_symlink(), str(target))
                self.assertTrue(target.exists(), f"Broken symlink: {target}")
                self.assertEqual(target.resolve(), self.repo / source)
        self.assertTrue((self.cache / "zsh").is_dir())
        zsh = self.home / ".local/share/zsh"
        self.assertTrue((zsh / "ohmyzsh/oh-my-zsh.sh").is_file())
        self.assertTrue((zsh / "ohmyzsh/themes/powerlevel10k/powerlevel10k.zsh-theme").is_file())

    def test_absolute_invocation_from_another_directory_with_spaces(self):
        self.assert_success(self.run_setup())
        self.assert_installed()

    def test_relative_invocation_respects_nested_xdg_config_home(self):
        self.config = self.base / "custom configuration" / "nested"
        self.env["XDG_CONFIG_HOME"] = str(self.config)
        self.assert_success(self.run_setup(relative=True))
        self.assert_installed()

    def test_empty_xdg_config_home_uses_default(self):
        self.env["XDG_CONFIG_HOME"] = ""
        self.assert_success(self.run_setup())
        self.assert_installed()

    def test_custom_xdg_cache_home_is_used_for_zsh_cache(self):
        self.cache = self.base / "custom cache" / "nested"
        self.env["XDG_CACHE_HOME"] = str(self.cache)
        self.assert_success(self.run_setup())
        self.assert_installed()
        self.assertFalse((self.home / ".cache/zsh").exists())

    def test_repeated_runs_preserve_installations_and_do_not_nest_links(self):
        self.assert_success(self.run_setup())
        entrypoint = self.home / ".local/share/zsh/ohmyzsh/oh-my-zsh.sh"
        entrypoint.write_text("# Local customization.\n")
        before = sorted(str(path.relative_to(self.repo)) for path in self.repo.rglob("*"))
        self.assert_success(self.run_setup())
        self.assert_installed()
        self.assertEqual(entrypoint.read_text(), "# Local customization.\n")
        self.assertEqual(before, sorted(str(path.relative_to(self.repo)) for path in self.repo.rglob("*")))

    def test_existing_config_file_is_preserved_and_reported_as_a_conflict(self):
        target = self.home / ".zshenv"
        target.write_text("# Existing configuration.\n")
        result = self.run_setup()
        self.assertNotEqual(result.returncode, 0)
        self.assertIn(str(target), result.stderr)
        self.assertEqual(target.read_text(), "# Existing configuration.\n")
        self.assertFalse((self.config / "nvim").exists())

    def test_existing_config_directory_is_preserved_without_a_nested_link(self):
        target = self.config / "nvim"
        target.mkdir(parents=True)
        (target / "init.lua").write_text("-- Existing configuration.\n")
        result = self.run_setup()
        self.assertNotEqual(result.returncode, 0)
        self.assertIn(str(target), result.stderr)
        self.assertEqual(list(target.iterdir()), [target / "init.lua"])
        self.assertFalse((self.home / ".zshenv").exists())

    def test_broken_destination_symlink_is_preserved_and_reported(self):
        target = self.home / ".zshenv"
        target.symlink_to("missing-configuration")
        result = self.run_setup()
        self.assertNotEqual(result.returncode, 0)
        self.assertIn(str(target), result.stderr)
        self.assertEqual(os.readlink(target), "missing-configuration")

    def test_existing_relative_symlink_to_the_correct_source_is_accepted(self):
        target = self.home / ".zshenv"
        target.symlink_to(os.path.relpath(self.repo / "zsh/.zshenv", self.home))
        self.assert_success(self.run_setup())
        self.assert_installed()

    def test_clone_failure_stops_before_linking_and_a_rerun_recovers(self):
        self.env["SETUP_TEST_FAIL_CLONE"] = "https://github.com/romkatv/powerlevel10k.git"
        result = self.run_setup()
        self.assertNotEqual(result.returncode, 0)
        self.assertIn("Simulated clone failure", result.stderr)
        self.assertFalse((self.home / ".zshenv").exists())
        del self.env["SETUP_TEST_FAIL_CLONE"]
        self.assert_success(self.run_setup())
        self.assert_installed()

    def test_missing_source_stops_before_installation(self):
        (self.repo / "zsh/.zshenv").unlink()
        result = self.run_setup()
        self.assertNotEqual(result.returncode, 0)
        self.assertIn(".zshenv", result.stderr)
        self.assertFalse((self.home / ".local").exists())

    def test_unrecognized_existing_installation_is_preserved(self):
        target = self.home / ".local/share/zsh/ohmyzsh"
        target.mkdir(parents=True)
        (target / "personal-file").write_text("Keep me.\n")
        result = self.run_setup()
        self.assertNotEqual(result.returncode, 0)
        self.assertIn(str(target), result.stderr)
        self.assertEqual((target / "personal-file").read_text(), "Keep me.\n")
        self.assertFalse((self.home / ".zshenv").exists())


if __name__ == "__main__":
    unittest.main()
