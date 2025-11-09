# “Warm” — Neovim Theme Design Spec (Markdown)

> Design notes based on the provided screenshot. This is a **spec doc** for building the theme later (no Lua yet). It captures palette, typography, and UI mappings for core Neovim groups and common plugins (file tree, git signs, LSP/diagnostics, statusline). Color values are taken from the image (cluster-sampled + eyeballed) and rounded to hex.

---

## 1) Theme Identity

- **Name:** `warm`
- **Mood:** calm, low-contrast, dark UI with a subtle warm accent.
- **Primary Accents:** soft orange (“warm”) and cool cyan (“focus”).
- **Contrast target:** WCAG AA for code on dark bg where possible without breaking the soft aesthetic.

---

## 2) Base Palette

| Token | Hex | RGB | Usage |
|---|---|---|---|
| `bg.editor` | `#2C2D30` | (44,45,48) | main editor background |
| `bg.sidebar` | `#242628` | (36,38,40) | file tree, signcolumn, left gutters |
| `bg.float` | `#2E3033` | ~ | popups, LSP hover, cmp menu |
| `bg.cursorline` | `#323438` | ~ | cursor line highlight (subtle) |
| `bg.selection` | `#3A3D41` | ~ | visual selection |
| `bg.search` | `#373C42` | ~ | search highlight background |
| `fg.default` | `#FAFAFB` | (250,250,251) | primary text/normal fg |
| `fg.dim` | `#9CA9A5` | (156,169,165) | comments, guides, muted UI |
| `fg.ui` | `#BFC7C4` | ~ | gutter text, inactive |
| `accent.warm` | `#E19C60` | (225,156,96) | line numbers, titles, folder highlights |
| `accent.cyan` | `#47A8D4` | (71,168,212) | identifiers, links, info |
| `accent.green` | `#7AC17A` | ~ | git added, success |
| `accent.red` | `#E06C75` | ~ | errors, deletions |
| `accent.yellow` | `#E5C07B` | ~ | warnings, constants |
| `accent.purple` | `#C678DD` | ~ | keywords/types |
| `accent.blue` | `#61AFEF` | ~ | functions/methods |
| `accent.orange` | `#D19A66` | ~ | numbers, enums |

---

## 3) Typography

- **Editor Font Family (monospace):**
  - Primary: `JetBrains Mono`, `SF Mono`, `Fira Code`, `Cascadia Code`, `Menlo`, `Consolas`, `monospace`
- **File Tree / UI Font:** same as editor for consistency.
- **Sizes (assumed from screenshot proportions):**
  - Editor: **14–15 px** (≈ `:set guifont=JetBrains\ Mono:h14` in GUI; TUI depends on terminal)
  - Sidebar: 0.95× editor size (if the plugin supports per-pane scaling)
  - Statusline: 0.95–1.0× editor size
- **Weights & Styles:**
  - Normal code: **Regular (400)**
  - Keywords / types: **SemiBold (600)** (visually slightly heavier)
  - Comments: **Regular (400)**, **italic enabled** (optional: `set termguicolors` + `cterm`/`gui=italic`)
  - UI labels (statusline mode, diagnostics counts): **Medium (500)**

---

## 4) Global UI Surfaces

- **Editor background:** `bg.editor`
- **Sidebar / signcolumn / foldcolumn:** `bg.sidebar`
- **Splits & borders:** 1px line in `#3A3C3F` (very subtle)
- **Cursorline:** `bg.cursorline`
- **Matching paren:** underline + `accent.cyan`
- **Whitespace / indent guides:** thin guides in `#44474B`
- **Selection:** `bg.selection` with **no** inverse fg; keep text `fg.default`
- **Search highlight:** `bg.search` + underline in `accent.yellow`
- **IncSearch:** invert bg/fg lightly (bg `#41454A`, underline `accent.cyan`)
- **ColorColumn (rulers):** `#3A3C40`

---

## 5) Syntax Mapping (Neovim highlight groups)

| Group | Foreground | Style |
|---|---|---|
| `Normal` | `fg.default` | – |
| `Comment` | `fg.dim` | *italic* |
| `Identifier` | `accent.cyan` | – |
| `Function` | `accent.blue` | – |
| `Statement` / `Keyword` | `accent.purple` | **semibold** |
| `Type` | `accent.yellow` | – |
| `Constant` | `accent.orange` | – |
| `String` | `#A0D9AA` (soft green) | – |
| `Character` | `#A0D9AA` | – |
| `Number` | `accent.orange` | – |
| `Boolean` | `accent.orange` | – |
| `Operator` | `#C0C6C4` | – |
| `PreProc` | `accent.purple` | – |
| `Special` | `#D7DEE0` | – |
| `Todo` | `accent.yellow` on `#3B3426` | **bold** |
| `Error` | `accent.red` | **bold** |

---

## 6) Gutter, Line Numbers, Signs

- **Line numbers (`LineNr`):** `accent.warm`
- **Current line number (`CursorLineNr`):** `#F2BF8A` (lighter warm)
- **Sign column background:** `bg.sidebar`
- **Fold column:** `fg.ui` on `bg.sidebar`
- **Diagnostics signs (sign column):**
  - Error: `accent.red` (`SignError`)
  - Warn: `accent.yellow` (`SignWarn`)
  - Info: `accent.cyan` (`SignInfo`)
  - Hint: `#88C0D0` (soft teal) (`SignHint`)

---

## 7) Diagnostics (LSP)

- **Underline styles:** use **undercurl** with distinct sp colors
  - Error: undercurl sp=`accent.red`
  - Warn: undercurl sp=`accent.yellow`
  - Info: undercurl sp=`accent.cyan`
  - Hint: undercurl sp=`#88C0D0`
