# Responsive, Accessibility, and Theme Support Implementation Plan

> **For Claude:** REQUIRED SUB-SKILL: Use superpowers:executing-plans to implement this plan task-by-task.

**Goal:** Extend ui-skills to support mobile responsiveness, accessibility (a11y), dark/light theme switching, and React Native adaptation.

**Architecture:** Add new constraint sections to SKILL.md for responsive design, accessibility standards, theme management, and platform-specific adaptations (Web vs React Native).

**Tech Stack:** Markdown (skill definitions), Shell scripts (install verification), existing Astro/React website for documentation.

---

## Task 1: Add Mobile Responsive Support Section

**Files:**
- Modify: `/Users/jt/places/personal/ui-skills/src/SKILL.md`

**Step 1: Write test/verification (manual review)**

Review the SKILL.md file and verify the new "Responsive" section is added after the "Layout" section.

**Step 2: Add the Responsive section to SKILL.md**

After line 69 (after the "Layout" section), add the following:

```markdown
## Responsive

- MUST use mobile-first approach (start with mobile, add breakpoints for larger screens)
- MUST use Tailwind CSS responsive prefixes (`sm:`, `md:`, `lg:`, `xl:`, `2xl:`)
- SHOULD design for these breakpoints:
  - `sm:` 640px (small tablets)
  - `md:` 768px (tablets)
  - `lg:` 1024px (laptops)
  - `xl:` 1280px (desktops)
  - `2xl:` 1536px (large desktops)
- MUST ensure touch targets are at least 44x44px on mobile
- MUST test responsive behavior at each breakpoint
- SHOULD avoid fixed widths that break layout on smaller screens
- MUST use `max-w-container` or container queries for content width constraints
- SHOULD consider landscape orientation differences on mobile
```

**Step 3: Verify the section was added correctly**

Run: `cat /Users/jt/places/personal/ui-skills/src/SKILL.md | grep -A 15 "## Responsive"`

Expected: Should see the new Responsive section with all constraints.

**Step 4: Commit**

```bash
cd /Users/jt/places/personal/ui-skills
git add src/SKILL.md
git commit -m "feat: add responsive design constraints"
```

---

## Task 2: Add amfe-flexible Solution Reference

**Files:**
- Modify: `/Users/jt/places/personal/ui-skills/src/SKILL.md`

**Step 1: Add amfe-flexible reference to Responsive section**

Add the following to the end of the "Responsive" section (after the last bullet):

```markdown
- CONSIDER `amfe-flexible` or similar viewport scaling solutions for older mobile browsers requiring rem-based scaling
- When using amfe-flexible:
  - MUST set viewport meta tag: `<meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1, user-scalable=no">`
  - SHOULD use `rem` units for font sizes and spacing instead of fixed `px`
  - MUST test on actual devices to verify scaling behavior
```

**Step 2: Verify the addition**

Run: `cat /Users/jt/places/personal/ui-skills/src/SKILL.md | grep -A 5 "amfe-flexible"`

Expected: Should see the amfe-flexible reference with implementation guidelines.

**Step 3: Commit**

```bash
cd /Users/jt/places/personal/ui-skills
git add src/SKILL.md
git commit -m "feat: add amfe-flexible solution reference for mobile scaling"
```

---

## Task 3: Add Accessibility (a11y) Section

**Files:**
- Modify: `/Users/jt/places/personal/ui-skills/src/SKILL.md`

**Step 1: Add new Accessibility section**

Add a new "## Accessibility" section after "## Animation" (around line 57). Insert:

```markdown
## Accessibility

- MUST follow WCAG 2.1 AA guidelines as a baseline
- MUST ensure keyboard navigability for all interactive elements
- MUST provide visible focus indicators for keyboard navigation
- MUST use semantic HTML elements (`<button>`, `<nav>`, `<main>`, `<article>`, etc.)
- MUST include `alt` text for all images with meaningful content
- MUST use `aria-label` or `aria-labelledby` for icon-only buttons and inputs
- MUST ensure color contrast ratios meet WCAG AA (4.5:1 for normal text, 3:1 for large text)
- MUST support screen readers with proper ARIA attributes
- SHOULD test with screen reader (NVDA, JAWS, or VoiceOver)
- MUST provide skip links for main content navigation
- MUST use `role` attributes only when semantic HTML is insufficient
- SHOULD test with keyboard-only navigation
- MUST ensure form inputs have associated labels
- SHOULD use `prefers-reduced-motion` to respect user motion preferences
- MUST provide error messages that are announced to screen readers
- SHOULD use fieldset and legend for related form controls
```

**Step 2: Verify the Accessibility section**

Run: `cat /Users/jt/places/personal/ui-skills/src/SKILL.md | grep -A 20 "## Accessibility"`

Expected: Should see the complete Accessibility section with WCAG guidelines.

**Step 3: Commit**

```bash
cd /Users/jt/places/personal/ui-skills
git add src/SKILL.md
git_commit -m "feat: add accessibility (a11y) constraints with WCAG 2.1 AA guidelines"
```

---

## Task 4: Add Dark/Light Theme Support Section

**Files:**
- Modify: `/Users/jt/places/personal/ui-skills/src/SKILL.md`
- Modify: `/Users/jt/places/personal/ui-skills/src/styles/global.css`

**Step 4.1: Add Theme section to SKILL.md**

Add a new "## Theme" section after "## Design" (at the end of the file):

```markdown
## Theme

