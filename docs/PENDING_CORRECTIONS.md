# PMIS correction backlog

Captured on 1 August 2026 from the latest review feedback.  These are pending tasks; none of them is represented as completed by this document.

## P0 — prevent duplicate submissions (backend API and caller)

- [ ] Add an idempotency mechanism to every activity-creation `POST` endpoint (CSS, GPP, GDP/GSDP, PMSA, Enforcement, Shift Market, Radio Talk Show, and Sensitization Meeting).
  - The mobile app/caller should create one UUID per attempted submission and send it in an `Idempotency-Key` header (or a documented `submissionId` field); retries must reuse the same value.
  - The API must store the key with the created record and return the original successful result for a replay, without inserting another row.
  - As a safety net for callers that cannot send a key, reject a semantically identical payload from the same inspector within a configurable short interval (recommended initial value: 30 seconds). The comparison must be performed atomically in the database to avoid concurrent duplicates.
  - Return `409 Conflict` for a rejected fallback duplicate, including the existing record ID and a user-safe message.
  - Client handling: disable the submit button while a request is in flight; on a timeout/retry, reuse the idempotency key and treat a replayed success as success.
  - Add API integration tests for double taps, retry-after-timeout, concurrent requests, and two genuinely distinct records created close together.

## P1 — form and master-data corrections

- [ ] **GPP, GDP/GSDP, CSS:** support choosing multiple values for Category Status / Category of Drugs. Update the API contract and persistence from a single value to a collection, then show all saved selections in detail and list views.
- [ ] **CSS:** support choosing multiple values for Class of Drugs, including API persistence and detail rendering.
- [ ] **GPP, GDP/GSDP, CSS, PMSA, Enforcement:** split the `Drug Shop` premise option into `Drug Shop – Human` and `Drug Shop – Vet` in the shared premises master data and all affected forms.
- [ ] **GPP, GDP/GSDP, CSS, PMSA, Enforcement:** add an `Other` qualification option. When selected, require a free-text qualification value; extend the API payload/schema so it survives refresh and sync.
- [ ] **GPP, GDP/GSDP, CSS, PMSA, Enforcement, Radio Talk Show, Shift Market, Sensitization Meeting:** make District a searchable selector. It must work against locally cached district data when offline.
- [ ] **CSS, GPP, GDP/GSDP, PMSA, Shift Market, Radio Talk Show, Sensitization Meeting:** add a comment field, persist it through the API and offline sync, and display it in details. Confirm whether Enforcement's existing comment field already satisfies the same requirement.

## P2 — naming and consistency

- [ ] Confirm the approved expansion/name for GDP versus `GSDP`; then rename the form, navigation label, detail title, API documentation, and website consistently. This is left as a confirmation task because the supplied feedback says “Rename GDP to GSDP” but does not define the new acronym.
- [ ] Add end-to-end regression tests for each affected form: save online, save offline, sync, refresh, reopen, and verify every multi-value/custom value/comment/district remains unchanged.

## Delivery order

1. Backend team documents and implements the new collection, custom-value, comment, searchable-master-data, and idempotency contracts.
2. Mobile app adopts the contracts and adds reusable multi-select, searchable district, and conditional `Other` components.
3. QA verifies online/offline sync and duplicate handling across every listed module before release.

## Scope note

This repository contains the Flutter client. The API schema, database constraints, idempotency store, and duplicate-submission guard require work in the server repository/deployment as well as the client changes.
