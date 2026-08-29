import re

with open('/Users/om/Desktop/Projects/Claude-Skills/install.sh', 'r') as f:
    content = f.read()

# Replace all the individual install functions with one streamlined one
new_install_func = """
# ==============================================================================
# INSTALLATION FUNCTIONS (ZERO BLOAT)
# ==============================================================================

install_ultimate_skills() {
  print_header "🚀 INSTALLING 14 ULTIMATE DOMAIN SKILLS"
  
  run_step "Downloading Ultimate Skills" \\
    "Cloning the consolidated zero-bloat Ultimate Skills directly from the source repository." \\
    "rm -rf /tmp/claude-skills-tmp && git clone --depth 1 https://github.com/omspradippatil/Claude-Skills.git /tmp/claude-skills-tmp && mkdir -p $SKILLS_DIR && cp -r /tmp/claude-skills-tmp/.agents/skills/ultimate-* $SKILLS_DIR/ && rm -rf /tmp/claude-skills-tmp"
}
"""

content = re.sub(r'# ==============================================================================\n# INSTALLATION FUNCTIONS.*?# ==============================================================================\n# UNINSTALLATION', new_install_func + '\n# ==============================================================================\n# UNINSTALLATION', content, flags=re.DOTALL)

# Update the main case statement to just call the single ultimate function
content = re.sub(r'install_core_ui_ux.*?install_code_quality_skills', 'install_ultimate_skills', content, flags=re.DOTALL)

with open('/Users/om/Desktop/Projects/Claude-Skills/install.sh', 'w') as f:
    f.write(content)
