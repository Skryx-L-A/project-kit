---
name: ecommerce-store
description: Stand up an e-commerce STORE / storefront in a project folder from the user's answers — Shopify-first, with a product catalog, collections, inventory, a working checkout, a discount, and analytics wired up. A project-kit sub-skill loaded by new-project's routing whenever the user wants to BUILD an online store / storefront / sell products / set up Shopify / a shop with checkout. Technical build only; the acquisition/marketing money strategy is build-business's job. Composes with website (custom storefront) and chains the Shopify MCP.
---

# ecommerce-store — get a real store live with a working checkout

## What this sub-skill is for
Standing up an **e-commerce store**: a product catalog, collections, inventory, a discount,
and a **checkout that actually completes**, plus analytics. Loaded by `new-project` when the
project is "sell products online". **Shopify-first** (driven by the Shopify MCP); for a fully
custom build it composes with `website` (storefront) + `api-backend` (cart/checkout API).
Scope is the **technical storefront** — getting it live and transacting. The money/marketing
side (offers, ads, acquisition) is **`build-business`'s** job; chain it when the user wants
customers, not just a store.

## Mandatory grill-questions (fold into the Definition of Ready)
- **Platform:** Shopify (default — via the Shopify MCP) or a **custom** stack (`website`
  storefront + `api-backend`)? Shopify unless there's a real reason to hand-roll checkout.
- **Catalog:** what products, how many SKUs, variants (size/colour), pricing, digital vs.
  physical? Where do product data + images come from?
- **Payments, region & tax:** which payment providers, selling into which countries, and what
  **tax / VAT** handling? (Shopify Payments availability varies by region — confirm.)
- **Shipping:** rates, zones, free-shipping threshold, fulfillment (self / 3PL / dropship)?
- **Theme & brand:** colours, logo, typography, voice — harvest a reference look if the user
  has one.
- **Channels:** web only, or also social / marketplace? Domain to use?

## Project sub-agents to generate (`.claude/agents/`)
- **catalog-builder** — creates products, variants, and collections and sets inventory via
  the Shopify MCP (or the custom API), keeping titles/SKUs/prices consistent
  (delegate-by-default for catalog work). Confirms before publishing live products.
- **storefront-themer** — sets up the theme / brand (Shopify theme settings, or the `website`
  storefront), responsive and on-brand; pulls tokens from a harvested reference.
- **listing-copywriter** — writes product titles, descriptions, and metadata that are
  **accurate** and conversion-aware — benefits and real specs, no invented claims.
- **analytics-reporter** — wires analytics and runs ShopifyQL / `run-analytics-query` to
  report sales, orders, and product performance; never fabricates numbers.

## Tools / CLIs / MCP / skills needed
- **Shopify MCP (chain — primary):** `get-new-store-previews` to spin up a store from a
  description (let the user browse previews and sign up through the link), then
  `create-product`, `create-collection`, `add-to-collection`, `set-inventory`,
  `create-discount`, `run-analytics-query`, `get-shop-info`, and `graphql_query` /
  `graphql_mutation` for anything without a built-in tool (metafields, pages, markets, etc.).
- **`web-aeo`** (chain) — `llms.txt` + schema.org Product/Offer structured data so the store
  is legible to AI assistants and search.
- **`design-harvest`** (chain) — pull palette/typography/layout tokens from a reference shop
  for the theme (patterns/tokens only, never copy assets/code).
- **Compose, don't duplicate:** `website` for a custom storefront, `api-backend` for a custom
  cart/checkout, **`build-business`** for the acquisition/marketing engine.
- **Global skills/agents to chain:** `deep-research` (payment/tax/region rules, platform
  trade-offs), `verify` (walk a real checkout end-to-end), `code-review` (custom-storefront
  code), `market-researcher` (agent) for facts on fees / payment providers / shipping.

## File / asset nudges (on top of the base set)
- `STORE.md` — platform, store URL/domain, payment + tax + shipping config, and the channel
  list. Single source of truth for how the shop is set up.
- `catalog/` — product source data (titles, descriptions, prices, SKUs, variants) and the
  collection structure, version-controlled before it's pushed live.
- `assets/products/` — product imagery (own or licensed — track the license).
- `POLICIES.md` — returns / refunds / shipping / privacy text, drafted to the relevant
  consumer law, ready to paste into the store's policy pages.
- `.env.template` — any API keys/tokens as empty keys; real `.env` git-ignored (never commit
  Shopify or payment credentials).

## Stack defaults & done-bar
**Default stack:** Shopify via the Shopify MCP — store from `get-new-store-previews`, catalog
+ collections + inventory through the MCP tools, Shopify Payments + Shopify-managed checkout,
a percentage discount code, analytics via ShopifyQL, schema.org from `web-aeo`. Swap to a
`website` + `api-backend` custom build only when the grill calls for it.
**Done-bar (all must hold):**
1. The store is **live** with **real products** in at least one collection, inventory set.
2. **Checkout completes** — a test order goes through end-to-end (`verify`), payment +
   shipping + tax resolving correctly for the target region.
3. At least one **discount code** exists and applies correctly at checkout.
4. **Analytics is wired** and returns real sales/traffic data (ShopifyQL or the chosen tool).
5. Product listings are accurate; returns/shipping/privacy policies are present.

## Guardrails
- **No fake reviews and no fake scarcity** — no invented "12 people are viewing", fake
  countdowns, or planted testimonials. Social proof must be real.
- **Consumer-law / returns compliance** — a clear, lawful returns + refund + shipping +
  privacy policy for the selling region; don't ship a store that can't legally take an order.
- **Product claims must be accurate** — describe what the product actually is and does; no
  unverifiable health/performance/"best" claims. Flag anything the user can't substantiate.
- **Never expose payment or store secrets** — API keys, Shopify Admin tokens, and payment
  credentials live in env / the platform vault, never in the repo, listings, or chat.
- **Confirm before going live / charging** — publishing products, taking real payments, and
  creating discounts are outward-facing; confirm with the user first.
- NO emojis in store UI, product copy, or notifications. Commits under the user's own name
  only (Skryx-L-A) — never add Claude as a co-author. Never commit secrets / API keys.
