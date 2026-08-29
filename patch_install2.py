import re

with open('/Users/om/Desktop/Projects/Claude-Skills/install.sh', 'r') as f:
    content = f.read()

# Replace the run_step command to copy to both Antigravity and Claude Code folders
new_cmd = '"rm -rf /tmp/claude-skills-tmp && git clone --depth 1 https://github.com/omspradippatil/Claude-Skills.git /tmp/claude-skills-tmp && mkdir -p \\"$SKILLS_DIR\\" \\"$AGENTS_DIR\\" && cp -r /tmp/claude-skills-tmp/.agents/skills/ultimate-* \\"$SKILLS_DIR/\\" && cp -r /tmp/claude-skills-tmp/.agents/skills/ultimate-* \\"$AGENTS_DIR/\\" && rm -rf /tmp/claude-skills-tmp"'

content = re.sub(r'"rm -rf /tmp/claude-skills-tmp.*?"', new_cmd, content, flags=re.DOTALL)

# Add AGENTS_DIR to set_scope
scope_local = """
    SKILLS_DIR="$(pwd)/.claude/skills"
    AGENTS_DIR="$(pwd)/.agents/skills"
    mkdir -p "$SKILLS_DIR" "$AGENTS_DIR"
"""

scope_global = """
    SKILLS_DIR="$HOME/.claude/skills"
    AGENTS_DIR="$HOME/.gemini/config/skills"
    mkdir -p "$SKILLS_DIR" "$AGENTS_DIR"
"""

content = re.sub(r'SKILLS_DIR="\$\(pwd\)/\.claude/skills"\n\s+mkdir -p "\$SKILLS_DIR" "\$\(pwd\)/\.agent/skills"', scope_local.strip(), content)

content = re.sub(r'SKILLS_DIR="\$HOME/\.claude/skills"\n\s+mkdir -p "\$SKILLS_DIR"', scope_global.strip(), content)

# Also fix the initial global definition at the top
content = re.sub(r'SKILLS_DIR="\$HOME/\.claude/skills"', 'SKILLS_DIR="$HOME/.claude/skills"\nAGENTS_DIR="$HOME/.gemini/config/skills"', content, count=1)

with open('/Users/om/Desktop/Projects/Claude-Skills/install.sh', 'w') as f:
    f.write(content)
