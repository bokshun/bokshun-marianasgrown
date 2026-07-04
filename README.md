# Marianas Grown Website

Static GitHub Pages site for `marianasgrown.com`.

## Edit products and music

Update checkout links, item names, and prices in `site-config.js`.

Recommended ways to sell music without a backend:

- Bandcamp: best for albums, singles, and fan-supported music sales.
- Gumroad: simple digital downloads and merch links.
- Stripe Payment Links: direct checkout links for apparel or downloads.
- Shopify Starter or Buy Buttons: better when inventory, shipping, and variants matter.

Replace every `https://example.com/replace-with-*` URL before launch.

## Email signup

The form in `index.html` points to a placeholder Formspree URL:

```html
https://formspree.io/f/your-form-id
```

Replace it with your real Formspree, Mailchimp, ConvertKit, or Klaviyo endpoint.

## GitHub Pages setup

1. Create a public repository under `bokshun` named `marianasgrown.com` or any repository name you prefer.
2. Upload these files to the repository root.
3. In GitHub, go to `Settings > Pages`.
4. Set `Source` to `Deploy from a branch`.
5. Set branch to `main` and folder to `/root`.
6. Save.
7. In `Settings > Pages`, set the custom domain to `marianasgrown.com`.

## DNS setup

At your domain registrar, point `marianasgrown.com` to GitHub Pages using GitHub's current Pages DNS records.
For the `www` hostname, create a CNAME record from `www` to your GitHub Pages host, usually:

```text
bokshun.github.io
```

After DNS propagates, enable `Enforce HTTPS` in GitHub Pages.
