"""Check Zsh startup in temporary homes without sourcing personal installations."""

import os
from pathlib import Path
import shlex
import shutil
import subprocess
import tempfile
import unittest


ROOT = Path(__file__).resolve().parents[1]
ZSH = shutil.which("zsh")


@unittest.skipUnless(ZSH, "Zsh is required for startup tests")
class ZshStartupTests(unittest.TestCase):
    def setUp(self):
        temporary = tempfile.TemporaryDirectory(prefix="dotfiles-zsh-")
        self.addCleanup(temporary.cleanup)
        self.home = Path(temporary.name) / "home with spaces"
        self.home.mkdir()
        shutil.copyfile(ROOT / "zsh/.zshenv", self.home / ".zshenv")
        shutil.copyfile(ROOT / "zsh/.zshrc", self.home / ".zshrc")
        self.config = self.home / ".config"
        self.cache = self.home / ".cache"
        self.install_config(self.config)
        self.env = {
            key: value for key, value in os.environ.items()
            if key not in {
                "ZDOTDIR", "ZSH", "ZSH_COMPDUMP", "ZSH_CACHE_DIR", "HISTFILE",
                "XDG_CONFIG_HOME", "XDG_CACHE_HOME", "MANPATH", "PYENV_ROOT",
                "PYENV_INITIALIZED", "P10K_CONFIG", "ENV",
            }
        }
        self.env.update(HOME=str(self.home), PATH="/usr/bin:/bin", TERM="xterm-256color")

        self.pyenv = self.home / ".local/extra/pyenv/bin/pyenv"
        self.pyenv.parent.mkdir(parents=True)
        self.pyenv.write_text(
            "#!/bin/sh\n"
            "printf 'called\\n' >> \"$HOME/pyenv.calls\"\n"
            "printf 'export PYENV_INITIALIZED=1\\n'\n"
        )
        self.pyenv.chmod(0o755)

        # Model only the framework boundary; use Zsh's real compinit and colors.
        omz = self.home / ".local/share/zsh/ohmyzsh"
        omz.mkdir(parents=True)
        (omz / "oh-my-zsh.sh").write_text(
            "OMZ_INITIALIZED=1\n"
            "STARTUP_EVENTS+=(omz)\n"
            'SHORT_HOST="${HOST%%.*}"\n'
            ': ${ZSH_COMPDUMP:=${ZDOTDIR:-$HOME}/.zcompdump-${SHORT_HOST}-${ZSH_VERSION}}\n'
            "autoload -Uz colors\n"
            "colors\n"
            "alias la='ls -a'\n"
            "alias l='ls'\n"
            "alias ll='ls -l'\n"
            "autoload -Uz compinit\n"
            'compinit -i -d "$ZSH_COMPDUMP"\n'
        )

    def install_config(self, config):
        target = config / "zsh"
        (target / "local/interactive").mkdir(parents=True)
        public = ROOT / "zsh/config/interactive"
        if public.is_dir():
            shutil.copytree(public, target / "interactive")
        else:
            (target / "interactive").mkdir()
        # Avoid consulting a Homebrew installation outside the temporary home.
        (target / "interactive/brew.zsh").write_text("STARTUP_EVENTS+=(brew)\n")

    def run_zsh(self, code, *, interactive=False):
        result = subprocess.run(
            [ZSH, "-d", "-ic" if interactive else "-c", code],
            env=self.env, cwd=self.home, capture_output=True, text=True, timeout=20,
        )
        self.assertEqual(result.returncode, 0, result.stdout + result.stderr)
        self.assertEqual(result.stderr, "", result.stderr)
        return result.stdout.strip()

    def set_load_order(self, *filenames):
        entries = "\n".join(f"    {shlex.quote(name)}" for name in filenames)
        (self.config / "zsh/local/load_order.zsh").write_text(
            f"typeset -a _load_order=(\n{entries}\n)\n"
        )

    def test_noninteractive_startup_uses_default_paths_without_initializing_pyenv(self):
        output = self.run_zsh(
            'print -r -- "${ZDOTDIR-unset}|${XDG_CONFIG_HOME-unset}|${MANPATH-}"'
        )
        self.assertEqual(output, "unset|unset|")
        self.assertFalse((self.home / "pyenv.calls").exists())

    def test_inherited_xdg_config_home_and_manpath_are_preserved(self):
        self.env.update(XDG_CONFIG_HOME=str(self.home / "custom config"), MANPATH="/custom/man:")
        output = self.run_zsh('print -r -- "$XDG_CONFIG_HOME|$MANPATH"')
        self.assertEqual(output, f"{self.home / 'custom config'}|/custom/man:")

    def test_sourcing_zshenv_again_does_not_duplicate_personal_paths(self):
        output = self.run_zsh(
            'source "$HOME/.zshenv"; '
            'integer matches=0; '
            'for directory in "${path[@]}"; do '
            '[[ "$directory" == "$HOME/.local/bin" ]] && (( matches += 1 )); '
            'done; print -r -- "$matches"'
        )
        self.assertEqual(output, "1")

    def test_interactive_startup_creates_only_the_configured_completion_dump(self):
        output = self.run_zsh(
            'print -r -- "$OMZ_INITIALIZED|$ZSH_COMPDUMP|$PYENV_INITIALIZED"',
            interactive=True,
        )
        initialized, dump, pyenv = output.split("|")
        self.assertEqual((initialized, pyenv), ("1", "1"))
        self.assertEqual(Path(dump).parent, self.cache / "zsh")
        self.assertRegex(Path(dump).name, r"^\.zcompdump-.+-.+$")
        self.assertTrue(Path(dump).is_file())
        self.assertEqual(list(self.home.glob(".zcompdump*")), [])
        self.assertEqual((self.home / "pyenv.calls").read_text(), "called\n")

    def test_custom_config_and_cache_paths_work_with_empty_optional_profiles(self):
        self.config = self.home / "custom config"
        self.cache = self.home / "custom cache"
        self.install_config(self.config)
        (self.config / "zsh/local/interactive/api.zsh").write_text("CUSTOM_PROFILE_LOADED=1\n")
        self.set_load_order("api.zsh")
        self.env.update(XDG_CONFIG_HOME=str(self.config), XDG_CACHE_HOME=str(self.cache))
        output = self.run_zsh(
            'print -r -- "$CUSTOM_PROFILE_LOADED|$ZSH_COMPDUMP"', interactive=True
        )
        loaded, dump = output.split("|")
        self.assertEqual(loaded, "1")
        self.assertEqual(Path(dump).parent, self.cache / "zsh")
        self.assertTrue(Path(dump).is_file())
        self.assertEqual(list(self.home.glob(".zcompdump*")), [])

    def test_local_environment_is_available_to_noninteractive_shells(self):
        (self.config / "zsh/local/env.zsh").write_text("export TEST_LOCAL_ENV=global\n")
        (self.config / "zsh/local/interactive/api.zsh").write_text(
            "export TEST_LOCAL_API=interactive\n"
        )
        self.set_load_order("api.zsh")
        self.assertEqual(
            self.run_zsh('print -r -- "$TEST_LOCAL_ENV|${TEST_LOCAL_API-unset}"'),
            "global|unset",
        )

    def test_local_path_changes_remain_unique_on_repeated_initialization(self):
        (self.config / "zsh/local/env.zsh").write_text('export PATH="$HOME/agent-bin:$PATH"\n')
        output = self.run_zsh(
            'source "$HOME/.zshenv"; integer matches=0; '
            'for directory in "${path[@]}"; do '
            '[[ "$directory" == "$HOME/agent-bin" ]] && (( matches += 1 )); '
            'done; print -r -- "$matches"'
        )
        self.assertEqual(output, "1")

    def test_explicit_load_order_respects_framework_and_application_dependencies(self):
        local = self.config / "zsh/local/interactive"
        (local / "credentials.zsh").write_text(
            'export TEST_LOCAL_API=available\nSTARTUP_EVENTS+=(credentials)\n'
        )
        (local / "application.zsh").write_text(
            'TEST_PROVIDER_SETTING="$TEST_LOCAL_API"\nSTARTUP_EVENTS+=(application)\n'
        )
        (local / "completion.zsh").write_text(
            '(( $+functions[compdef] )) || return 1\nSTARTUP_EVENTS+=(completion)\n'
        )
        self.set_load_order("credentials.zsh", "application.zsh", "completion.zsh")
        self.assertEqual(
            self.run_zsh(
                'print -r -- "${(j:|:)STARTUP_EVENTS}|$TEST_PROVIDER_SETTING"', interactive=True
            ),
            "brew|omz|credentials|application|completion|available",
        )

    def test_missing_load_order_file_leaves_local_scripts_unloaded(self):
        (self.config / "zsh/local/interactive/api.zsh").write_text("TEST_LOCAL_API=loaded\n")
        self.assertEqual(
            self.run_zsh('print -r -- "${TEST_LOCAL_API-unset}"', interactive=True), "unset"
        )

    def test_empty_load_order_leaves_local_scripts_unloaded(self):
        (self.config / "zsh/local/interactive/api.zsh").write_text("TEST_LOCAL_API=loaded\n")
        self.set_load_order()
        self.assertEqual(
            self.run_zsh('print -r -- "${TEST_LOCAL_API-unset}"', interactive=True), "unset"
        )

    def test_only_listed_local_scripts_are_loaded(self):
        local = self.config / "zsh/local/interactive"
        (local / "selected.zsh").write_text("TEST_SELECTED=loaded\n")
        (local / "api.zsh").write_text("TEST_UNLISTED=loaded\n")
        self.set_load_order("selected.zsh")
        self.assertEqual(
            self.run_zsh('print -r -- "$TEST_SELECTED|${TEST_UNLISTED-unset}"', interactive=True),
            "loaded|unset",
        )

    def test_missing_listed_file_is_skipped(self):
        (self.config / "zsh/local/interactive/selected.zsh").write_text("TEST_SELECTED=loaded\n")
        self.set_load_order("missing.zsh", "selected.zsh")
        self.assertEqual(
            self.run_zsh('print -r -- "$TEST_SELECTED"', interactive=True), "loaded"
        )

    def test_load_order_supports_nested_paths_with_spaces(self):
        directory = self.config / "zsh/local/interactive/team tools"
        directory.mkdir()
        (directory / "custom integration.zsh").write_text("TEST_NESTED=loaded\n")
        self.set_load_order("team tools/custom integration.zsh")
        self.assertEqual(
            self.run_zsh('print -r -- "$TEST_NESTED"', interactive=True), "loaded"
        )

    def test_public_aliases_and_functions_are_loaded(self):
        output = self.run_zsh(
            'print -r -- "${aliases[n]}|${aliases[yf]}|${+functions[yazi_chdir]}"',
            interactive=True,
        )
        self.assertEqual(output, "nvim|yazi_chdir|1")

    def test_pyenv_is_optional_for_interactive_startup(self):
        self.pyenv.unlink()
        output = self.run_zsh('print -r -- "$OMZ_INITIALIZED"', interactive=True)
        self.assertEqual(output, "1")

    def test_existing_powerlevel10k_configuration_remains_available(self):
        (self.home / ".local/share/zsh/.p10k.zsh").write_text("P10K_CONFIG=existing\n")
        self.assertEqual(
            self.run_zsh('print -r -- "$P10K_CONFIG"', interactive=True), "existing"
        )

    def test_powerlevel10k_configuration_in_home_takes_precedence(self):
        (self.home / ".local/share/zsh/.p10k.zsh").write_text("P10K_CONFIG=existing\n")
        (self.home / ".p10k.zsh").write_text("P10K_CONFIG=home\n")
        self.assertEqual(
            self.run_zsh('print -r -- "$P10K_CONFIG"', interactive=True), "home"
        )


if __name__ == "__main__":
    unittest.main()