- **Virtual text:** dimmed bg patch (`#34373B`) + fg by severity (same as signs)
- **Floating windows:** `bg.float` with border `#3E4145` and text `fg.default`

---

## 8) File Tree / Sidebar (e.g., `nvim-tree`, `neo-tree`)

- **Pane bg:** `bg.sidebar`
- **Default text:** `#D2D7D6`
- **Muted text (ignored, dotfiles):** `fg.dim`
- **Folder name (open):** `accent.warm` (**semibold**)
- **Folder name (closed):** `#CFB08A` (slightly dimmer warm)
- **File icons (colored by type):**
  - HTML: `#E34F26`
  - JS/TS: `#F7DF1E` / `#3178C6`
  - Ruby: `#CC342D`
  - Images: `#56B6C2`
  - Env/dotfiles: `#757F7C`
- **Git decorations in tree:**
  - Added: `accent.green`
  - Modified: `accent.blue`
  - Removed: `accent.red`
  - Untracked: `#B3C2A1`
- **Selection row:** `#34373B` with left bar `accent.cyan` at 2px

---

## 9) Statusline / Tabline

- **Statusline bg:** slightly darker than editor, `#212325`
- **Inactive:** `#2A2C2E` with `fg.ui`
- **Active section A (mode chip):** 
  - Normal: bg `accent.warm`, fg `#1E1F22`, **bold**
  - Insert: bg `accent.cyan`, fg `#1E1F22`, **bold**
  - Visual/Select: bg `accent.purple`, fg `#1E1F22`, **bold**
  - Replace: bg `accent.red`, fg `#1E1F22`, **bold**
- **Sections B/C (filename, diagnostics, git):** bg `#26282B`, fg `#E6E9EA`
- **Separator style:** soft, no powerline arrows by default; thin 1px `#3A3C3F`
- **Tabline:**
  - Active tab: `#303337` bg, text `#EAECEE`, bottom border `accent.warm`
  - Inactive: `#26282A` bg, text `#A9B2B0`

---

## 10) Git Integration

- **Diff colors (editor):**
  - Added (`DiffAdd`): bg `#233026`, fg `#B9E0B7`
  - Changed (`DiffChange`): bg `#24303A`, fg `#BFD8F2`
  - Removed (`DiffDelete`): bg `#3A2627`, fg `#F2B5B9`
- **Signs (`gitsigns.nvim`):**
  - Add: `accent.green`
  - Change: `accent.blue`
  - Delete: `accent.red`
- **Blame text:** `#848E8B` italic

---

## 11) Popups, Menus, CMP

- **Pmenu (completion):** bg `#2F3236`, fg `#E8EBEC`
- **PmenuSel:** bg `#3A3E43`, left border accent `accent.cyan`
- **Scrollbar:** track `#3B3E42`; thumb `#5A5F64`
- **LSP signature help:** `bg.float`, cyan titles, dim borders

---

## 12) Terminal & ANSI Mapping

- **Terminal background:** `bg.editor`
- **Terminal foreground:** `fg.default`
- **ANSI 0–7:** `#000000`, `#E06C75`, `#98C379`, `#E5C07B`, `#61AFEF`, `#C678DD`, `#56B6C2`, `#D0D4D6`
- **ANSI 8–15:** `#5A5F64`, `#F28BAA`, `#B6E3AA`, `#F3D29B`, `#9CCAF7`, `#E2B6F4`, `#9ADCE0`, `#FAFAFB`

---

## 13) UI Micro-details

- **Error/Warning inline signs (the small circles in the code gutter):**
  - Size: keep plugin default
  - Colors: same as diagnostics (red/yellow/cyan/teal)
  - No glow; maintain flat style that matches screenshot
- **Ruler/time chip (bottom right clock look in screenshot):**
  - Text: `#C9D0CE`
  - Chip bg: `#2A2C2F` with 1px border `#3A3C3F`
- **Search/replace current match:** thin underline `accent.yellow` instead of full bg fill, to keep it calm.

---

## 14) Accessibility & Options

- **Optional High-Contrast Toggle:** 
  - Raise `fg.default` to `#FFFFFF`
  - Deepen `bg.editor` to `#25272A`
  - Increase cursorline contrast to `#2F3236`
- **No italics mode:** switch `Comment` to `fg.dim` normal (for terminals lacking italics)
- **Protanopia-friendly preset:** replace `accent.red` with `#FF7A7A` and adjust `accent.green` to `#8BD3A4`

---

## 15) Implementation Hints (for later)

- Start with a Lua table exporting:
  - `palette = { ... }`
  - `groups = function(p) return { Normal = { fg = p.fg.default, bg = p.bg.editor }, ... } end`
- Support both `termguicolors` and reasonable cterm fallbacks.
- Provide `:colorscheme warm` and expose palette for statusline plugins.

---

## 16) Screenshot Parity Checklist

- [ ] Editor dark slate bg with slightly darker sidebar
- [ ] Warm line numbers; current line number a touch brighter
- [ ] Comments dim + italic
- [ ] Keywords a bit heavier (semibold look)
- [ ] Identifiers/links pop in cyan
- [ ] Subtle cursorline + selection (no harsh inversion)
- [ ] Diagnostics show colored dots in gutter and undercurls in text
- [ ] File tree uses warm for active/open folders and muted tones for hidden files
- [ ] Statusline has compact chips for mode with warm/cyan accents

---

### License / Attribution

- Theme design derived from your screenshot’s look and feel, color-matched where feasible. Final implementation will be original code under MIT unless you prefer otherwise.

If you want, I can turn this spec into a **starter Lua theme** next, with ready-to-drop `colors/warm.lua` + treesitter + gitsigns + lualine mappings.
