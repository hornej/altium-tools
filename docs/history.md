# History and repository split

On 2026-11-12 the three Altium skills were extracted from
[hornej/hw-skills](https://github.com/hornej/hw-skills). The published source
baseline was `6cc7da5ba94a2fafb61fc99dbdd12db14270084a`; the extraction input
`267c21fc4d8d75a9d59a5e16d2d119ea92dd4f26` also contained research documentation
which was excluded from the Altium history.

`git-filter-repo` 2.47.0 retained these paths:

- `altium-library-migrate/`
- `altium-365-library-maintain/`
- `altium-design-review/`
- `LICENSE`, `.gitignore`, `.gitattributes`

Filtering preserves file changes, authors, author/committer dates and messages,
while producing new commit IDs and omitting commits unrelated to these paths.
The source repository history is unchanged. The nine commits below form the
published extracted history before repository setup changes. All 54 tracked
skill files were byte-identical to the source before integration edits.

| Original commit | Extracted commit |
| --- | --- |
| [bb97351](https://github.com/hornej/hw-skills/commit/bb973511f434c7d6c3d7f19471857b009590602c) | [833100a](https://github.com/hornej/altium-tools/commit/833100ab9c5695d07dfd7c81cb78cacc24ca58df) |
| [04ea56f](https://github.com/hornej/hw-skills/commit/04ea56f29bba3234def3a132640032a44a8af082) | [27acfb2](https://github.com/hornej/altium-tools/commit/27acfb2eac506a2e96340a57e61e47eda43774c4) |
| [f27537b](https://github.com/hornej/hw-skills/commit/f27537b093b967d73f6be109d7bd61b78301f75c) | [84c3704](https://github.com/hornej/altium-tools/commit/84c37047005f4bbaf41ac17815c516ef9987bffc) |
| [c9ad08f](https://github.com/hornej/hw-skills/commit/c9ad08f764532f7676745d30343cdb165f8fd5ea) | [7e1e309](https://github.com/hornej/altium-tools/commit/7e1e309a9d1ff0e3b1d25fbfda17ce45d528d5b1) |
| [9d923ee](https://github.com/hornej/hw-skills/commit/9d923eea4d7236aaa741066bb82eb74683179ef6) | [0547993](https://github.com/hornej/altium-tools/commit/054799367d8d745f3fbaed89d6e01d0d07e660bb) |
| [b70d0c5](https://github.com/hornej/hw-skills/commit/b70d0c51471e3be83fac4d0ea589a04f83bc4cab) | [86bb1e5](https://github.com/hornej/altium-tools/commit/86bb1e57d6a172978c267372cf84b7300fb36c68) |
| [6cd847e](https://github.com/hornej/hw-skills/commit/6cd847ea46c0ac5cb5dc4739a5a542577c07ed0e) | [d4d7779](https://github.com/hornej/altium-tools/commit/d4d7779654d5e01d7aab9e2bb28a2ee47f696798) |
| [b00f0f7](https://github.com/hornej/hw-skills/commit/b00f0f7211729160cd789995834401754ad55bae) | [65e552d](https://github.com/hornej/altium-tools/commit/65e552dcb115b67813f0662eef9ca12d4d07678d) |
| [6cc7da5](https://github.com/hornej/hw-skills/commit/6cc7da5ba94a2fafb61fc99dbdd12db14270084a) | [6d7479a](https://github.com/hornej/altium-tools/commit/6d7479a10823159df9855d737362c3f55eae6440) |

The subsequent setup commit adds this README, independent CI and cross-repository
references. Portable component and grounding guidance continues in
`hw-skills/hardware-design-review`; forwarding references remain at the old
Altium reference paths. Existing skill names, helper CLIs and test fixtures stay
stable. The mixed CSV/Altium variant audit remains an Altium helper with its
existing schema and behavior.

Third-party installed MCP servers, DelphiScript reference packages and engine
checkouts were not copied or relicensed into this repository. Their locations
and registration are independent of the moved skill folders.
