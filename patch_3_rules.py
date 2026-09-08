import os

base_dir = "/Users/om/Desktop/Projects/Claude-Skills"

# Update index.html
with open(os.path.join(base_dir, "index.html"), "r") as f:
    html = f.read()
html = html.replace('19 Ultimate Skills + 2 Always-On Rules', '19 Ultimate Skills + 3 Always-On Rules')
with open(os.path.join(base_dir, "index.html"), "w") as f:
    f.write(html)

# Update README.md
with open(os.path.join(base_dir, "README.md"), "r") as f:
    readme = f.read()
readme = readme.replace('19 Ultimate Skills & 2 Always-On Rules', '19 Ultimate Skills & 3 Always-On Rules')
readme = readme.replace('19 Ultimate Skills & 2 Rules', '19 Ultimate Skills & 3 Rules')
with open(os.path.join(base_dir, "README.md"), "w") as f:
    f.write(readme)

# Update install.sh
with open(os.path.join(base_dir, "install.sh"), "r") as f:
    install = f.read()
install = install.replace('19 SKILLS & 2 ALWAYS-ON RULES', '19 SKILLS & 3 ALWAYS-ON RULES')
install = install.replace('19 Ultimate Skills & 2 Rules', '19 Ultimate Skills & 3 Rules')
with open(os.path.join(base_dir, "install.sh"), "w") as f:
    f.write(install)

