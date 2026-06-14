# Platforms — three ways to build the runtime

Pick per the grill; the runtime reference files are engine-agnostic.

## A. n8n (default — low-code, fastest)
- Chain the **n8n MCP** in its mandated order: `get_sdk_reference` → `get_suggested_nodes` →
  `search_nodes` → `get_node_types` → write → `validate_workflow` → `create_workflow_from_code`
  → `test_workflow`. Never guess node params.
- Webhook node (inbound lead), Twilio/SendGrid nodes (send), Wait/Schedule nodes (sequence
  timers), Data Tables (state). Good for one or a few clients, visual ops, fast iteration.
- Trade-off: opaque version control, per-execution limits at scale.

## B. Custom api-backend (full control)
- **Compose the `api-backend` sub-skill.** Typed webhook endpoints, a queue/worker for the
  sequence timers, signed webhooks, Supabase for state, reversible migrations.
- Pick when: many clients, custom logic, tight latency on the 5-min window, or productizing.
- Trade-off: more to build/host; api-backend owns the server, don't reimplement it here.

## C. Client owns a GHL-style SaaS
- The client already pays for GoHighLevel (or similar) with SMS/email/calendar built in.
- Wire only the **missing** pieces via its API/automation builder; don't rebuild what it has.
- Trade-off: locked to their platform's limits; cheapest to deliver.

## Decision
Default **A** for the first client/MVP. Move to **B** when productizing or at scale. Use **C**
when the client insists on their existing stack.
