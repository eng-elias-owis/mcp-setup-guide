# Node.js & React Development Guide

Complete guide for using MCP agents with Node.js and React applications.

## Available Agents

### 1. Node.js/React PR Reviewer
**File:** `.claude/agents/nodejs-react-pr-reviewer.md`

Specialized for reviewing JS/TS PRs:
- Unhandled promises in Node.js
- React hooks (dependencies, rules)
- TypeScript types
- Security (XSS, injection)
- Performance (re-renders, N+1 queries)
- Testing requirements

**Use:**
```bash
Switch to nodejs-react-pr-reviewer agent
"Review PR #123 in my-react-app"
```

### 2. Node.js/React SonarQube Agent
**File:** `.claude/agents/nodejs-react-sonar-agent.md`

Specialized for JS/TS code quality:
- SonarQube JS/TS rules (S2966, S2078, S2068, etc.)
- React-specific issues (S5743, S3800, S6480)
- TypeScript issues (S3649, S4204, S4324)
- Concrete fixes with before/after code

**Use:**
```bash
Switch to nodejs-react-sonar-agent agent
"Get all critical JS issues in myapp project"
```

### 3. Tech Lead (Node.js/React)
**File:** `.claude/agents/tech-lead.md`

Architecture decisions:
- API design (REST, GraphQL)
- State management (Redux, Zustand, React Query)
- Database schema decisions
- Component architecture
- Testing strategy

**Use:**
```bash
Switch to tech-lead agent
"Review architecture for new payment service"
```

---

## Common Workflows

### Workflow 1: Review React PR with SonarQube

```bash
# Step 1: PR Review
Switch to nodejs-react-pr-reviewer agent
"Review PR #456 in frontend repo"

# Agent:
# - Gets PR changes from GitHub
# - Fetches SonarQube analysis
# - Reads affected React components
# - Finds: Missing hook dependency, unused import
# - Suggests fixes

# Step 2: Deep dive into issues
Switch to nodejs-react-sonar-agent
"Get details for issue AX123 about useEffect dependencies"
"Read src/components/UserProfile.tsx lines 45-60"
"Suggest fix for missing dependency"

# Step 3: Create ticket if needed
Switch to jira-api-agent
"Create ticket to refactor useAuth hook"
```

### Workflow 2: Fix Node.js Security Issues

```bash
# Step 1: Find security issues
Switch to nodejs-react-sonar-agent
"Get all security vulnerabilities in backend project"

# Step 2: Read affected code
"Read src/server/routes/auth.ts around line 30"

# Step 3: Understand and fix
"SQL injection issue - show me how to fix with Prisma"
"Hardcoded JWT secret - show me environment variable approach"

# Step 4: Verify fix
"Check if there are similar issues in other files"
```

### Workflow 3: Architecture Review

```bash
# Step 1: Discuss architecture
Switch to tech-lead agent
"Should we use Redux or Zustand for global state?"
"Review proposed API structure for /api/orders"

# Step 2: Document decision
Switch to confluence-api-agent
"Create ADR 'State Management Decision' in TECH space"

# Step 3: Implementation guidance
"Provide example Zustand store for user auth"
```

---

## Node.js Specific Patterns

### Error Handling Pattern

```typescript
// src/server/middleware/errorHandler.ts
import { Request, Response, NextFunction } from 'express';

export class AppError extends Error {
    constructor(
        message: string,
        public statusCode: number,
        public code: string
    ) {
        super(message);
    }
}

export const errorHandler = (
    err: Error | AppError,
    req: Request,
    res: Response,
    next: NextFunction
) => {
    if (err instanceof AppError) {
        return res.status(err.statusCode).json({
            error: err.message,
            code: err.code
        });
    }
    
    // Log unexpected errors
    logger.error('Unexpected error', err);
    res.status(500).json({
        error: 'Internal server error',
        code: 'INTERNAL_ERROR'
    });
};

// Usage in routes
app.get('/users/:id', async (req, res, next) => {
    try {
        const user = await getUser(req.params.id);
        if (!user) {
            throw new AppError('User not found', 404, 'USER_NOT_FOUND');
        }
        res.json(user);
    } catch (error) {
        next(error);
    }
});
```

### Database Pattern (Prisma)

