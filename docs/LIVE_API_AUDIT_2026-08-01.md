# Live PMIS API audit — 1 August 2026

## Method

The live API was queried with unauthenticated `GET` requests and compared with the OpenAPI document at `/swagger/v1/swagger.json`. This report records the response shape and availability, not the correctness of individual business values.

## Endpoint results

| Endpoint | HTTP/result | Live data | What is present / missing |
| --- | --- | --- | --- |
| `GET /api/CSS` | Success | 1 record | All documented CSS fields are present. `categoryStatus` and `classofDrugs` are single numeric fields; no generic `comments` field exists. |
| `GET /api/GPP` | Success | Empty array | Endpoint is healthy but there is no data available to verify actual returned field values. Schema has a single numeric `categoryStatus`; no `comments`. |
| `GET /api/GDP` | Success | Empty array | Endpoint is healthy but there is no data available to verify actual returned field values. Schema has a single numeric `categoryStatus`; no `comments`. |
| `GET /api/PMS` | **HTTP 500** | No response body | This is a backend defect. PMSA records cannot be fetched/reconciled, which can make post-sync state and duplicate diagnosis unreliable. |
| `GET /api/Enforcement` | Success | 1 record | The response contains the documented `comments` field, but it is `null` in the available record. `enfAction`, `qualificationId`, `licenseExpDate`, and `categoryOfpremisesOther` are also `null`. |
| `GET /api/RTS` | Success | Empty array | No data available to verify response values. Schema has no `comments` field. |
| `GET /api/ShiftMarket` | Success | 1 record | Documented fields are present. `contact`, `inspectorId`, `personName`, and `qualifications` are `null` in the available record. No `comments` field exists. |
| `GET /api/SM` | Success | Empty array | This is the endpoint used by the Sensitization Meeting client. No data available to verify response values; schema has no `comments` field. |
| `GET /api/Qualification` | Success | 1 record | `id`, `code`, and `name` are present. There is no custom-qualification/`otherQualification` field. |
| `GET /api/District` | Success | 137 records | `id`, `name`, `regionId`, and `region` are available. This is sufficient for a searchable, cached district selector. |
| `GET /api/Region` | Success | 12 records | Regions and their district relationships are available. |

## Confirmed API constraints

- **Generic comments:** only Enforcement has `comments`. PMSA has the three specific fields `followup_Comment`, `complaint_Product`, and `other_Activity`. CSS, GPP, GDP, RTS, Shift Market, and Sensitization Meeting do not accept a generic comment.
- **Multi-select:** CSS `categoryStatus`/`classofDrugs`, and GPP/GDP `categoryStatus`, are each a single `int32`. The API cannot persist multiple selections.
- **Qualification Other:** GPP, GDP, CSS, PMSA, and Enforcement accept only `qualificationId`; a typed “Other” value cannot be saved or restored.
- **Drug Shop Human/Vet:** the API accepts one `categoryOfpremises` integer. It does not publish distinct values/subtype fields for the requested split.
- **Duplicate guard:** the OpenAPI document does not define `Idempotency-Key`, a submission ID, duplicate-window logic, or a `409 Conflict` duplicate response.

## What can safely be implemented now

1. Searchable district selection, backed by the live `/api/District` cache.
2. Existing Enforcement comments and PMSA's existing activity-specific fields.
3. A display-only GDP/GSDP label change, after confirmation of the approved acronym.

## Backend work required before further form changes

1. Repair `GET /api/PMS` and add an integration test that returns PMSA records.
2. Add idempotency/submission-key support and an atomic duplicate guard to all creation endpoints.
3. Add persistence fields/contracts for generic comments, custom qualifications, Drug Shop subtype, and multi-select values.
4. Publish the revised OpenAPI document and sample payloads before mobile implementation.
