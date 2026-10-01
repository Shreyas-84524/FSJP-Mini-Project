# design.md — Syntra Website Design System

## 1. Design Direction

**Visual identity:** Premium dark-tech, minimal, futuristic, and refined.

The website should take visual inspiration from the provided reference: deep black/navy surfaces, electric-blue illumination, subtle gradients, thin glowing lines, generous negative space, and crisp white typography.

### Core principles
- Dark-first interface
- Electric blue used as an accent, not as a full-page fill
- High contrast typography
- Minimal borders and restrained decoration
- Soft blue glows instead of heavy shadows
- Large, clean typography with generous spacing
- Premium technology aesthetic rather than a typical "neon gaming" interface
- Motion should be subtle and purposeful

---

## 2. Color System

### Primary Palette

| Token | Hex | Usage |
|---|---|---|
| `--black` | `#000000` | Main background, hero sections |
| `--navy-950` | `#000010` | Primary dark surface |
| `--navy-900` | `#000020` | Cards and secondary sections |
| `--navy-800` | `#001030` | Elevated surfaces |
| `--navy-700` | `#001040` | Borders, gradients, decorative elements |
| `--blue-600` | `#005CFF` | Primary accent |
| `--blue-500` | `#0077FF` | Links, active states |
| `--electric-blue` | `#1683FF` | Highlights and glow |
| `--blue-soft` | `#4DA3FF` | Secondary highlight |
| `--white` | `#F5F5F5` | Main text |
| `--white-pure` | `#FFFFFF` | High-emphasis text/icons |
| `--gray-300` | `#B8BDC7` | Secondary text |
| `--gray-500` | `#707783` | Muted text |

### Recommended ratio

- 65% — Black / near-black
- 20% — Deep navy
- 10% — White / neutral text
- 5% — Electric blue accent

Blue should remain an accent. Avoid making every component blue.

---

## 3. Backgrounds

### Base background

```css
background: #000000;
```

### Primary website gradient

```css
background:
  radial-gradient(circle at 50% 20%, rgba(0, 92, 255, 0.14), transparent 35%),
  linear-gradient(135deg, #000000 0%, #000010 55%, #000020 100%);
```

### Blue glow

```css
background: radial-gradient(
  circle,
  rgba(0, 119, 255, 0.30) 0%,
  rgba(0, 92, 255, 0.10) 35%,
  transparent 70%
);
```

### Decorative light line

Use thin curved or diagonal blue gradients:

```css
background: linear-gradient(
  90deg,
  transparent,
  rgba(22, 131, 255, 0.85),
  transparent
);
```

---

## 4. Typography

### Font direction

Use a modern geometric/sans-serif typeface.

Recommended:
- **Inter**
- **Manrope**
- **Satoshi**
- **Plus Jakarta Sans**

Use one primary font throughout the website.

### Type scale

| Element | Size | Weight |
|---|---:|---:|
| Hero heading | 64–88px | 600–700 |
| Section heading | 40–56px | 600–700 |
| Card heading | 22–28px | 600 |
| Body | 16–18px | 400 |
| Small text | 13–14px | 400–500 |
| Button | 14–16px | 600 |

### Typography rules

- Use white for important headings.
- Use `#B8BDC7` for supporting copy.
- Keep paragraphs short.
- Prefer sentence case over excessive uppercase text.
- Avoid overly bold typography throughout the interface.
- Use large typography to create hierarchy rather than excessive decoration.

---

## 5. Logo / Brand Treatment

The **Syntra** wordmark should appear primarily in white.

If the asterisk/symbol is part of the brand identity:
- Keep the symbol white in normal usage.
- Electric blue may be used for hover or illuminated variants.
- Do not add a permanent heavy glow to the logo.

Recommended logo treatment:

```css
color: #FFFFFF;
```

Optional illuminated version:

```css
text-shadow:
  0 0 12px rgba(22, 131, 255, 0.35),
  0 0 28px rgba(22, 131, 255, 0.15);
```

---

## 6. Navigation

### Navbar

