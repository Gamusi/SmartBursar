# Backend API Guide

## Principles

- Keep endpoints small and predictable.
- Model API behavior around real school tasks.
- Return clear JSON responses with consistent status codes.
- Validate input at the boundary using Pydantic.

## Versioning

Use an explicit API version prefix, for example:
- `GET /api/v1/students`
- `POST /api/v1/payments`

## Recommended routes

- `GET /students`
- `GET /students/{id}`
- `POST /students`
- `PUT /students/{id}`
- `DELETE /students/{id}`

- `GET /payments`
- `POST /payments`
- `GET /payments/{id}`

- `GET /expenses`
- `POST /expenses`

- `GET /cashbook`
- `GET /reports/daily-collection`
- `GET /reports/student-statement/{student_id}`

## Error handling

- Use `400` for bad requests
- Use `404` for missing resources
- Use `422` for validation errors
- Use `500` only for unexpected failures

## Notes

Simple APIs are easier to maintain and test.
Avoid adding generic query features until the product needs them.
