# SmartBursar — Performance and Compatibility Guidelines

**For:** Frontend Developer  
**Maintained by:** A-Von Computer Solutions  

---

## The Context

A-Von CashBook runs on school computers in Uganda. These are not developer machines. You will encounter Windows 10 machines with 2–4GB of RAM, spinning hard drives, and older processors. The app must feel fast on those machines, not just on yours.

Every decision you make while building the frontend has a performance consequence. This document tells you what those decisions are and how to make the right ones from the start.

---

## Platform Targets

| Platform | Minimum Version | Notes |
|---|---|---|
| Windows | Windows 10 | WebView2 required — ships with Win 10 |
| Linux | Any modern distro | WebKit, no known issues |
| macOS | High Sierra (10.13) | Older WebKit — see CSS and JS rules below |

Never test only on your development machine. Before any feature is considered done, it must be tested on the lowest-spec target you have access to.

---

## Vite Build Configuration

Set this in `vite.config.js` before writing a single component. Do not change it later.

```javascript
export default {
  build: {
    target: 'es2019',
    minify: 'esbuild',
    rollupOptions: {
      output: {
        manualChunks: {
          react: ['react', 'react-dom'],
          router: ['react-router-dom'],
          state: ['zustand'],
        }
      }
    }
  }
}
```

**Why `es2019`:** macOS High Sierra ships with an older WebKit that does not support the very latest JavaScript features. Targeting es2019 tells Vite to transpile your code to a version that older WebKit understands. You write modern code — Vite handles the rest.

**Why `manualChunks`:** This splits your bundle into separate files. React loads once and is cached. Your app code loads separately. On a slow HDD, cached files load from memory — so subsequent screen loads feel instant.

---

## Code Splitting — Non-Negotiable

Every page component must be lazy loaded. This means the app only loads the code for the screen the user is currently on. A bursar who only uses Payment Collection never downloads the Audit Log code.

Do this from the very first page you build. It costs nothing to implement early and is painful to retrofit later.

```javascript
// App.jsx — do this for every single page
import { lazy, Suspense } from 'react'

const Dashboard = lazy(() => import('./pages/dashboard/Dashboard'))
const PaymentCollection = lazy(() => import('./pages/payments/PaymentCollection'))
const StudentList = lazy(() => import('./pages/students/StudentList'))
// every other page follows the same pattern

// Wrap your router in Suspense
<Suspense fallback={<LoadingSpinner />}>
  <Routes>
    <Route path="/dashboard" element={<Dashboard />} />
    <Route path="/payments/collect" element={<PaymentCollection />} />
    ...
  </Routes>
</Suspense>
```

---

## Images and Assets

- The school logo uploaded during setup must be resized before storing. Maximum display size is 120x120px in the sidebar. Do not store or display a 5MB raw photo.
- Compress any static image assets in `src/assets/` before committing them. Use PNG for logos, JPEG for anything photographic.
- Student photo uploads must be capped at 200KB on the frontend before sending to the backend. Reject anything larger with a clear message.
- Never import large assets directly into components. Reference them by path.

---

## CSS Rules for Cross-Platform Compatibility

macOS High Sierra's WebKit is the strictest target. Follow these rules and your CSS will work everywhere.

**Use these freely — fully supported:**
- Flexbox
- CSS Grid (basic — rows and columns)
- CSS custom properties (variables)
- Tailwind utility classes (Tailwind handles compatibility)
- `transition` and basic `animation`
- `border-radius`, `box-shadow`, `opacity`

**Avoid these — not reliable on older WebKit:**
- CSS Grid `subgrid`
- `backdrop-filter` (frosted glass effects) — use a solid background instead
- `gap` on Flexbox (use `space-x-*` and `space-y-*` Tailwind utilities instead)
- `:has()` selector
- `container` queries
- `@layer` CSS at-rule outside of Tailwind's own usage

**Fonts:** All three fonts — Geist, Syne, JetBrains Mono — must be bundled locally in `src/assets/fonts/`. Never load fonts from Google Fonts or any CDN at runtime. The app must work fully offline. A school computer with no internet should look identical to one with internet.

---

## JavaScript Rules for Cross-Platform Compatibility

