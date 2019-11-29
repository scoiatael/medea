# Changelog
All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## Unreleased
### Changed:
- `location_queries/inside` returns 400 Bad Request instead of 500 when given query is not a Point geometry.

### Added
- `PUT location_commands/create/:id` endpoint for creating new Location with id - idempotent,
- `POST location_commands/create` endpoint for creating new Location, non-idempotent,
- `GET location_queries/by_id/:id` endpoint for querying Location by id,

## [1.1.0] - 2019-11-27
### Changed:
- Use own implementation of point-in-polygon check; this removes runtime dependency on geos.

## [1.0.0] - 2019-11-26
### Added:
- API endpoint for getting all areas,
- API endpoint for querying if given point is inside any of areas,

## [0.0.1] - 2019-11-25
### Added:
- This CHANGELOG file to hopefully serve as an evolving example of a
  standardized open source project CHANGELOG.
- Skeleton of the new microservice with rails & rspec

[Unreleased]: https://github.com/scoiatael/medea/compare/v1.1.0...HEAD
[1.1.0]: https://github.com/scoiatael/medea/compare/v1.0.0...v1.1.0
[1.0.0]: https://github.com/scoiatael/medea/compare/v0.0.1...v1.0.0
[0.0.1]: https://github.com/scoiatael/medea/releases/tag/v0.0.1