- Background: transparent or `rgba(0,0,0,0.65)`
- Backdrop blur: 16–24px
- Bottom border: extremely subtle
- Logo: white
- Navigation text: `#B8BDC7`
- Active/hover text: white
- CTA: electric-blue accent

Example:

```css
background: rgba(0, 0, 0, 0.65);
backdrop-filter: blur(20px);
border-bottom: 1px solid rgba(255,255,255,0.06);
```

### Navigation hover

Use a subtle blue underline, glow, or opacity transition rather than large animated effects.

---

## 7. Buttons

### Primary button

```css
background: #FFFFFF;
color: #000000;
```

Use this for the most important CTA when a premium minimal appearance is desired.

### Accent button

```css
background: #005CFF;
color: #FFFFFF;
```

Hover:

```css
background: #0077FF;
box-shadow: 0 0 24px rgba(0, 119, 255, 0.30);
```

### Secondary button

```css
background: rgba(255,255,255,0.04);
border: 1px solid rgba(255,255,255,0.12);
color: #F5F5F5;
```

---

## 8. Cards

Cards should feel like dark glass panels rather than traditional boxed UI.

```css
background: rgba(0, 16, 48, 0.42);
border: 1px solid rgba(255,255,255,0.07);
border-radius: 20px;
```

Optional hover:

```css
border-color: rgba(0,119,255,0.35);
box-shadow: 0 0 40px rgba(0,92,255,0.10);
transform: translateY(-2px);
```

### Card rules

- Avoid bright blue card backgrounds.
- Keep the interior mostly black/navy.
- Use blue only around active or highlighted elements.
- Prefer large padding: 24–40px.

---

## 9. Borders & Dividers

Use very low-contrast borders.

### Standard

```css
border: 1px solid rgba(255,255,255,0.08);
```

### Blue accent

```css
border: 1px solid rgba(0,119,255,0.30);
```

### Divider

```css
background: rgba(255,255,255,0.07);
height: 1px;
```

Avoid bright white borders except for focused controls or deliberate visual framing.

---

## 10. Glow & Shadow System

Blue illumination is an important part of the visual identity, but it must remain controlled.

### Small glow

```css
box-shadow: 0 0 16px rgba(0,119,255,0.20);
```

### Medium glow

```css
box-shadow: 0 0 32px rgba(0,119,255,0.18);
```

### Large atmospheric glow

```css
box-shadow: 0 0 80px rgba(0,92,255,0.12);
```

Do not use glow on every component.

---

## 11. Hero Section

The hero should be the strongest expression of the design language.

### Structure

- Large white headline
- Short supporting paragraph
- One primary CTA
- One secondary CTA
- Large dark negative space
- One or two subtle blue light arcs/glows
- Optional abstract geometric/3D visual

### Suggested layout

```text
                NAVBAR

        Large Hero Heading
      Supporting description

       [ Primary CTA ] [ Secondary ]

             Blue glow
        / subtle light arc /
```

The visual should feel spacious rather than crowded.

---

## 12. Sections

Each section should have clear visual separation without relying on heavy borders.

Recommended section spacing:

- Desktop: `120–180px`
- Tablet: `80–120px`
- Mobile: `64–96px`

Use subtle background changes such as:

```css
#000000
→
#000010
→
#000020
```

instead of obvious section containers.

---

## 13. Icons

Icons should be:
- Minimal
- Geometric
- Thin to medium weight
- White or muted gray by default
- Electric blue when active

Recommended icon colors:

```css
default: #B8BDC7;
active: #FFFFFF;
accent: #1683FF;
```

Avoid colorful multi-icon systems.

---

## 14. Forms & Inputs

```css
background: rgba(255,255,255,0.035);
border: 1px solid rgba(255,255,255,0.10);
color: #FFFFFF;
border-radius: 12px;
```

Focus state:

```css
border-color: #1683FF;
box-shadow: 0 0 0 3px rgba(22,131,255,0.12);
```

Placeholder:

```css
color: #707783;
```

---

## 15. Status Colors