Vite's `es2019` target handles most of this automatically, but be aware of these patterns:

**Write these freely:**
- `async/await`
- Arrow functions
- Destructuring
- Template literals
- `Array.map`, `filter`, `reduce`, `find`
- `Object.entries`, `Object.keys`
- Optional chaining `?.`
- Nullish coalescing `??`

**Avoid these without checking:**
- `Array.at()` — not in es2019, Vite will handle it but be aware
- `structuredClone()` — use `JSON.parse(JSON.stringify())` for deep cloning instead
- Top-level `await` outside of Vite's module system

---

## Component and Rendering Rules

**Never render large lists without pagination.** A school with 600 students rendered in one table will freeze on a 2GB RAM machine. Every table that could grow large must have pagination. Page size of 25 to 50 rows is sufficient.

**Debounce search inputs.** The student search bar on Payment Collection fires an API call as the user types. Without debouncing, a user typing "Amara" triggers 5 calls. With a 300ms debounce, it triggers 1. This is a small thing that makes the app feel responsive.

```javascript
// useDebounce.js — write this once, use it everywhere
import { useState, useEffect } from 'react'

export function useDebounce(value, delay = 300) {
  const [debounced, setDebounced] = useState(value)
  useEffect(() => {
    const timer = setTimeout(() => setDebounced(value), delay)
    return () => clearTimeout(timer)
  }, [value, delay])
  return debounced
}
```

**Do not put everything in global state.** Zustand is for truly global state — the current user, the active term, the institution name. These are needed across many unrelated components. Local UI state — whether a modal is open, what a search field contains, which row is selected — stays in `useState` inside the component. Global state that does not need to be global adds overhead and makes components harder to understand.

**Memoize expensive computations.** If a component calculates a student's total balance from a list of fee structures on every render, wrap it in `useMemo`. This is not premature optimization — it is correct React.

```javascript
const totalBalance = useMemo(() => {
  return breakdown.reduce((sum, item) => sum + item.balance, 0)
}, [breakdown])
```

---

## API Call Rules

**Never call the API inside a render.** All API calls happen inside `useEffect` or event handlers. Never at the top level of a component.

**Show loading states.** Every screen that fetches data must show a loading indicator while the fetch is in progress. On a slow HDD, a SQLite read can take a moment. A blank screen with no feedback makes the app feel broken.

**Handle errors visibly.** Every API call must have a catch block. Errors must show a toast notification with a human-readable message. Never swallow errors silently.

**Do not fetch data you do not need.** The student list endpoint returns all student fields. If a dropdown only needs student ID and name, tell the backend — or filter on the frontend before rendering. Do not pass 600 full student objects through React's rendering pipeline when you only need 2 fields.

---

## The Payment Collection Screen — Special Rules

This is the most performance-sensitive screen in the app. It is used dozens of times per day under time pressure.

- Student search results must appear within 300ms of the user stopping typing. If they do not, something is wrong.
- The "Record Payment" action must complete and show the receipt preview within 1 second. It is a single SQLite write — there is no reason for it to be slow.
- The receipt preview modal must open instantly. Do not fetch anything when the modal opens — all receipt data is already in the payment response.
- Do not re-fetch the student list on every keystroke. Fetch once on component mount, cache it in local state, filter locally. 600 student records is a small JSON payload.

---

## What to Test Before Every Pull Request

Before you open a PR on any frontend feature, run through this list:

- [ ] Does the screen load without a visible flash or blank moment?
- [ ] Does every table have pagination if it can grow beyond 50 rows?
- [ ] Are search inputs debounced?
- [ ] Do loading states appear while data is fetching?
- [ ] Do error states show a visible message if the API call fails?
- [ ] Are all fonts loading from local assets, not the internet?
- [ ] Does the screen look correct in both light mode and dark mode?
- [ ] Does nothing break if you resize the window to a smaller size?

---

## The Single Most Important Rule

Build it, then measure it, then optimize what is actually slow.

Do not guess at performance problems. Do not add complexity to solve a problem that does not exist yet. Follow the rules in this document from day one — they prevent the common problems. For anything beyond that, measure first.

The Tauri developer tools include a performance profiler. Use it when something feels slow. Fix what the profiler shows, not what you imagine might be the problem.
