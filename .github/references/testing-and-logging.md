# Testing & Logging Reference

Essential patterns for structured logging and comprehensive testing.

---

## Part 1: Logging with structlog

### Setup

```python
# app/logging_config.py
import logging
import structlog
import os
import sys

def configure_logging():
    """Configure structlog - JSON for production, pretty for dev."""
    use_json = (
        os.environ.get("LOG_JSON", "false").lower() == "true"
        or not sys.stderr.isatty()
    )

    shared_processors = [
        structlog.contextvars.merge_contextvars,
        structlog.processors.add_log_level,
        structlog.processors.TimeStamper(fmt="iso"),
    ]

    if use_json:
        processors = shared_processors + [
            structlog.processors.dict_tracebacks,
            structlog.processors.JSONRenderer(),
        ]
    else:
        processors = shared_processors + [
            structlog.dev.ConsoleRenderer(colors=True),
        ]

    structlog.configure(
        processors=processors,
        wrapper_class=structlog.make_filtering_bound_logger(logging.INFO),
        context_class=dict,
        logger_factory=structlog.PrintLoggerFactory(),
        cache_logger_on_first_use=True,
    )
```

### FastAPI Integration

```python
# app/middleware.py
import time
import uuid
import structlog
from starlette.middleware.base import BaseHTTPMiddleware

logger = structlog.get_logger()

class LoggingMiddleware(BaseHTTPMiddleware):
    async def dispatch(self, request, call_next):
        structlog.contextvars.clear_contextvars()
        request_id = str(uuid.uuid4())

        structlog.contextvars.bind_contextvars(
            request_id=request_id,
            method=request.method,
            path=request.url.path,
        )

        start = time.perf_counter()
        response = await call_next(request)
        duration_ms = (time.perf_counter() - start) * 1000

        logger.info("request_completed", status=response.status_code, duration_ms=round(duration_ms, 2))
        response.headers["X-Request-ID"] = request_id
        return response
```

### Usage

```python
logger = structlog.get_logger()

# Basic logging
logger.info("User logged in", user_id=42)

# With context binding
logger = logger.bind(component="auth")
logger.info("Token validated")  # Includes component="auth"

# Temporary context
with structlog.contextvars.bound_contextvars(operation="checkout"):
    logger.info("Processing payment")
```

---

## Part 2: Testing Strategy

### Testing Pyramid

| Layer | % | Speed | Scope |
|-------|---|-------|-------|
| Unit | 70% | ms | Single function |
| Integration | 20% | seconds | Multiple components |
| E2E | 10% | minutes | Full system |

---

## Python Testing (pytest)

### Conftest Setup

```python
# tests/conftest.py
import pytest
from fastapi.testclient import TestClient
from sqlalchemy import create_engine, StaticPool
from sqlalchemy.orm import sessionmaker

from app.main import app
from app.database import Base, get_db

@pytest.fixture
def db_session():
    engine = create_engine(
        "sqlite:///:memory:",
        connect_args={"check_same_thread": False},
        poolclass=StaticPool,
    )
    Base.metadata.create_all(engine)
    Session = sessionmaker(bind=engine)

    with Session() as session:
        yield session

@pytest.fixture
def client(db_session):
    def override_get_db():
        yield db_session

    app.dependency_overrides[get_db] = override_get_db
    with TestClient(app) as c:
        yield c
    app.dependency_overrides.clear()
```

### Unit Tests

```python
# tests/unit/test_service.py
import pytest

class TestStreakCalculation:
    def test_empty_completions_returns_zero(self):
        assert calculate_streak([]) == 0

    @pytest.mark.parametrize("completions,expected", [
        ([], 0),
        ([date(2025, 1, 1)], 1),
        ([date(2025, 1, 1), date(2025, 1, 2)], 2),
    ])
    def test_streak_calculation(self, completions, expected):
        assert calculate_streak(completions) == expected
```

### Integration Tests

```python
# tests/integration/test_api.py
def test_create_resource(client):
    response = client.post("/api/items", json={"name": "Test"})
    assert response.status_code == 201
    assert response.json()["name"] == "Test"

def test_not_found(client):
    response = client.get("/api/items/99999")
    assert response.status_code == 404
```

---

## React Testing (Vitest)

### Setup

```javascript
// vite.config.js
export default defineConfig({
  test: {
    globals: true,
    environment: 'jsdom',
    setupFiles: './src/test/setup.js',
  },
});

// src/test/setup.js
import '@testing-library/jest-dom';
```

### Component Tests

```javascript
import { render, screen } from '@testing-library/react';
import userEvent from '@testing-library/user-event';

describe('Button', () => {
  it('renders text', () => {
    render(<Button>Click me</Button>);
    expect(screen.getByRole('button')).toHaveTextContent('Click me');
  });

  it('calls onClick', async () => {
    const onClick = vi.fn();
    render(<Button onClick={onClick}>Click</Button>);
    await userEvent.click(screen.getByRole('button'));
    expect(onClick).toHaveBeenCalled();
  });
});
```

### Testing with Providers

```javascript
// src/test/utils.jsx
import { QueryClient, QueryClientProvider } from '@tanstack/react-query';
import { BrowserRouter } from 'react-router-dom';

export function renderWithProviders(ui) {
  const queryClient = new QueryClient({
    defaultOptions: { queries: { retry: false } },
  });
  return render(
    <QueryClientProvider client={queryClient}>
      <BrowserRouter>{ui}</BrowserRouter>
    </QueryClientProvider>
  );
}
```

### Query Priority (use in order)

1. `getByRole` - Best (accessible)
2. `getByLabelText` - Forms
3. `getByText` - Content
4. `getByTestId` - Last resort

---

## E2E Testing (Playwright)

### Basic Test

```javascript
// tests/e2e/app.spec.js
import { test, expect } from '@playwright/test';

test('user can create item', async ({ page }) => {
  await page.goto('/');
  await page.getByRole('button', { name: /add/i }).click();
  await page.getByLabel('Name').fill('Test Item');
  await page.getByRole('button', { name: /save/i }).click();
  await expect(page.getByText('Test Item')).toBeVisible();
});
```

---

## Quick Reference

### Commands

```bash
# Python
pytest                    # All tests
pytest -m unit            # By marker
pytest --cov=app          # Coverage
pytest -x                 # Stop on failure

# Frontend
npm test                  # All tests
npm test -- --watch       # Watch mode

# E2E
npx playwright test       # All E2E
npx playwright test --ui  # UI mode
```

### Assertions

```python
# pytest
assert result == expected
pytest.raises(ValueError)
```

```javascript
// React Testing Library
expect(element).toBeInTheDocument();
expect(element).toBeVisible();
expect(mockFn).toHaveBeenCalledWith(arg);
```

---

## Resources

- [structlog](https://www.structlog.org/)
- [pytest](https://docs.pytest.org/)
- [React Testing Library](https://testing-library.com/)
- [Playwright](https://playwright.dev/)
