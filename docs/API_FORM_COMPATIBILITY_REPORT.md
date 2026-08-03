# PMIS form/API compatibility report

**Checked:** 1 August 2026 against the live OpenAPI contract at `http://pmis.nda.or.ug/swagger/v1/swagger.json`.

## Summary

The API schemas use `additionalProperties: false`. A field that is not listed in a module's schema must **not** be added to the mobile POST body: it may be rejected or silently not persisted. The app should therefore wait for an API/schema change before offering input that cannot survive a refresh.

| Requested change | API status | Conclusion |
| --- | --- | --- |
| Generic `comments` field | Supported only by Enforcement (`comments`) | Add/keep it for Enforcement only. It is not supported by CSS, GPP, GDP, RTS, Shift Market, or Sensitization Meeting. |
| PMSA comments | Supported as `followup_Comment`, `complaint_Product`, and `other_Activity` | PMSA must use these activity-specific fields, not one generic `comments` field. |
| Multi-select Category Status / Category of Drugs (GPP, GDP, CSS) | `categoryStatus` is a single nullable `int32` in each schema | Backend must change this to an array/related collection before the client can persist several selections. |
| Multi-select Class of Drugs (CSS) | `classofDrugs` is a single nullable `int32` | Backend schema change required. |
| Qualification `Other` plus typed value | GPP/GDP/CSS/PMSA/Enforcement expose only `qualificationId`; no `otherQualification` field | Backend schema change required. The current `Qualification` master data supports only `id`, `code`, and `name`. |
| Drug Shop – Human / Drug Shop – Vet | All applicable forms expose one integer `categoryOfpremises` | Backend must define distinct enum values (or an additional subtype) for the two options. Mapping both labels to the existing Drug Shop code would lose the choice on refresh. |
| Searchable district | All listed forms accept a single `districtId` | Safe client-side improvement. It can use cached district master data offline and post the existing numeric ID. |
| Rename GDP to GSDP | Naming-only | Safe after product owner confirms that `GSDP` is the intended approved acronym. |

## POST schema field inventory

- **CSS:** no generic comment field; `categoryStatus` and `classofDrugs` are single integers.
- **GPP:** no generic comment field; `categoryStatus` is a single integer.
- **GDP:** no generic comment field; `categoryStatus` is a single integer.
- **PMSA:** supports `samples[]`, `followup_Comment`, `complaint_Product`, and `other_Activity`.
- **Enforcement:** supports `comments` and `enfAction`.
- **Radio Talk Show:** supports only inspection/location/venue/topic/participants fields; no comments.
- **Shift Market:** supports `regulatoryAction` and `consignment`; no comments.
- **Sensitization Meeting:** supports inspection/location/topic/participants fields; no comments.

## Duplicate submissions

The OpenAPI contract does not document an `Idempotency-Key`, `submissionId`, duplicate-window setting, or a `409 Conflict` response. The mobile client can guard double taps and send an idempotency header, but server-side protection needs an API/database change:

1. Accept and persist an idempotency key per POST.
2. Return the original successful result when the same key is retried.
3. As fallback, atomically reject an identical same-inspector submission inside a configurable window (recommended: 30 seconds) with `409 Conflict` and the original record ID.

## Recommendation before further client work

1. Implement searchable districts now; it is compatible with every listed API.
2. Keep PMSA's existing activity-specific comments and Enforcement's existing `comments` field.
3. Obtain backend schema changes for generic comments, multi-select values, custom qualifications, and Drug Shop Human/Vet before exposing those inputs in production.
4. Deploy the idempotency/deduplication API contract before relying on it for PMSA duplicate prevention.