- MUST support both light and dark modes
- MUST respect system preference using `prefers-color-scheme`
- SHOULD provide a manual theme toggle when theme affects readability
- MUST use CSS custom properties for theme colors to enable easy switching
- MUST ensure sufficient contrast in both light and dark modes
- SHOULD test all components in both themes
- MUST avoid hardcoded colors that don't adapt to theme changes
- SHOULD use Tailwind CSS `dark:` prefix for dark mode styles
- MUST ensure images, graphics, and icons work in both themes
- SHOULD consider using SVG with `currentColor` for theme-aware icons
- MUST persist user's theme preference (if manual toggle is provided)
- SHOULD avoid purely decorative differences between themes
```

**Step 4.2: Verify Theme section in SKILL.md**

Run: `cat /Users/jt/places/personal/ui-skills/src/SKILL.md | grep -A 15 "## Theme"`

Expected: Should see the Theme section with dark/light mode guidelines.

**Step 4.3: Add dark mode styles to global.css example**

Update `/Users/jt/places/personal/ui-skills/src/styles/global.css` by adding dark mode support. After line 23 (after `--color-tertiary`), add:

```css
  /* Dark mode colors */
  --color-parchment-dark-50: #1c1917;
  --color-parchment-dark-100: #292524;
  --color-parchment-dark-200: #44403c;
  --color-parchment-dark-300: #57534e;
  --color-parchment-dark-400: #78716c;
  --color-parchment-dark-500: #a8a29e;
  --color-parchment-dark-600: #d6d3d1;
  --color-parchment-dark-700: #e5e5e0;
  --color-parchment-dark-800: #f5f5f0;
  --color-parchment-dark-900: #fafaf5;
```

After line 41 (after `::selection` block), add:

```css
@media (prefers-color-scheme: dark) {
  :root {
    --color-primary: var(--color-parchment-dark-50);
    --color-secondary: var(--color-parchment-dark-200);
    --color-tertiary: var(--color-parchment-dark-400);
  }

  ::selection {
    background-color: #78716c7c;
    color: inherit;
  }

  .prose :where(code):not(:where([class~="not-prose"], [class~="not-prose"] *)) {
    background-color: var(--color-parchment-dark-200);
    color: var(--color-parchment-dark-800);
  }
}
```

**Step 4.4: Verify dark mode styles**

Run: `cat /Users/jt/places/personal/ui-skills/src/styles/global.css | grep -A 30 "prefers-color-scheme"`

Expected: Should see the dark mode media query with updated color variables.

**Step 4.5: Test dark mode locally**

Run: `cd /Users/jt/places/personal/ui-skills && npm run dev`

Expected: Dev server starts. Visit http://localhost:4321 and verify dark mode works when system is set to dark.

**Step 4.6: Commit**

```bash
cd /Users/jt/places/personal/ui-skills
git add src/SKILL.md src/styles/global.css
git commit -m "feat: add dark/light theme support with system preference detection"
```

---

## Task 5: Add Platform Detection and React Native Support

**Files:**
- Modify: `/Users/jt/places/personal/ui-skills/src/SKILL.md`

**Step 5.1: Add Platform Detection section**

Add a new "## Platform" section at the beginning of the file (after "## Stack", around line 26):

```markdown
## Platform

- MUST detect if target platform is Web (browser) or React Native
- Web platforms: Use web-specific APIs and HTML elements
- React Native platforms: Use RN-specific components and APIs
- SHOULD check for `react-native` imports or package.json dependencies to detect RN projects
- MUST apply platform-specific constraints based on detection

### Web (browser)

- Follow all constraints in this skill file
- Use HTML elements, CSS, and browser APIs
- Responsive design applies to viewport size changes
- Theme follows `prefers-color-scheme`

### React Native

