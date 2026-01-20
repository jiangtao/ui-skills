---
name: ui-skills
description: Opinionated constraints for building better interfaces with agents.
---

# UI Skills

When invoked, apply these opinionated constraints for building better interfaces.

## How to use

- `/ui-skills`  
  Apply these constraints to any UI work in this conversation.

- `/ui-skills <file>`  
  Review the file against all constraints below and output:
  - violations (quote the exact line/snippet)
  - why it matters (1 short sentence)
  - a concrete fix (code-level suggestion)

## Stack

- MUST use Tailwind CSS defaults unless custom values already exist or are explicitly requested
- MUST use `motion/react` (formerly `framer-motion`) when JavaScript animation is required
- SHOULD use `tw-animate-css` for entrance and micro-animations in Tailwind CSS
- MUST use `cn` utility (`clsx` + `tailwind-merge`) for class logic

## Components

- MUST use accessible component primitives for anything with keyboard or focus behavior (`Base UI`, `React Aria`, `Radix`)
- MUST use the project’s existing component primitives first
- NEVER mix primitive systems within the same interaction surface
- SHOULD prefer [`Base UI`](https://base-ui.com/react/components) for new primitives if compatible with the stack
- MUST add an `aria-label` to icon-only buttons
- NEVER rebuild keyboard or focus behavior by hand unless explicitly requested

## Interaction

- MUST use an `AlertDialog` for destructive or irreversible actions
- SHOULD use structural skeletons for loading states
- NEVER use `h-screen`, use `h-dvh`
- MUST respect `safe-area-inset` for fixed elements
- MUST show errors next to where the action happens
- NEVER block paste in `input` or `textarea` elements

## Animation

- NEVER add animation unless it is explicitly requested
- MUST animate only compositor props (`transform`, `opacity`)
- NEVER animate layout properties (`width`, `height`, `top`, `left`, `margin`, `padding`)
- SHOULD avoid animating paint properties (`background`, `color`) except for small, local UI (text, icons)
- SHOULD use `ease-out` on entrance
- NEVER exceed `200ms` for interaction feedback
- MUST pause looping animations when off-screen
- SHOULD respect `prefers-reduced-motion`
- NEVER introduce custom easing curves unless explicitly requested
- SHOULD avoid animating large images or full-screen surfaces

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

## Typography

- MUST use `text-balance` for headings and `text-pretty` for body/paragraphs
- MUST use `tabular-nums` for data
- SHOULD use `truncate` or `line-clamp` for dense UI
- NEVER modify `letter-spacing` (`tracking-*`) unless explicitly requested

## Layout

- MUST use a fixed `z-index` scale (no arbitrary `z-*`)
- SHOULD use `size-*` for square elements instead of `w-*` + `h-*`

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
- CONSIDER `amfe-flexible` or similar viewport scaling solutions for older mobile browsers requiring rem-based scaling
- When using amfe-flexible:
  - MUST set viewport meta tag: `<meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1, user-scalable=no">`
  - SHOULD use `rem` units for font sizes and spacing instead of fixed `px`
  - MUST test on actual devices to verify scaling behavior

## Performance

- NEVER animate large `blur()` or `backdrop-filter` surfaces
- NEVER apply `will-change` outside an active animation
- NEVER use `useEffect` for anything that can be expressed as render logic

## Design

- NEVER use gradients unless explicitly requested
- NEVER use purple or multicolor gradients
- NEVER use glow effects as primary affordances
- SHOULD use Tailwind CSS default shadow scale unless explicitly requested
- MUST give empty states one clear next action
- SHOULD limit accent color usage to one per view
- SHOULD use existing theme or Tailwind CSS color tokens before introducing new ones

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
