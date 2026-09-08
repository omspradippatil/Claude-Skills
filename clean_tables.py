import os
import re

base_dir = "/Users/om/Desktop/Projects/Claude-Skills/.agents/skills"

for root, _, files in os.walk(base_dir):
    for file in files:
        if file.endswith("SKILL.md"):
            filepath = os.path.join(root, file)
            with open(filepath, 'r', encoding='utf-8') as f:
                lines = f.readlines()
            
            new_lines = []
            for line in lines:
                # If it's a table row or just a list item pointing to 'references/', skip it.
                if 'references/' in line or 'plays/' in line or 'templates/' in line:
                    continue
                new_lines.append(line)
                
            if len(new_lines) != len(lines):
                with open(filepath, 'w', encoding='utf-8') as f:
                    f.writelines(new_lines)
                print(f"Cleaned tables/lists in {filepath}")