- Replace `h-screen` with `flex-1` for full-height containers
- Replace `safe-area-inset` with React Native SafeAreaContext
- Use `StyleSheet.create()` or styled-components for styling
- Use `Animated` API instead of CSS transitions
- Use `Pressable`, `TouchableOpacity` for touch interactions
- Use React Native's `Alert` instead of browser dialogs
- Use `useColorScheme()` hook for dark mode detection
- Avoid web-specific CSS properties (backdrop-filter, filters not supported)
- Use `Platform.select()` for platform-specific code
- Test on both iOS and Android when applicable
```

**Step 5.2: Verify Platform section**

Run: `cat /Users/jt/places/personal/ui-skills/src/SKILL.md | grep -A 25 "## Platform"`

Expected: Should see the Platform section with Web and React Native subsections.

**Step 5.3: Commit**

```bash
cd /Users/jt/places/personal/ui-skills
git add src/SKILL.md
git commit -m "feat: add platform detection and React Native support guidelines"
```

---

## Task 6: Update Documentation Website

**Files:**
- Modify: `/Users/jt/places/personal/ui-skills/src/pages/index.astro`

**Step 6.1: Read the current index page**

Run: `cat /Users/jt/places/personal/ui-skills/src/pages/index.astro`

**Step 6.2: Add feature highlights to the landing page**

Find the section describing current features and add bullet points for:
- Mobile responsive design with mobile-first approach
- Accessibility (a11y) following WCAG 2.1 AA
- Dark/light theme support with system preference
- React Native platform support

Add HTML similar to:
```html
<li class="flex items-center gap-2">
  <span class="w-1.5 h-1.5 bg-parchment-600 rounded-full"></span>
  <span>Mobile responsive design with mobile-first approach</span>
</li>
<li class="flex items-center gap-2">
  <span class="w-1.5 h-1.5 bg-parchment-600 rounded-full"></span>
  <span>Accessibility (a11y) following WCAG 2.1 AA</span>
</li>
<li class="flex items-center gap-2">
  <span class="w-1.5 h-1.5 bg-parchment-600 rounded-full"></span>
  <span>Dark/light theme with system preference</span>
</li>
<li class="flex items-center gap-2">
  <span class="w-1.5 h-1.5 bg-parchment-600 rounded-full"></span>
  <span>React Native platform support</span>
</li>
```

**Step 6.3: Verify website builds successfully**

Run: `cd /Users/jt/places/personal/ui-skills && npm run build`

Expected: Build completes without errors.

**Step 6.4: Commit**

```bash
cd /Users/jt/places/personal/ui-skills
git add src/pages/index.astro
git commit -m "docs: update landing page with new features (responsive, a11y, theme, RN)"
```

---

## Task 7: Update Version Number

**Files:**
- Modify: `/Users/jt/places/personal/ui-skills/package.json`

**Step 7.1: Update version**

Change version from `0.0.8` to `0.1.0` (minor version bump for new features)

**Step 7.2: Verify version change**

Run: `cat /Users/jt/places/personal/ui-skills/package.json | grep version`

Expected: Should show `"version": "0.1.0"`

**Step 7.3: Commit**

```bash
cd /Users/jt/places/personal/ui-skills
git add package.json
git commit -m "chore: bump version to 0.1.0"
```

---

## Task 8: Final Verification and Tag

**Step 8.1: Verify all changes**

Run: `cd /Users/jt/places/personal/ui-skills && git log --oneline -8`

Expected: Should see all 7 commits from this implementation.

**Step 8.2: Review final SKILL.md**

Run: `cat /Users/jt/places/personal/ui-skills/src/SKILL.md`

Verify all new sections are present: Platform, Responsive, Accessibility, Theme.

**Step 8.3: Test the skill installation**

Run: `cd /Users/jt/places/personal && npx ui-skills init`

Expected: Installation completes successfully with updated skill.

**Step 8.4: Create version tag**

```bash
cd /Users/jt/places/personal/ui-skills
git tag -a v0.1.0 -m "Release v0.1.0: Add responsive, a11y, theme, and RN support"
```

**Step 8.5: Final commit for tag**

```bash
git push origin main --tags
```

---

## Summary

This implementation plan adds:

1. **Responsive Design**: Mobile-first approach with breakpoint guidance
2. **amfe-flexible Reference**: Viewport scaling solution for older mobile browsers
3. **Accessibility (a11y)**: WCAG 2.1 AA compliance requirements
4. **Theme Support**: Dark/light mode with system preference detection
5. **Platform Detection**: Separate guidelines for Web and React Native platforms

All changes follow the existing ui-skills pattern of opinionated constraints that guide AI agents when building interfaces.
