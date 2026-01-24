# Frontend Guidelines

## Framework Selection
Choose based on project complexity:

### Simple Projects
- Plain HTML/CSS/JS
- No build step needed
- Good for: static pages, simple demos, quick prototypes

### Interactive Apps / Blogs
- **Svelte/SvelteKit** (preferred for animations, smaller bundles)
- **React/Next.js** (larger ecosystem, more resources)
- Deploy on Vercel or Netlify (free tier)

## Styling
- Prefer CSS modules or scoped styles
- Use CSS variables for theming
- Mobile-first responsive design

## Animations
- Use CSS transitions/animations when possible
- Svelte: use built-in `transition:` and `animate:` directives
- React: consider Framer Motion for complex animations

## Performance
- Lazy load images and heavy components
- Minimize bundle size - evaluate dependencies carefully
- Use static generation (SSG) when content doesn't change frequently

## Accessibility
- Use semantic HTML elements
- Include alt text for images
- Ensure keyboard navigation works
