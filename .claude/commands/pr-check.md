# /pr-check

Check a pull request's quality, tests, and SonarQube status before merging.

## Usage

```
/pr-check 123
/pr-check 123 --backend
```

## Steps

1. Fetch PR details from GitHub
2. Get list of changed files
3. Check SonarQube quality gate
4. Review code changes
5. Verify tests exist
6. Summarize findings

## Output

- PR title and author
- Changed files summary
- SonarQube status
- Issues found (if any)
- Ready to merge: YES/NO

## Example

```
> /pr-check 456

📋 PR #456: Fix authentication bug
👤 Author: @john.doe

📁 Files changed: 5
- src/auth/login.js
- src/auth/session.js
- tests/auth.test.js

🔍 SonarQube: ✅ PASS
   - Coverage: 85% (target: 80%)
   - Issues: 0 critical, 1 minor

⚠️  Minor issue found:
   src/auth/login.js:42 - Consider adding input validation

✅ Ready to merge: YES
```
