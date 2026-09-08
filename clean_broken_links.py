import os
import re

base_dir = "/Users/om/Desktop/Projects/Claude-Skills/.agents/skills"

# Patterns for replacement
replacements = [
    # Devops node:builder
    (r'node:builder', r'node:18-alpine AS builder'),
    
    # Generic references to plays/ templates/ references/
    (r'by following the full procedure in `?plays/[a-zA-Z0-9_-]+\.md`?', r'by following secure code review best practices'),
    (r'Use the finding format from `?templates/finding\.md`?', r'Use a structured vulnerability finding format (Severity, Description, Impact, Recommendation)'),
    (r'using `?templates/finding\.md`?', r'using a structured format'),
    (r'detailed procedure in `?plays/[a-zA-Z0-9_-]+\.md`?', r'detailed OWASP guidelines'),
    (r'following `?plays/[a-zA-Z0-9_-]+\.md`?', r'following standard security guidelines'),
    (r'See \[.*?\]\(references/.*?\)', r'Consult official documentation'),
    (r'See \[`?references/.*?\`?\]\(references/.*?\)', r'Consult official documentation'),
    (r'Read \[.*?\]\(references/.*?\)', r'Review the official documentation'),
    
    # Markdown links stripping [Text](references/...)
    (r'\[([^\]]+)\]\(references/[^\)]+\)', r'\1'),
    (r'\[([^\]]+)\]\(plays/[^\)]+\)', r'\1'),
    (r'\[([^\]]+)\]\(templates/[^\)]+\)', r'\1'),

    # Bare references like `references/first-error-setup.md`
    (r'`?references/[a-zA-Z0-9_/-]+\.md`?', r'official guidelines'),
    (r'`?plays/[a-zA-Z0-9_/-]+\.md`?', r'standard procedures'),
    (r'`?templates/[a-zA-Z0-9_/-]+\.md`?', r'standard templates'),

    # Specific phrases left over
    (r'Read official guidelines,?', r'Read official documentation'),
    (r'See official guidelines\.', r'See official documentation.'),
    (r'under `?references/enterprise/`?', r'for Enterprise versions'),
    (r'under `?references/standard/`?', r'for Standard versions'),
    (r'under `?references/concepts/`?', r'in the concept guides'),
]

for root, _, files in os.walk(base_dir):
    for file in files:
        if file.endswith("SKILL.md"):
            filepath = os.path.join(root, file)
            with open(filepath, 'r', encoding='utf-8') as f:
                content = f.read()
            
            original = content
            for pattern, repl in replacements:
                content = re.sub(pattern, repl, content, flags=re.IGNORECASE)
            
            # Post-cleanup for some ugly leftovers
            # e.g., "official guidelines, official guidelines, or official guidelines"
            content = re.sub(r'official guidelines(?:, official guidelines)+, or official guidelines', 'the official documentation', content)
            content = re.sub(r'Review the official documentation,?\s*\n?\s*Review the official documentation,?\s*\n?\s*or\s*\n?\s*Review the official documentation', 'Review the official SDK documentation', content)
            
            if content != original:
                with open(filepath, 'w', encoding='utf-8') as f:
                    f.write(content)
                print(f"Cleaned links in {filepath}")

