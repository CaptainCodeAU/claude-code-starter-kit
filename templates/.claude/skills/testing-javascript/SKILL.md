---
name: testing-javascript
description: |
  Best practices for JavaScript/TypeScript testing with Jest and Vitest.
  Use when: writing tests, debugging test failures, setting up test infrastructure.
  Covers: test structure, mocking, async testing, coverage, testing-library.
---

# JavaScript/TypeScript Testing

## Test Runners

### Jest

- Standard for React projects
- Built-in mocking, coverage, snapshots
- Config: `jest.config.js` or `package.json`

### Vitest

- Native ESM support, faster than Jest
- Compatible with Vite projects
- Config: `vitest.config.ts` or `vite.config.ts`

## Running Tests

```bash
# Jest
pnpm test                    # Run all tests
pnpm test -- --watch         # Watch mode
pnpm test -- --coverage      # With coverage

# Vitest
pnpm test                    # Run all tests
pnpm test -- --ui            # UI mode
pnpm test -- --coverage      # With coverage
```

## Test File Conventions

```
src/
  components/
    Button.tsx
    Button.test.tsx          # Co-located test
tests/
  integration/
    auth.test.ts             # Integration tests
  e2e/
    checkout.spec.ts         # E2E tests (Playwright)
```

## Test Structure

```typescript
describe('ComponentName', () => {
  beforeEach(() => {
    // Setup before each test
  });

  afterEach(() => {
    // Cleanup after each test
  });

  it('should do something specific', () => {
    // Arrange
    const input = 'test';

    // Act
    const result = doSomething(input);

    // Assert
    expect(result).toBe('expected');
  });
});
```

## Mocking

### Jest

```typescript
// Mock module
jest.mock('./api', () => ({
  fetchData: jest.fn().mockResolvedValue({ data: 'test' })
}));

// Mock function
const mockFn = jest.fn().mockReturnValue('mocked');

// Spy on method
jest.spyOn(object, 'method').mockImplementation(() => 'mocked');

// Clear mocks between tests
beforeEach(() => {
  jest.clearAllMocks();
});
```

### Vitest

```typescript
// Mock module
vi.mock('./api', () => ({
  fetchData: vi.fn().mockResolvedValue({ data: 'test' })
}));

// Mock function
const mockFn = vi.fn().mockReturnValue('mocked');

// Spy on method
vi.spyOn(object, 'method').mockImplementation(() => 'mocked');

// Clear mocks between tests
beforeEach(() => {
  vi.clearAllMocks();
});
```

## Testing Async Code

```typescript
it('should handle async operations', async () => {
  const result = await fetchData();
  expect(result).toEqual({ data: 'test' });
});

it('should handle errors', async () => {
  await expect(failingFn()).rejects.toThrow('Error message');
});

it('should wait for promises', async () => {
  const promise = someAsyncOperation();
  await expect(promise).resolves.toBe('success');
});
```

## React Testing (testing-library)

```typescript
import { render, screen, fireEvent, waitFor } from '@testing-library/react';
import userEvent from '@testing-library/user-event';

describe('Button', () => {
  it('should render and handle click', async () => {
    const mockFn = vi.fn();
    const user = userEvent.setup();

    render(<Button onClick={mockFn}>Click me</Button>);

    await user.click(screen.getByText('Click me'));

    expect(mockFn).toHaveBeenCalledTimes(1);
  });

  it('should show loading state', async () => {
    render(<Button loading>Submit</Button>);

    expect(screen.getByRole('button')).toBeDisabled();
    expect(screen.getByText('Loading...')).toBeInTheDocument();
  });
});
```

### Query Priority

Use queries in this order (most to least preferred):

1. `getByRole` - Accessible to everyone
2. `getByLabelText` - Form fields
3. `getByPlaceholderText` - If no label
4. `getByText` - Non-interactive elements
5. `getByTestId` - Last resort

## Testing Hooks

```typescript
import { renderHook, act } from '@testing-library/react';

describe('useCounter', () => {
  it('should increment counter', () => {
    const { result } = renderHook(() => useCounter());

    act(() => {
      result.current.increment();
    });

    expect(result.current.count).toBe(1);
  });
});
```

## Coverage Requirements

- Aim for 80%+ coverage on critical paths
- Don't chase 100% - test behavior, not implementation
- Focus on: user interactions, error cases, edge cases

## Common Pitfalls

1. **Testing implementation details** - Test what the user sees, not internal state
2. **Not waiting for async** - Use `await`, `waitFor`, or `findBy` queries
3. **Snapshot overuse** - Use for static content only, not dynamic data
4. **Mocking too much** - Only mock external dependencies, not the code under test
5. **No cleanup** - Use `afterEach` to reset state between tests
