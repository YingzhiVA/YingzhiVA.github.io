# Open Graph card generators

Each `*-card.html` here is a standalone 1200x630 page that renders to the PNG a
social platform shows when the article is shared. Run `./render.sh` to rebuild
both.

| Generator | Output | Used by |
| --- | --- | --- |
| `leakage-card.html` | `notes/referral-analytics/encoder-first/leakage-card.png` | Field note No. 01, and the series index |
| `fold-spread-card.html` | `notes/referral-analytics/stop-tuning/fold-spread-card.png` | Field note No. 02 |

## The SVG is duplicated

Each generator holds a **copy** of the hero diagram from its article. Nothing
keeps the two in sync. Edit a diagram in an article and its card silently goes
stale until you mirror the change here and re-run `render.sh`.

The copies live at:

- `notes/referral-analytics/encoder-first/index.html`, the `<figure>` in the hero
- `notes/referral-analytics/stop-tuning/index.html`, the `<figure>` in the hero

## Why the cards are built rather than reused

`og:image` needs a real raster file at an absolute URL. The heroes are inline
SVG styled by the page's CSS custom properties, and social scrapers render
neither inline SVG nor SVG files, so the diagram is re-declared here with the
light palette resolved to literal hex values.

## Layout

Both cards use one template: 56px padding, an 18px mono eyebrow, a 52px/800
title, then the diagram in a bordered figure.

The figure widths differ on purpose. The two diagrams have different aspect
ratios (660x278 and 660x250), so a shared width would leave one card with dead
space. Matching the *vertical band* instead keeps the margins identical:

- `leakage-card.html` — figure 957px wide
- `fold-spread-card.html` — figure 1064px wide

Both are light-theme only. Scrapers do not carry a viewer theme, so a single
committed palette is correct.

## Fonts

The template asks for Ubuntu Sans and Ubuntu Mono rather than the site's
`-apple-system` / Segoe UI stack, because those are what this machine has
installed. Rendering elsewhere may shift the type. If you want the cards to
match the live site exactly, install the real faces and update the `--sans` and
`--mono` values in both generators.

## Chromium is a snap

`which chromium` resolves to `/snap/bin/chromium`, which is confined: it has a
private `/tmp` and cannot read paths outside `$HOME`. Rendering from a temp
directory reports "bytes written" and produces a screenshot of Chromium's own
"Your file couldn't be accessed" error page. `render.sh` works around this by
staging the source HTML next to its output. Pass a `file://` URL, not a bare
path.

## Meta tags

Each article declares `og:image`, `og:image:width` (1200), `og:image:height`
(630), `og:image:alt`, and `twitter:image`. Changing a card's dimensions means
updating the width and height tags too.
