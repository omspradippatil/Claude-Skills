import os
import shutil
import re

base_dir = "/Users/om/Desktop/Projects/Claude-Skills"
skills_dir = os.path.join(base_dir, ".agents/skills")
rules_dir = os.path.join(base_dir, ".agents/rules")

os.makedirs(rules_dir, exist_ok=True)

# 1. Move the two behavioral skills to rules
rules_to_move = ['ultimate-engineering-discipline', 'ultimate-persistent-memory']

for rule in rules_to_move:
    src_folder = os.path.join(skills_dir, rule)
    src_file = os.path.join(src_folder, "SKILL.md")
    dest_file = os.path.join(rules_dir, f"{rule}.md")
    
    if os.path.exists(src_file):
        with open(src_file, "r") as f:
            content = f.read()
        
        # Add trigger: always_on to the frontmatter
        if "trigger: always_on" not in content:
            content = content.replace("---\n\n", "trigger: always_on\n---\n\n", 1)
            # If no double newline after frontmatter, fallback:
            content = content.replace("---\n#", "trigger: always_on\n---\n\n#", 1)
            
        with open(dest_file, "w") as f:
            f.write(content)
        
        shutil.rmtree(src_folder)

# 2. Update remaining skills with hyper-optimized AI routing descriptions
optimized_descriptions = {
    "ultimate-3d-visuals": "Activate this skill for tasks involving Three.js, WebGL, shaders, 3D models, canvas rendering, or spatial visuals.",
    "ultimate-api-architecture": "Activate this skill when designing REST/GraphQL APIs, Node.js/Python backends, microservices, auth, or caching middleware.",
    "ultimate-assets-media": "Activate this skill to optimize images (WebP/AVIF), fonts, lazy loading, and media performance on the web.",
    "ultimate-cloudflare-expert": "Activate this skill for Cloudflare Workers, Edge functions, D1 databases, R2 storage, or Wrangler deployments.",
    "ultimate-devops-cicd": "Activate this skill for tasks involving GitHub Actions, Docker, CI/CD pipelines, containerization, or deployment workflows.",
    "ultimate-firebase-expert": "Activate this skill for Firebase/Firestore schema design, Security Rules, Cloud Functions, or Firebase Auth.",
    "ultimate-frontend-design": "Activate this skill for UI/UX tasks, CSS styling, layout building, component design, or aesthetic improvements.",
    "ultimate-git-collaboration": "Activate this skill for Git branching strategies, resolving merge conflicts, conventional commits, or PR creation.",
    "ultimate-llm-optimization": "Activate this skill when writing prompts, designing AI agents, or optimizing LLM context and token usage.",
    "ultimate-mobile-engineering": "Activate this skill for mobile app development, React Native, Flutter, Swift, native bridges, or mobile UX.",
    "ultimate-postgres-ecosystem": "Activate this skill for PostgreSQL, Supabase, Neon databases, complex SQL queries, migrations, or Row Level Security (RLS).",
    "ultimate-security-auditor": "Activate this skill to perform OWASP security audits, penetration testing, threat modeling, or securing endpoints.",
    "ultimate-sentry-expert": "Activate this skill for error tracking, telemetry, performance monitoring, or configuring Sentry SDKs.",
    "ultimate-seo-marketing": "Activate this skill for technical SEO, core web vitals, meta tags, OpenGraph, or JSON-LD structured data.",
    "ultimate-state-management": "Activate this skill for complex frontend state, React Query/SWR data fetching, Zustand/Redux global stores, or XState.",
    "ultimate-testing-qa": "Activate this skill for writing unit tests, TDD, Playwright E2E tests, Jest, or stabilizing flaky test suites.",
    "ultimate-ux-research": "Activate this skill for user discovery, usability heuristics, reducing cognitive load, or UX copywriting.",
    "ultimate-web-animation": "Activate this skill for UI motion, Framer Motion, GSAP, CSS keyframes, spring physics, or scroll-scrubbed animations.",
    "ultimate-web-gamedev": "Activate this skill for HTML5 canvas games, game loops, physics engines (Matter.js), or sprite rendering."
}

for item in os.listdir(skills_dir):
    skill_path = os.path.join(skills_dir, item, "SKILL.md")
    if os.path.exists(skill_path):
        if item in optimized_descriptions:
            with open(skill_path, "r") as f:
                content = f.read()
            
            new_desc = optimized_descriptions[item]
            # Replace the existing description in frontmatter
            content = re.sub(r'description:\s*.*?\n---', f'description: {new_desc}\n---', content, flags=re.DOTALL)
            
            with open(skill_path, "w") as f:
                f.write(content)

# Update index.html array for the two rules removal (they shouldn't be in the skills directory array, maybe we label them as rules)
with open(os.path.join(base_dir, "index.html"), "r") as f:
    html = f.read()
    
# We will just change the title text to reflect 19 Skills and 2 Rules
html = html.replace('21+ Ultimate Master Skills', '19 Ultimate Skills + 2 Always-On Rules')
with open(os.path.join(base_dir, "index.html"), "w") as f:
    f.write(html)