```typescript
// src/server/db/prisma.ts
import { PrismaClient } from '@prisma/client';

const prisma = new PrismaClient({
    log: process.env.NODE_ENV === 'development' 
        ? ['query', 'info', 'warn', 'error']
        : ['error']
});

// Graceful shutdown
process.on('SIGINT', async () => {
    await prisma.$disconnect();
    process.exit(0);
});

export default prisma;

// Usage
import prisma from './db/prisma';

const user = await prisma.user.findUnique({
    where: { id: userId },
    include: { orders: true }
});
```

---

## React Specific Patterns

### Custom Hook Pattern

```typescript
// src/hooks/useAuth.ts
import { useState, useEffect, useCallback } from 'react';
import { User } from '../types';

export function useAuth() {
    const [user, setUser] = useState<User | null>(null);
    const [loading, setLoading] = useState(true);
    
    useEffect(() => {
        const token = localStorage.getItem('token');
        if (token) {
            fetchUser(token).then(setUser).finally(() => setLoading(false));
        } else {
            setLoading(false);
        }
    }, []);
    
    const login = useCallback(async (email: string, password: string) => {
        const { user, token } = await api.login(email, password);
        localStorage.setItem('token', token);
        setUser(user);
        return user;
    }, []);
    
    const logout = useCallback(() => {
        localStorage.removeItem('token');
        setUser(null);
    }, []);
    
    return { user, loading, login, logout };
}
```

### Component Pattern

```tsx
// src/components/UserCard/UserCard.tsx
import { memo } from 'react';
import { User } from '../../types';
import styles from './UserCard.module.css';

interface UserCardProps {
    user: User;
    onEdit: (user: User) => void;
}

export const UserCard = memo(function UserCard({ user, onEdit }: UserCardProps) {
    return (
        <div className={styles.card}>
            <img 
                src={user.avatar} 
                alt={user.name}
                className={styles.avatar}
                loading="lazy"
            />
            <h3 className={styles.name}>{user.name}</h3>
            <p className={styles.email}>{user.email}</p>
            <button 
                onClick={() => onEdit(user)}
                className={styles.editButton}
            >
                Edit
            </button>
        </div>
    );
});
```

---

## TypeScript Configuration

### Recommended tsconfig.json

```json
{
    "compilerOptions": {
        "target": "ES2022",
        "module": "ESNext",
        "moduleResolution": "node",
        "strict": true,
        "esModuleInterop": true,
        "skipLibCheck": true,
        "forceConsistentCasingInFileNames": true,
        "resolveJsonModule": true,
        "declaration": true,
        "declarationMap": true,
        "sourceMap": true,
        "outDir": "./dist",
        "rootDir": "./src",
        "noImplicitAny": true,
        "strictNullChecks": true,
        "strictFunctionTypes": true,
        "noUnusedLocals": true,
        "noUnusedParameters": true,
        "noImplicitReturns": true,
        "noFallthroughCasesInSwitch": true,
        "jsx": "react-jsx"
    },
    "include": ["src/**/*"],
    "exclude": ["node_modules", "dist", "**/*.test.ts"]
}
```

---

## ESLint Configuration

### Recommended .eslintrc.json

```json
{
    "extends": [
        "eslint:recommended",
        "@typescript-eslint/recommended",
        "plugin:react/recommended",
        "plugin:react-hooks/recommended",
        "plugin:jsx-a11y/recommended"
    ],
    "parser": "@typescript-eslint/parser",
    "parserOptions": {
        "ecmaVersion": 2022,
        "sourceType": "module",
        "ecmaFeatures": {
            "jsx": true
        }
    },
    "plugins": [
        "@typescript-eslint",
        "react",
        "react-hooks",
        "jsx-a11y"
    ],
    "rules": {
        "react/react-in-jsx-scope": "off",
        "react/prop-types": "off",
        "@typescript-eslint/explicit-function-return-type": "warn",
        "@typescript-eslint/no-unused-vars": ["error", { "argsIgnorePattern": "^_" }],
        "react-hooks/rules-of-hooks": "error",
        "react-hooks/exhaustive-deps": "warn"
    },
    "settings": {
        "react": {
            "version": "detect"
        }
    }
}
```

---

## Testing Patterns

### Node.js API Test