Keep the main brand palette intact while using standard semantic colors only where necessary.

| Status | Color |
|---|---|
| Success | `#36D399` |
| Warning | `#F5C451` |
| Error | `#FF5C6C` |
| Information | `#1683FF` |

Semantic colors should not compete with the primary electric-blue identity.

---

## 16. Border Radius

Use a modern but controlled radius system:

```css
--radius-sm: 8px;
--radius-md: 12px;
--radius-lg: 20px;
--radius-xl: 28px;
--radius-pill: 999px;
```

Buttons: 10–14px  
Cards: 18–24px  
Large feature panels: 24–32px

---

## 17. Motion

Animations should feel smooth and premium.

### Standard transition

```css
transition:
  transform 220ms ease,
  border-color 220ms ease,
  background 220ms ease,
  box-shadow 220ms ease;
```

### Recommended effects

- Fade-up on section entrance
- Subtle card elevation on hover
- Slow background glow movement
- Gentle blue light sweep
- Button glow on hover

Avoid:
- Excessive bouncing
- Rapid neon flashing
- Constant particle animations
- Large parallax movements
- Overly animated text

---

## 18. Responsive Design

### Desktop
- Wide content container
- Large hero typography
- Generous whitespace
- Multi-column feature layouts

### Tablet
- Reduce typography by approximately 15–20%
- Convert complex grids to 2 columns
- Reduce section spacing

### Mobile
- Hero heading: approximately 40–52px
- Single-column cards
- Full-width primary CTA
- Compact navigation / mobile menu
- Reduce decorative glow intensity
- Preserve large dark negative space

---

## 19. Accessibility

- Maintain strong contrast between white text and dark backgrounds.
- Do not communicate state using color alone.
- Provide visible keyboard focus states.
- Respect `prefers-reduced-motion`.
- Keep body text at a readable size.
- Avoid excessively bright blue text on black for long paragraphs.

---

## 20. CSS Variables

```css
:root {
  --color-black: #000000;

  --color-navy-950: #000010;
  --color-navy-900: #000020;
  --color-navy-800: #001030;
  --color-navy-700: #001040;

  --color-blue-600: #005CFF;
  --color-blue-500: #0077FF;
  --color-electric-blue: #1683FF;
  --color-blue-soft: #4DA3FF;

  --color-white: #F5F5F5;
  --color-white-pure: #FFFFFF;

  --color-gray-300: #B8BDC7;
  --color-gray-500: #707783;

  --radius-sm: 8px;
  --radius-md: 12px;
  --radius-lg: 20px;
  --radius-xl: 28px;
  --radius-pill: 999px;

  --shadow-blue-sm: 0 0 16px rgba(0,119,255,0.20);
  --shadow-blue-md: 0 0 32px rgba(0,119,255,0.18);
  --shadow-blue-lg: 0 0 80px rgba(0,92,255,0.12);
}
```

---

## 21. Design Do's

- Use black as the dominant visual foundation.
- Use deep navy to create depth.
- Use electric blue strategically.
- Keep typography clean and spacious.
- Use white as the strongest contrast element.
- Use gradients and glows as atmospheric details.
- Keep interfaces minimal and premium.
- Use large areas of negative space.
- Prefer subtle borders over heavy containers.

## 22. Design Don'ts

- Do not use bright blue everywhere.
- Do not turn the interface into a neon/cyberpunk theme.
- Do not use multiple unrelated accent colors.
- Do not use heavy drop shadows.
- Do not overcrowd sections with decorative elements.
- Do not use excessive glassmorphism.
- Do not use large gradients behind every component.
- Do not mix several font families.
- Do not use pure white borders throughout the UI.

---

## 23. Overall Visual Formula

**Black + Deep Navy + White + Electric Blue**

The final website should feel:

> **Minimal · Premium · Futuristic · Precise · Technological**

The reference image's strongest visual characteristic is the contrast between almost-black surfaces and concentrated electric-blue illumination. Preserve that relationship throughout the website rather than copying individual graphic elements.
