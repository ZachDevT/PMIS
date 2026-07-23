# PMIS API limitations and deferred work

Last verified: 23 July 2026 against `http://pmis.nda.or.ug/swagger/v1/swagger.json` and live POST/GET diagnostics.

This document records functionality that cannot be completed reliably in the mobile application without corresponding API or web changes. It is not a list of the mobile fixes already delivered.

## Shift Market editing

- The Shift Market API exposes create and read operations (`POST`, `GET`, and `GET /{id}`).
- It does not expose `PUT` or `PATCH` for updating a saved record.
- Mobile edit support was intentionally not implemented. Adding a local-only edit would be misleading because the change could not be persisted to the server.

Required backend work: add a documented update endpoint, validation rules, and a response contract.

## Multiple CSS actions

- The CSS request schema defines `action` as one nullable integer.
- The mobile workflow has allowed users to select multiple actions.
- Only one action can be represented by the current API contract, so multiple CSS actions cannot survive a server round trip without data loss.

Required backend work: change `action` to an array/list, or introduce a child collection for CSS actions. The GET response must return the same structure.

## Previously licensed / illegal outlet

- The mobile forms capture the distinction between a previously licensed outlet and an illegal outlet.
- GPP, GDP, PMSA, and Enforcement do not provide a consistent field that preserves this value through POST and GET.
- Some endpoints expose an `unlicensed` integer, but that is not an equivalent, documented representation of the full selection.

Required backend work: add a common enum/field to the affected schemas and expose the same field in the website forms.

## Date and timezone semantics

- All eight modules accept an ISO-8601 date-time.
- Live diagnostics sent `2026-07-23T12:34:56+03:00` to CSS, GPP, GDP, PMSA, Enforcement, Shift Market, RTS, and Sensitization Meeting.
- Every subsequent GET returned `2026-07-23T12:34:56`, preserving the clock time but removing the `+03:00` timezone offset.
- The current mobile app treats these API values as Kampala wall-clock values. The stale time previously seen in forms was fixed in the app by refreshing the timestamp whenever a form opens.

Required backend work: define whether `inspectionDate` is UTC or local time and preserve an offset (or return a `Z` UTC timestamp). A timezone-less value is ambiguous for clients outside East Africa.

## Historical region/district inconsistencies

- District belongs to a region, and the mobile app now derives the region from the selected district.
- Existing server records may already contain a district paired with the wrong region GUID.
- The app repairs display using current district master data, but it cannot rewrite historical server records without update endpoints and an approved migration.

Required backend work: enforce district-to-region consistency during POST/update and migrate inconsistent historical rows.

## Master-data availability offline

- Regions, districts, and qualifications are dynamic API data and are cached by the mobile app after a successful fetch.
- A completely fresh installation that has never connected cannot know master-data changes made after the application build.

Required backend/product decision: either ship a versioned baseline dataset, guarantee an initial online setup, or provide a formally versioned master-data synchronization endpoint.

## Diagnostic records

Timestamp investigations created clearly labelled records with inspector/facility name `TIME_DIAGNOSTIC_20260723`. They prove POST-to-GET time preservation and can be removed administratively if test records should not remain in production data.