```typescript
// src/server/routes/users.test.ts
import request from 'supertest';
import { app } from '../app';
import { prisma } from '../db/prisma';

describe('GET /api/users', () => {
    afterEach(async () => {
        await prisma.user.deleteMany();
    });
    
    it('returns all users', async () => {
        await prisma.user.create({
            data: { email: 'test@example.com', name: 'Test' }
        });
        
        const response = await request(app)
            .get('/api/users')
            .expect(200);
        
        expect(response.body).toHaveLength(1);
        expect(response.body[0].email).toBe('test@example.com');
    });
    
    it('handles database errors', async () => {
        jest.spyOn(prisma.user, 'findMany').mockRejectedValue(
            new Error('DB error')
        );
        
        const response = await request(app)
            .get('/api/users')
            .expect(500);
        
        expect(response.body.error).toBe('Internal server error');
    });
});
```

### React Component Test

```tsx
// src/components/UserProfile.test.tsx
import { render, screen, fireEvent } from '@testing-library/react';
import userEvent from '@testing-library/user-event';
import { UserProfile } from './UserProfile';
import { User } from '../types';

const mockUser: User = {
    id: '1',
    name: 'John Doe',
    email: 'john@example.com'
};

describe('UserProfile', () => {
    it('renders user information', () => {
        render(<UserProfile user={mockUser} onUpdate={jest.fn()} />);
        
        expect(screen.getByText('John Doe')).toBeInTheDocument();
        expect(screen.getByText('john@example.com')).toBeInTheDocument();
    });
    
    it('enters edit mode when clicking edit', async () => {
        render(<UserProfile user={mockUser} onUpdate={jest.fn()} />);
        
        await userEvent.click(screen.getByText('Edit'));
        
        expect(screen.getByLabelText('Name')).toHaveValue('John Doe');
        expect(screen.getByText('Save')).toBeInTheDocument();
    });
    
    it('calls onUpdate with new values', async () => {
        const onUpdate = jest.fn();
        render(<UserProfile user={mockUser} onUpdate={onUpdate} />);
        
        await userEvent.click(screen.getByText('Edit'));
        await userEvent.clear(screen.getByLabelText('Name'));
        await userEvent.type(screen.getByLabelText('Name'), 'Jane Doe');
        await userEvent.click(screen.getByText('Save'));
        
        expect(onUpdate).toHaveBeenCalledWith({
            ...mockUser,
            name: 'Jane Doe'
        });
    });
});
```

---

## Quick Commands

### Review Node.js PR:
```bash
Switch to nodejs-react-pr-reviewer agent
"Review PR #123 in backend - check for unhandled promises and SQL injection"
```

### Fix React Issues:
```bash
Switch to nodejs-react-sonar-agent
"Get all React hook issues in frontend project"
"Suggest fixes for missing useEffect dependencies"
```

### Architecture Decision:
```bash
Switch to tech-lead agent
"Compare Redux vs Zustand for our e-commerce app state management"
```

### Check Test Coverage:
```bash
Switch to nodejs-react-sonar-agent
"What's the coverage for new files in PR #456?"
"Which functions need tests?"
```

---

## Integration with Other Tools

### GitHub + SonarQube + JIRA
```bash
# 1. Review PR with quality check
nodejs-react-pr-reviewer → Review PR → Get Sonar issues

# 2. Create tickets for blockers
jira-api-agent → Create "Fix SQL injection" ticket

# 3. Document in Confluence
confluence-api-agent → Create "Security Review" page
```

---

## Common SonarQube Rules for JS/React

| Rule | Description | Fix Priority |
|------|-------------|--------------|
| S2966 | Unhandled promise | 🔴 Critical |
| S2078 | SQL injection | 🔴 Critical |
| S2068 | Hardcoded credentials | 🔴 Blocker |
| S5334 | Insecure HTTP | 🔴 Critical |
| S5743 | XSS (dangerouslySetInnerHTML) | 🔴 Blocker |
| S3800 | Missing key prop | 🟠 Major |
| S6480 | Hook missing deps | 🟠 Major |
| S4204 | Usage of 'any' | 🟠 Major |
| S3776 | Cognitive complexity | 🟡 Minor |
| S1481 | Unused import | 🟡 Minor |

---

## Next Steps

1. Use `nodejs-react-pr-reviewer` for PR reviews
2. Use `nodejs-react-sonar-agent` for code quality issues
3. Use `tech-lead` for architecture decisions
4. Combine with other agents for full workflow

**All agents are ready in `.claude/agents/` directory!**
