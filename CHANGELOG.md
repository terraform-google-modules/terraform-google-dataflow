# Change Log

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](http://keepachangelog.com/) and this
project adheres to [Semantic Versioning](http://semver.org/).

## [2.5.0](https://github.com/terraform-google-modules/terraform-google-dataflow/compare/v2.4.0...v2.5.0) (2024-10-30)


### Features

* **deps:** Update Terraform google to v6 ([#79](https://github.com/terraform-google-modules/terraform-google-dataflow/issues/79)) ([ec28497](https://github.com/terraform-google-modules/terraform-google-dataflow/commit/ec284970e085e9715a53d962ccd9b924b287c50d))

## [2.4.0](https://github.com/terraform-google-modules/terraform-google-dataflow/compare/v2.3.0...v2.4.0) (2023-12-14)


### Features

* Add support for additional_experiments dataflow job field ([#64](https://github.com/terraform-google-modules/terraform-google-dataflow/issues/64)) ([5e1c674](https://github.com/terraform-google-modules/terraform-google-dataflow/commit/5e1c674624b660c6d63aa571dfeccafbdfc279f1))

## [2.3.0](https://github.com/terraform-google-modules/terraform-google-dataflow/compare/v2.2.0...v2.3.0) (2023-12-08)


### Features

* Adds support to labels ([#57](https://github.com/terraform-google-modules/terraform-google-dataflow/issues/57)) ([61341f0](https://github.com/terraform-google-modules/terraform-google-dataflow/commit/61341f0fd2b6d0dc2c381484c1acd947da6de533))


### Bug Fixes

* upgraded versions.tf to include minor bumps from tpg v5 ([#60](https://github.com/terraform-google-modules/terraform-google-dataflow/issues/60)) ([b70ddf9](https://github.com/terraform-google-modules/terraform-google-dataflow/commit/b70ddf99fc4a1ee4a86f114a5d4783dc52d911db))

## [2.2.0](https://github.com/terraform-google-modules/terraform-google-dataflow/compare/v2.1.0...v2.2.0) (2022-02-23)


### Features

* update TPG version constraints to allow 4.0 ([#34](https://github.com/terraform-google-modules/terraform-google-dataflow/issues/34)) ([374ab2d](https://github.com/terraform-google-modules/terraform-google-dataflow/commit/374ab2d2c7cd05ce1a156400d8fe6ce48d7a4a91))

## [2.1.0](https://www.github.com/terraform-google-modules/terraform-google-dataflow/compare/v2.0.0...v2.1.0) (2021-07-07)


### Features

* Add CMEK support ([#28](https://www.github.com/terraform-google-modules/terraform-google-dataflow/issues/28)) ([604207b](https://www.github.com/terraform-google-modules/terraform-google-dataflow/commit/604207be49d1b11a854eed68067979b8148aadd7))

## [2.0.0](https://www.github.com/terraform-google-modules/terraform-google-dataflow/compare/v1.0.0...v2.0.0) (2021-07-01)


### ⚠ BREAKING CHANGES

* add Terraform 0.13 constraint and module attribution (#24)

### Features

* add Terraform 0.13 constraint and module attribution ([#24](https://www.github.com/terraform-google-modules/terraform-google-dataflow/issues/24)) ([c90fe5c](https://www.github.com/terraform-google-modules/terraform-google-dataflow/commit/c90fe5c86a440c1e92614c466a77709dd4e3b261))
* Allow dataflow to accept full self_link for working with shared vpc networks. ([#18](https://www.github.com/terraform-google-modules/terraform-google-dataflow/issues/18)) ([4194dea](https://www.github.com/terraform-google-modules/terraform-google-dataflow/commit/4194dea146a1dc8483157d03acbc44e9d122b6bd))


### Miscellaneous Chores

* release 2.0.0 ([db1f0ca](https://www.github.com/terraform-google-modules/terraform-google-dataflow/commit/db1f0ca715c09e56e8676e8712c28941b191a685))

## [Unreleased]

## [1.0.0]

### Changed

- Supported version of Terraform is 0.12. [#8]

## [0.3.0] - 2019-06-19

### Added

* Add zone argument [#5]

## [0.2.0] - 2019-06-19

### Added

* Add network, subnetwork and machine_type arguments [#4]

## v0.1.0 2019-04-05

### Added

* Initial release of module.

[Unreleased]: https://github.com/terraform-google-modules/terraform-google-kubernetes-engine/compare/v1.0.0...HEAD
[1.0.0]: https://github.com/terraform-google-modules/terraform-google-dataflow/compare/v0.3.0...v1.0.0
[0.3.0]: https://github.com/terraform-google-modules/terraform-google-dataflow/compare/v0.2.0...v0.3.0
[0.2.0]: https://github.com/terraform-google-modules/terraform-google-dataflow/compare/v0.1.0...v0.2.0

[#8]: https://github.com/terraform-google-modules/terraform-google-dataflow/pull/8
[#5]: https://github.com/terraform-google-modules/terraform-google-dataflow/pull/5
[#4]: https://github.com/terraform-google-modules/terraform-google-dataflow/pull/4
