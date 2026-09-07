import re

with open('/Users/om/Desktop/Projects/Claude-Skills/install.sh', 'r') as f:
    content = f.read()

# Update AGENTS_RULES_DIR
scope_local = """
    SKILLS_DIR="$(pwd)/.claude/skills"
    AGENTS_DIR="$(pwd)/.agents/skills"
    AGENTS_RULES_DIR="$(pwd)/.agents/rules"
    mkdir -p "$SKILLS_DIR" "$AGENTS_DIR" "$AGENTS_RULES_DIR"
"""

scope_global = """
    SKILLS_DIR="$HOME/.claude/skills"
    AGENTS_DIR="$HOME/.gemini/config/skills"
    AGENTS_RULES_DIR="$HOME/.gemini/config/rules"
    mkdir -p "$SKILLS_DIR" "$AGENTS_DIR" "$AGENTS_RULES_DIR"
"""

content = re.sub(r'SKILLS_DIR="\$\(pwd\)/\.claude/skills"\n\s+AGENTS_DIR="\$\(pwd\)/\.agents/skills"\n\s+mkdir -p "\$SKILLS_DIR" "\$AGENTS_DIR"', scope_local.strip(), content)
content = re.sub(r'SKILLS_DIR="\$HOME/\.claude/skills"\n\s+AGENTS_DIR="\$HOME/\.gemini/config/skills"\n\s+mkdir -p "\$SKILLS_DIR" "\$AGENTS_DIR"', scope_global.strip(), content)

# Fix top level definition
content = re.sub(r'SKILLS_DIR="\$HOME/\.claude/skills"\nAGENTS_DIR="\$HOME/\.gemini/config/skills"', 'SKILLS_DIR="$HOME/.claude/skills"\nAGENTS_DIR="$HOME/.gemini/config/skills"\nAGENTS_RULES_DIR="$HOME/.gemini/config/rules"', content)

# Update the copy command
old_cmd = r'mkdir -p "\$SKILLS_DIR" "\$AGENTS_DIR" && cp -r /tmp/claude-skills-tmp/\.agents/skills/ultimate-\* "\$SKILLS_DIR/" && cp -r /tmp/claude-skills-tmp/\.agents/skills/ultimate-\* "\$AGENTS_DIR/"'
new_cmd = r'mkdir -p "$SKILLS_DIR" "$AGENTS_DIR" "$AGENTS_RULES_DIR" && cp -r /tmp/claude-skills-tmp/.agents/skills/ultimate-* "$SKILLS_DIR/" && cp -r /tmp/claude-skills-tmp/.agents/skills/ultimate-* "$AGENTS_DIR/" && cp -r /tmp/claude-skills-tmp/.agents/rules/*.md "$AGENTS_RULES_DIR/" 2>/dev/null || true'
content = content.replace('mkdir -p "$SKILLS_DIR" "$AGENTS_DIR" && cp -r /tmp/claude-skills-tmp/.agents/skills/ultimate-* "$SKILLS_DIR/" && cp -r /tmp/claude-skills-tmp/.agents/skills/ultimate-* "$AGENTS_DIR/"', new_cmd)

# Make sure to update 21 ULTIMATE DOMAIN SKILLS header to "19 SKILLS & 2 ALWAYS-ON RULES"
content = content.replace('21 ULTIMATE DOMAIN SKILLS', '19 SKILLS & 2 ALWAYS-ON RULES')
content = content.replace('21 Ultimate Domain Skills', '19 Ultimate Skills & 2 Rules')

with open('/Users/om/Desktop/Projects/Claude-Skills/install.sh', 'w') as f:
    f.write(content)

with open('/Users/om/Desktop/Projects/Claude-Skills/README.md', 'r') as f:
    readme = f.read()

readme = readme.replace('21+ Ultimate Skills', '19 Ultimate Skills & 2 Always-On Rules')
readme = readme.replace('21+ Ultimate Domain Skills', '19 Ultimate Domain Skills')
readme = readme.replace('21 Ultimate Domain Skills', '19 Ultimate Skills & 2 Rules')

with open('/Users/om/Desktop/Projects/Claude-Skills/README.md', 'w') as f:
    f.write(readme)
