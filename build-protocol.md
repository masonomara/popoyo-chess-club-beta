# 60-Minute Build Protocol

> The complete reference for every step of the build.

---

## Project Setup

Do all of this before starting the timer.

```bash
# Create the Next.js app in the project folder
npx create-next-app@latest .

# Choose your own preferences. I prefer the following:
Would you like to use TypeScript?
> Yes
Which linter would you like to use?
> ESLint
Would you like to use React Compiler?
> Yes
Would you like to use Tailwind CSS?
> No
Would you like your code inside a `src/` directory?
> No
Would you like to use App Router? (recommended)
> Yes
Would you like to customize the import alias (`@/*` by default)?
> No
Would you like to include AGENTS.md to guide coding agents to write up-to-date Next.js code?
> No
```

```bash
# Initialize git
git init
git add .
git commit -m "init"

# Create GitHub repo and push
gh repo create [project-name] --public --push --source=.

# Copy this protocol repo's files into your project
cp path/to/claude.md .
cp path/to/templates/goal.md .
cp -r path/to/.claude
```

**Checklist:**

- [ ] Next.js project created
- [ ] Git initialized and first commit made
- [ ] Public GitHub repo created and pushed
- [ ] `claude.md` copied to project root
- [ ] `goal.md` copied to project root
- [ ] `.claude/commands/` copied to project

