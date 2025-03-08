# Changelog

## 1.0.0 (2025-03-08)


### ⚠ BREAKING CHANGES

* **threads:** only show valid frames
* specify adapters for which the terminal should be hidden ([#10](https://github.com/igorlfs/nvim-dap-view/issues/10))
* avoid boolean concat
* remove hooks that close the plugin on session end
* swapped `show`

### fixup

* avoid boolean concat ([3b79d9d](https://github.com/igorlfs/nvim-dap-view/commit/3b79d9de31c45f461e0e39570b176113aeb93e2c))
* swapped `show` ([08ad351](https://github.com/igorlfs/nvim-dap-view/commit/08ad351aecb76e3f6afb4db3e04d2fc835397ced))


### Features

* `DapViewToggle!`, `DapViewClose!`, start_hidden option ([#17](https://github.com/igorlfs/nvim-dap-view/issues/17)) ([c86697c](https://github.com/igorlfs/nvim-dap-view/commit/c86697ce5ee5bd7930f3ec3895b8a7b01a98bc52))
* adds filetypes to dap-view buffers ([5d8daeb](https://github.com/igorlfs/nvim-dap-view/commit/5d8daeb5c9d4922914c2fde3a386ebe6371be701))
* allow evaluating more complex expressions ([ba72154](https://github.com/igorlfs/nvim-dap-view/commit/ba721546577e1c16bbb24e252ee62693e57790d4))
* basic config validation ([28d0d54](https://github.com/igorlfs/nvim-dap-view/commit/28d0d542caaddf38e3cfbd9c295db35ad9ff37fe))
* **breakpoints:** jump to a breakpoint ([90da63c](https://github.com/igorlfs/nvim-dap-view/commit/90da63caa5fedc9e5571bebc7934980eeed16ab1))
* close term window if outside of session ([17ec283](https://github.com/igorlfs/nvim-dap-view/commit/17ec2831dd94b06188cd442c31865ce35123364b))
* **config:** allow hiding winbar ([3eddba5](https://github.com/igorlfs/nvim-dap-view/commit/3eddba5b5b0879e6e1e5720c1b2e57567db3e015))
* configurable height ([84dbbcf](https://github.com/igorlfs/nvim-dap-view/commit/84dbbcf79dd5576da2eef14b17d76e7fd86e74b0))
* define custom hl groups ([29f6e7a](https://github.com/igorlfs/nvim-dap-view/commit/29f6e7a16c014423d55951017efe8ff9957aa202))
* delete watch expr ([1fbebae](https://github.com/igorlfs/nvim-dap-view/commit/1fbebaeb3badc760928cf5cf79a2949bb64f3160))
* edit expression ([fba18ea](https://github.com/igorlfs/nvim-dap-view/commit/fba18eae850740e9f21b65465855fc96657e6c58))
* experimental REPL support ([49ce20e](https://github.com/igorlfs/nvim-dap-view/commit/49ce20eef5226cc40f769076ed7cba96a9e9bf2e))
* expose terminal bufnr/winnr in state module ([#19](https://github.com/igorlfs/nvim-dap-view/issues/19)) ([a0c5f9f](https://github.com/igorlfs/nvim-dap-view/commit/a0c5f9f59a3b65397c01de12722ecf1eae00a52e))
* expose user commands ([6695fd1](https://github.com/igorlfs/nvim-dap-view/commit/6695fd1ad42fbbd2d7ffdb90042ccc5ad2e3a2f3))
* handle emptiness in views ([a59639a](https://github.com/igorlfs/nvim-dap-view/commit/a59639ae46ef4d9feed721d675bfc0d6982eaa1e))
* highlight variables that were updated with a different color ([4fb6235](https://github.com/igorlfs/nvim-dap-view/commit/4fb62357ce36554526060d470cf27135eb297bf6))
* hijack terminal ([ab13019](https://github.com/igorlfs/nvim-dap-view/commit/ab13019b9d3705d7e97c7fcf02dbbc528ec5b297))
* only add expr if not present ([40e36bf](https://github.com/igorlfs/nvim-dap-view/commit/40e36bf0674e2a60f125da4ff350c3943e92d3c5))
* redraw view after expressions are evaluated ([34bc1ec](https://github.com/igorlfs/nvim-dap-view/commit/34bc1ecd0f65e8b1a2c565177c9e8b685159abc0))
* remove hooks that close the plugin on session end ([9ae880f](https://github.com/igorlfs/nvim-dap-view/commit/9ae880f27c4a5eac7a61aae8bc68d60fc67d17f3))
* slightly better error handling when evaluating ([0215c6b](https://github.com/igorlfs/nvim-dap-view/commit/0215c6be14f6f1f1cce20929687ddb6882e22c49))
* specify adapters for which the terminal should be hidden ([#10](https://github.com/igorlfs/nvim-dap-view/issues/10)) ([80381ef](https://github.com/igorlfs/nvim-dap-view/commit/80381efd1d2684880e842fecbc215a38489a9ebf))
* start watches view ([8a16d0a](https://github.com/igorlfs/nvim-dap-view/commit/8a16d0a2a83f0166b035f69fa876646503ac9670))
* support opening terminal in any direction ([72ba31f](https://github.com/igorlfs/nvim-dap-view/commit/72ba31fa15107659ff049bc7a046d1f9619ddd36))
* **terminal:** config position ([#9](https://github.com/igorlfs/nvim-dap-view/issues/9)) ([273bcde](https://github.com/igorlfs/nvim-dap-view/commit/273bcde82713604d8ef489a28dff3f514bf69bfa))
* threads and stacks view ([#20](https://github.com/igorlfs/nvim-dap-view/issues/20)) ([360a97f](https://github.com/igorlfs/nvim-dap-view/commit/360a97f627ffc972f710f179dc62bbad36bd09d6))
* **threads:** only show valid frames ([0e3aa00](https://github.com/igorlfs/nvim-dap-view/commit/0e3aa00a8ae86f4d304aa01da3c72f97b23466ae))
* toggle with term ([c86697c](https://github.com/igorlfs/nvim-dap-view/commit/c86697ce5ee5bd7930f3ec3895b8a7b01a98bc52))
* use top-level split ([71ed672](https://github.com/igorlfs/nvim-dap-view/commit/71ed6720f04650bd0a21e36283ff15a4111d2ae7))
* watches MVP ([2bbd070](https://github.com/igorlfs/nvim-dap-view/commit/2bbd070cc1936061cb918b4580c4cf95b79222b4))
* **watches:** update on step ([b35efce](https://github.com/igorlfs/nvim-dap-view/commit/b35efce062bc6dcdc43ee6db24e80585bed913e6))


### Bug Fixes

* **breakpoints:** use top-level split if creating new window ([dbf8d68](https://github.com/igorlfs/nvim-dap-view/commit/dbf8d68ec2d5478839f758448f6ae529f1f81091))
* **DapViewWatch:** switch to Watcher view when repl active ([#8](https://github.com/igorlfs/nvim-dap-view/issues/8)) ([b94ed42](https://github.com/igorlfs/nvim-dap-view/commit/b94ed42f1f40ed9d64c289101baaca39fe355b51))
* don't iterate over variables on error ([cfb960f](https://github.com/igorlfs/nvim-dap-view/commit/cfb960f37b22a3d987287532f4953bd66805e441))
* don't update breakpoints view if current_section is not breakpoints ([3085423](https://github.com/igorlfs/nvim-dap-view/commit/30854235c13e92f138b47cd9dc42d47f434bc829))
* **exceptions:** error in events `after.initialize` if session doesn't have exceptionBreakpointFilters ([ead0226](https://github.com/igorlfs/nvim-dap-view/commit/ead0226a750dd2771dc409b684c352282f1894b1))
* listening after event_stopped works best for listening to watches ([3f1f888](https://github.com/igorlfs/nvim-dap-view/commit/3f1f88882788901cd47721f043b2897bc2bdbcbd))
* make actions noop if sections are not enabled ([ce304be](https://github.com/igorlfs/nvim-dap-view/commit/ce304be3ed323c04e0ecacec9373933e64434384))
* make setup work ☝🏻 🤓 ([74125ec](https://github.com/igorlfs/nvim-dap-view/commit/74125ecba0405370c98723b02beea0958fb63a11))
* missing variable ([0d22313](https://github.com/igorlfs/nvim-dap-view/commit/0d22313752808f584532d61c23a71780c93a1cb0))
* no need to clear namespace ([cc131a3](https://github.com/igorlfs/nvim-dap-view/commit/cc131a39e8c86f543ebffbe82552772a98b3ba39))
* nowait for delete variable from watch list ([1598abd](https://github.com/igorlfs/nvim-dap-view/commit/1598abdbd13c05d6cc7f73410ab7972d1050a207))
* only close win if it's valid ([18f7d15](https://github.com/igorlfs/nvim-dap-view/commit/18f7d15f340a0ed98bf017993de1eb06e9ee470e))
* refresh exceptions view when initializing a new session ([b205f64](https://github.com/igorlfs/nvim-dap-view/commit/b205f64ec52d7c8f7226ded076491e49b2307535))
* remove useless command ([e85210b](https://github.com/igorlfs/nvim-dap-view/commit/e85210be1561ff4951e6ef22aeef7aa35d2617ff))
* removes trailing comma ([273bcde](https://github.com/igorlfs/nvim-dap-view/commit/273bcde82713604d8ef489a28dff3f514bf69bfa))
* revert not deleting term buf when no session was run yet ([c88146e](https://github.com/igorlfs/nvim-dap-view/commit/c88146e6652858467e1f18306fe616857fe5f23d))
* some files were in the wrong place for some reason ([922d21d](https://github.com/igorlfs/nvim-dap-view/commit/922d21d29fce5906945f7b33f74efdc03f192193))
* **term:** apply term_position option when creating term ([19ea1e5](https://github.com/igorlfs/nvim-dap-view/commit/19ea1e5f076a43c11501c4785a328c3a44093fde))
* use default namespace when defining hlgroups ([a9d8b51](https://github.com/igorlfs/nvim-dap-view/commit/a9d8b51c984796e32a579ac1f672411b1e2e7f45))
* uses terse style for setting buftype and updates readme ([75845f4](https://github.com/igorlfs/nvim-dap-view/commit/75845f4bbd0751017762989f046ab80dd2b62ca4))
* **watches:** always reevaluate expressions, even if hidden ([7fbdd14](https://github.com/igorlfs/nvim-dap-view/commit/7fbdd1432646c89d13af587bb240743a8a60ac1d))
