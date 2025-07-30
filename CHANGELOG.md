# Changelog

## 1.0.0 (2025-07-30)


### ⚠ BREAKING CHANGES

* **buttons:** restore previous config for icons
* **controls:** full customization of default buttons
* make default height proportional to screen size
* full customization of sections
* do not use `newtab` by default for switchbuf
* **term:** delete buffers when finishing sessions
* cleanup README
* remove help file
* do not autogenerate help file
* **threads:** only show valid frames
* specify adapters for which the terminal should be hidden ([#10](https://github.com/igorlfs/nvim-dap-view/issues/10))
* avoid boolean concat
* remove hooks that close the plugin on session end
* swapped `show`

### fixup

* avoid boolean concat ([3b79d9d](https://github.com/igorlfs/nvim-dap-view/commit/3b79d9de31c45f461e0e39570b176113aeb93e2c))
* swapped `show` ([08ad351](https://github.com/igorlfs/nvim-dap-view/commit/08ad351aecb76e3f6afb4db3e04d2fc835397ced))


### Features

* `DapViewShow` command ([c31ef8b](https://github.com/igorlfs/nvim-dap-view/commit/c31ef8b67e3dfd1751957f8cb832cbc37f6e478e))
* `DapViewToggle!`, `DapViewClose!`, start_hidden option ([#17](https://github.com/igorlfs/nvim-dap-view/issues/17)) ([c86697c](https://github.com/igorlfs/nvim-dap-view/commit/c86697ce5ee5bd7930f3ec3895b8a7b01a98bc52))
* adds filetypes to dap-view buffers ([5d8daeb](https://github.com/igorlfs/nvim-dap-view/commit/5d8daeb5c9d4922914c2fde3a386ebe6371be701))
* allow collapsing via foldmethod = indent ([ca7906a](https://github.com/igorlfs/nvim-dap-view/commit/ca7906af3c787c8952f87c1ed58c405341fa3d5d))
* allow custom sections to set buffer function and ft ([902e8ed](https://github.com/igorlfs/nvim-dap-view/commit/902e8ed4fe632fdc46503484ec5a6b4a4419c3a4))
* allow evaluating more complex expressions ([ba72154](https://github.com/igorlfs/nvim-dap-view/commit/ba721546577e1c16bbb24e252ee62693e57790d4))
* allow extensions to register views ([ad85982](https://github.com/igorlfs/nvim-dap-view/commit/ad859822e1bd144738cd57d0ca168d40197c986f))
* allow height to be float ([0d537ca](https://github.com/igorlfs/nvim-dap-view/commit/0d537ca353a225496b9e8ab0063d9f44275a8ff0))
* allow overriding help border ([b0cd4e1](https://github.com/igorlfs/nvim-dap-view/commit/b0cd4e1eb7b856e4f7359923fdf4397324cd92ac))
* allow spawning windows in a different direction ([5e69020](https://github.com/igorlfs/nvim-dap-view/commit/5e69020bba51c790d3daa77921f2382850b46cad))
* basic config validation ([28d0d54](https://github.com/igorlfs/nvim-dap-view/commit/28d0d542caaddf38e3cfbd9c295db35ad9ff37fe))
* **breakpoints:** delete breakpoint ([93d44eb](https://github.com/igorlfs/nvim-dap-view/commit/93d44eb7624187f49ed7d15a0948bfc38591116f))
* **breakpoints:** jump to a breakpoint ([90da63c](https://github.com/igorlfs/nvim-dap-view/commit/90da63caa5fedc9e5571bebc7934980eeed16ab1))
* **buttons:** restore previous config for icons ([390dae6](https://github.com/igorlfs/nvim-dap-view/commit/390dae6bf67f3342ebb481159932ef0fe54822ba))
* close term window if outside of session ([17ec283](https://github.com/igorlfs/nvim-dap-view/commit/17ec2831dd94b06188cd442c31865ce35123364b))
* colors, handle deleting expressions ([ca7906a](https://github.com/igorlfs/nvim-dap-view/commit/ca7906af3c787c8952f87c1ed58c405341fa3d5d))
* **config:** allow hiding winbar ([3eddba5](https://github.com/igorlfs/nvim-dap-view/commit/3eddba5b5b0879e6e1e5720c1b2e57567db3e015))
* configurable height ([84dbbcf](https://github.com/igorlfs/nvim-dap-view/commit/84dbbcf79dd5576da2eef14b17d76e7fd86e74b0))
* console view ([589dd18](https://github.com/igorlfs/nvim-dap-view/commit/589dd1802137289b3ffbfd8448b79d685dcd7cdf))
* console view ([7d6335e](https://github.com/igorlfs/nvim-dap-view/commit/7d6335ea5f5f4699f9d367b4a95131e6ad6bcd07))
* **controls:** full customization of default buttons ([25dead9](https://github.com/igorlfs/nvim-dap-view/commit/25dead9fc459ca8a1e555dda74fcfea711917290))
* copy expression to clipboard ([ca7906a](https://github.com/igorlfs/nvim-dap-view/commit/ca7906af3c787c8952f87c1ed58c405341fa3d5d))
* DapViewJump command ([cd8781a](https://github.com/igorlfs/nvim-dap-view/commit/cd8781a0a63c1384c12839a22c2d6a8571cc241d))
* define custom hl groups ([29f6e7a](https://github.com/igorlfs/nvim-dap-view/commit/29f6e7a16c014423d55951017efe8ff9957aa202))
* delete watch expr ([1fbebae](https://github.com/igorlfs/nvim-dap-view/commit/1fbebaeb3badc760928cf5cf79a2949bb64f3160))
* edit expression ([fba18ea](https://github.com/igorlfs/nvim-dap-view/commit/fba18eae850740e9f21b65465855fc96657e6c58))
* edit expressions ([ca7906a](https://github.com/igorlfs/nvim-dap-view/commit/ca7906af3c787c8952f87c1ed58c405341fa3d5d))
* **exceptions:** store exceptions_options per adapter ([2c733c0](https://github.com/igorlfs/nvim-dap-view/commit/2c733c0570952f9edfd7f74ceba18538d7d06f80))
* experimental REPL support ([49ce20e](https://github.com/igorlfs/nvim-dap-view/commit/49ce20eef5226cc40f769076ed7cba96a9e9bf2e))
* expose terminal bufnr/winnr in state module ([#19](https://github.com/igorlfs/nvim-dap-view/issues/19)) ([a0c5f9f](https://github.com/igorlfs/nvim-dap-view/commit/a0c5f9f59a3b65397c01de12722ecf1eae00a52e))
* expose user commands ([6695fd1](https://github.com/igorlfs/nvim-dap-view/commit/6695fd1ad42fbbd2d7ffdb90042ccc5ad2e3a2f3))
* full customization of sections ([108c05a](https://github.com/igorlfs/nvim-dap-view/commit/108c05a85bd49257436dda728041b8099caf68f7))
* handle emptiness in views ([a59639a](https://github.com/igorlfs/nvim-dap-view/commit/a59639ae46ef4d9feed721d675bfc0d6982eaa1e))
* highlight variables that were updated with a different color ([4fb6235](https://github.com/igorlfs/nvim-dap-view/commit/4fb62357ce36554526060d470cf27135eb297bf6))
* hijack terminal ([ab13019](https://github.com/igorlfs/nvim-dap-view/commit/ab13019b9d3705d7e97c7fcf02dbbc528ec5b297))
* improve multitab support ([960e219](https://github.com/igorlfs/nvim-dap-view/commit/960e219c6a12b4cd60413d7918c877a1454cee31))
* **jump:** add basic DapViewJump argument completion ([#54](https://github.com/igorlfs/nvim-dap-view/issues/54)) ([47c1c2e](https://github.com/igorlfs/nvim-dap-view/commit/47c1c2eded6f1aca90a61495cef2e8e097f3f801))
* make default height proportional to screen size ([5271162](https://github.com/igorlfs/nvim-dap-view/commit/52711627ad85387e0632dfc7d6c7c82ab2b85fbd))
* multi session support ([1183ed9](https://github.com/igorlfs/nvim-dap-view/commit/1183ed980c4280ee4d7bc6266342fddfae12a789))
* notification when a variable is copied to the clipboard ([e509cd5](https://github.com/igorlfs/nvim-dap-view/commit/e509cd589702172aeea5ced3cf7a2b6861c6f29d))
* only add expr if not present ([40e36bf](https://github.com/igorlfs/nvim-dap-view/commit/40e36bf0674e2a60f125da4ff350c3943e92d3c5))
* redraw view after expressions are evaluated ([34bc1ec](https://github.com/igorlfs/nvim-dap-view/commit/34bc1ecd0f65e8b1a2c565177c9e8b685159abc0))
* remove hooks that close the plugin on session end ([9ae880f](https://github.com/igorlfs/nvim-dap-view/commit/9ae880f27c4a5eac7a61aae8bc68d60fc67d17f3))
* restore cursor position per view ([e2adb2a](https://github.com/igorlfs/nvim-dap-view/commit/e2adb2ac37e20da0fe1c6362ea5b66dbdd39ffa8))
* scopes view ([#30](https://github.com/igorlfs/nvim-dap-view/issues/30)) ([b411a0f](https://github.com/igorlfs/nvim-dap-view/commit/b411a0f957f26f2c537202acd3ab18d0608e0344))
* set a custom filetype for the help window ([f2527f4](https://github.com/igorlfs/nvim-dap-view/commit/f2527f4d493293935cde3072a996fbc09f9f2fda))
* show keymaps with `g?` ([5ebd677](https://github.com/igorlfs/nvim-dap-view/commit/5ebd6772809a13181267c212784f90f284578ff1))
* slightly better error handling when evaluating ([0215c6b](https://github.com/igorlfs/nvim-dap-view/commit/0215c6be14f6f1f1cce20929687ddb6882e22c49))
* specify adapters for which the terminal should be hidden ([#10](https://github.com/igorlfs/nvim-dap-view/issues/10)) ([80381ef](https://github.com/igorlfs/nvim-dap-view/commit/80381efd1d2684880e842fecbc215a38489a9ebf))
* start watches view ([8a16d0a](https://github.com/igorlfs/nvim-dap-view/commit/8a16d0a2a83f0166b035f69fa876646503ac9670))
* support opening terminal in any direction ([72ba31f](https://github.com/igorlfs/nvim-dap-view/commit/72ba31fa15107659ff049bc7a046d1f9619ddd36))
* switchbuf option ([#39](https://github.com/igorlfs/nvim-dap-view/issues/39)) ([b09f567](https://github.com/igorlfs/nvim-dap-view/commit/b09f5673358b8934422ec80eb26851e6ec5d4a8f))
* **term:** autoscroll ([6fe523b](https://github.com/igorlfs/nvim-dap-view/commit/6fe523b73fa66af53bd402744b50c95aad5f6404))
* **term:** configurable width ([7e3ab6d](https://github.com/igorlfs/nvim-dap-view/commit/7e3ab6d55ea2ca3357df4b9ff9620e5d7cfada79))
* **terminal:** config position ([#9](https://github.com/igorlfs/nvim-dap-view/issues/9)) ([273bcde](https://github.com/igorlfs/nvim-dap-view/commit/273bcde82713604d8ef489a28dff3f514bf69bfa))
* threads and stacks view ([#20](https://github.com/igorlfs/nvim-dap-view/issues/20)) ([360a97f](https://github.com/igorlfs/nvim-dap-view/commit/360a97f627ffc972f710f179dc62bbad36bd09d6))
* **threads:** cursor follows frame ([269ce63](https://github.com/igorlfs/nvim-dap-view/commit/269ce6361d7018ac4f5cce501a1ad75d7c9e7235))
* **threads:** highlight current frame ([0e41468](https://github.com/igorlfs/nvim-dap-view/commit/0e41468c2609e97d85bf73373a07283b696a8aa1))
* **threads:** only show valid frames ([0e3aa00](https://github.com/igorlfs/nvim-dap-view/commit/0e3aa00a8ae86f4d304aa01da3c72f97b23466ae))
* toggle with term ([c86697c](https://github.com/igorlfs/nvim-dap-view/commit/c86697ce5ee5bd7930f3ec3895b8a7b01a98bc52))
* try to keep cursor position ([611eadb](https://github.com/igorlfs/nvim-dap-view/commit/611eadbe35b967956128a8664f3653463154058c))
* tweak docs, simplify auto toggle setup ([56c651a](https://github.com/igorlfs/nvim-dap-view/commit/56c651a31b593c6dac2799752d4ba492b45cf86e))
* types for config validation, add namespace ([ac2b062](https://github.com/igorlfs/nvim-dap-view/commit/ac2b062511fca566cb845bbb7df8afc8e745cca2))
* **ui:** auto-switch inactive headers to icons when width is limited ([3b0c4a9](https://github.com/igorlfs/nvim-dap-view/commit/3b0c4a9c41470eeefeba5d141c4507c66cdf888c))
* update and highlight changed expressions ([ca7906a](https://github.com/igorlfs/nvim-dap-view/commit/ca7906af3c787c8952f87c1ed58c405341fa3d5d))
* use on_session listener to switch sessions ([4ca34f7](https://github.com/igorlfs/nvim-dap-view/commit/4ca34f7cfad5f572353465b9fb195240da843e93))
* use top-level split ([71ed672](https://github.com/igorlfs/nvim-dap-view/commit/71ed6720f04650bd0a21e36283ff15a4111d2ae7))
* watches MVP ([2bbd070](https://github.com/igorlfs/nvim-dap-view/commit/2bbd070cc1936061cb918b4580c4cf95b79222b4))
* **watches:** `setExpression` and `setVariable` requests ([#48](https://github.com/igorlfs/nvim-dap-view/issues/48)) ([fe49f81](https://github.com/igorlfs/nvim-dap-view/commit/fe49f81a6ba13e642bde43b77cec5e523c0628b6))
* **watches:** allow add_expr to take custom expression, `DapViewWatch` in visual mode ([#55](https://github.com/igorlfs/nvim-dap-view/issues/55)) ([6ebc617](https://github.com/igorlfs/nvim-dap-view/commit/6ebc617807990ed886ecb565fc76410249d51518))
* **watches:** copy value of variable ([9076a7d](https://github.com/igorlfs/nvim-dap-view/commit/9076a7d5f0bed19e1719491a5b3715915abf6229))
* **watches:** do not use virtual lines  ([#46](https://github.com/igorlfs/nvim-dap-view/issues/46)) ([ca7906a](https://github.com/igorlfs/nvim-dap-view/commit/ca7906af3c787c8952f87c1ed58c405341fa3d5d))
* **watches:** expand variables ([#49](https://github.com/igorlfs/nvim-dap-view/issues/49)) ([adbe984](https://github.com/igorlfs/nvim-dap-view/commit/adbe984fc9f7ccb17e74b44ad1bb1fa8718dce1b))
* **watches:** highlight updated variables ([ca7906a](https://github.com/igorlfs/nvim-dap-view/commit/ca7906af3c787c8952f87c1ed58c405341fa3d5d))
* **watches:** scroll virtual lines ([299594c](https://github.com/igorlfs/nvim-dap-view/commit/299594c0e20afb985da052f4f2a6a8c0f940d9b8))
* **watches:** update on step ([b35efce](https://github.com/igorlfs/nvim-dap-view/commit/b35efce062bc6dcdc43ee6db24e80585bed913e6))
* **winbar:** add configurable control buttons with support for custom buttons ([#44](https://github.com/igorlfs/nvim-dap-view/issues/44)) ([29dbe37](https://github.com/igorlfs/nvim-dap-view/commit/29dbe37d80ddf257a1aa1b7ada78c53186af9ae7))
* **winbar:** auto refresh on WinClosed,WinNew ([51df784](https://github.com/igorlfs/nvim-dap-view/commit/51df78414479657ad3f083bfa65cba352134c000))
* **winbar:** clickable headers (fix [#35](https://github.com/igorlfs/nvim-dap-view/issues/35)) ([#40](https://github.com/igorlfs/nvim-dap-view/issues/40)) ([ca373a2](https://github.com/igorlfs/nvim-dap-view/commit/ca373a2c8d85a696f667bfc6b14500ad4d386241))
* **winbar:** configurable header labels ([#41](https://github.com/igorlfs/nvim-dap-view/issues/41)) ([de489c1](https://github.com/igorlfs/nvim-dap-view/commit/de489c1b1e0fa426c5e6c42e05218c707e2c7373))
* **windows:** anchor main window to another window ([499b3fa](https://github.com/igorlfs/nvim-dap-view/commit/499b3fae6d44cdd6ac574cef9f6594e3aadcc650))


### Bug Fixes

* **breakpoints:** regression after changing types ([3e5085e](https://github.com/igorlfs/nvim-dap-view/commit/3e5085eba9e4f58c667f9a3b5b349b22edeb4e40))
* **breakpoints:** use top-level split if creating new window ([dbf8d68](https://github.com/igorlfs/nvim-dap-view/commit/dbf8d68ec2d5478839f758448f6ae529f1f81091))
* check if win is valid in more places ([9d620a7](https://github.com/igorlfs/nvim-dap-view/commit/9d620a74edd3e55cb7b56da3f5c014f1fbbf06f5))
* clear win state when switching buffer ([8e5ae13](https://github.com/igorlfs/nvim-dap-view/commit/8e5ae13cf44a6868b4afa21e3278529431259ebd))
* **close:** do not call repl.close() ([e63ceab](https://github.com/igorlfs/nvim-dap-view/commit/e63ceab49feefe65e7a5c0d3706fd04958136830))
* closing the REPL may be necessary ([0fc730b](https://github.com/igorlfs/nvim-dap-view/commit/0fc730bd872ca7ccef416614f4be3a93c6950f0d))
* **config:** another wrong annotation ([6e2a9c6](https://github.com/igorlfs/nvim-dap-view/commit/6e2a9c648925213eeed765570c659a4d0b85ce0a))
* **config:** type annotation ([083abf3](https://github.com/igorlfs/nvim-dap-view/commit/083abf39c6416c11403170bd8d4fcc3abb72da04))
* **console:** set options before changing buf ([7b305ec](https://github.com/igorlfs/nvim-dap-view/commit/7b305ecbbdeb5c6fb7463e68e42c44c19add60b9))
* **DapViewWatch:** switch to Watcher view when repl active ([#8](https://github.com/igorlfs/nvim-dap-view/issues/8)) ([b94ed42](https://github.com/igorlfs/nvim-dap-view/commit/b94ed42f1f40ed9d64c289101baaca39fe355b51))
* do not set foldmethod for views window ([995f5c6](https://github.com/igorlfs/nvim-dap-view/commit/995f5c6a80da3f2a55b5efc352754fb34230c87c))
* do not use `newtab` by default for switchbuf ([280213a](https://github.com/igorlfs/nvim-dap-view/commit/280213aa7a553c03fccf97771e340f991706478c))
* **docs:** define a color for visited links ([#93](https://github.com/igorlfs/nvim-dap-view/issues/93)) ([c738580](https://github.com/igorlfs/nvim-dap-view/commit/c7385808c7d6a4438f6eef50d539d7103146ba2b))
* don't iterate over variables on error ([cfb960f](https://github.com/igorlfs/nvim-dap-view/commit/cfb960f37b22a3d987287532f4953bd66805e441))
* don't update breakpoints view if current_section is not breakpoints ([3085423](https://github.com/igorlfs/nvim-dap-view/commit/30854235c13e92f138b47cd9dc42d47f434bc829))
* **events:** avoid race condition when getting threads ([8f66dd5](https://github.com/igorlfs/nvim-dap-view/commit/8f66dd5a8a69500e92a914edf157cc801f01c175))
* **exceptions:** apply filters to all sessions that match the adapter ([c75b6da](https://github.com/igorlfs/nvim-dap-view/commit/c75b6da1eb9c5fa1a8722d926182e09fd58cccdc))
* **exceptions:** error in events `after.initialize` if session doesn't have exceptionBreakpointFilters ([ead0226](https://github.com/igorlfs/nvim-dap-view/commit/ead0226a750dd2771dc409b684c352282f1894b1))
* get_bufnr may return nil ([#96](https://github.com/igorlfs/nvim-dap-view/issues/96)) ([143411d](https://github.com/igorlfs/nvim-dap-view/commit/143411d3e5d76814345030d7029af935afc7116d))
* **hl:** reload base links on updating colorscheme ([235f701](https://github.com/igorlfs/nvim-dap-view/commit/235f701073fd9603570c8164106e70cfdb55b2da))
* jumping to call in the stack, which expects the dap-view buf ([8e5ae13](https://github.com/igorlfs/nvim-dap-view/commit/8e5ae13cf44a6868b4afa21e3278529431259ebd))
* **keymaps:** make mapping buflocal ([2d68f42](https://github.com/igorlfs/nvim-dap-view/commit/2d68f421fbcf495a5127486bdd5322adf11efe68))
* listening after event_stopped works best for listening to watches ([3f1f888](https://github.com/igorlfs/nvim-dap-view/commit/3f1f88882788901cd47721f043b2897bc2bdbcbd))
* locally set window options ([186c958](https://github.com/igorlfs/nvim-dap-view/commit/186c9580895f8552a6e0eff8087e643a824dac2d))
* make actions noop if sections are not enabled ([ce304be](https://github.com/igorlfs/nvim-dap-view/commit/ce304be3ed323c04e0ecacec9373933e64434384))
* make setup work ☝🏻 🤓 ([74125ec](https://github.com/igorlfs/nvim-dap-view/commit/74125ecba0405370c98723b02beea0958fb63a11))
* minor issues with buf/win state management ([#73](https://github.com/igorlfs/nvim-dap-view/issues/73)) ([1ea46f5](https://github.com/igorlfs/nvim-dap-view/commit/1ea46f5ded7d5885a56adbe9e568bead45a9331c))
* missing variable ([0d22313](https://github.com/igorlfs/nvim-dap-view/commit/0d22313752808f584532d61c23a71780c93a1cb0))
* no need to clear namespace ([cc131a3](https://github.com/igorlfs/nvim-dap-view/commit/cc131a39e8c86f543ebffbe82552772a98b3ba39))
* nowait for delete variable from watch list ([1598abd](https://github.com/igorlfs/nvim-dap-view/commit/1598abdbd13c05d6cc7f73410ab7972d1050a207))
* only close win if it's valid ([18f7d15](https://github.com/igorlfs/nvim-dap-view/commit/18f7d15f340a0ed98bf017993de1eb06e9ee470e))
* properly handle buffer deletion ([643345a](https://github.com/igorlfs/nvim-dap-view/commit/643345adbf96484fc2a1bc8f1f4b1542ad500668))
* **README:** typo in highlight groups closing details markup ([#47](https://github.com/igorlfs/nvim-dap-view/issues/47)) ([777624d](https://github.com/igorlfs/nvim-dap-view/commit/777624df5b768acfc693300798d1bbd316430006))
* refresh exceptions view when initializing a new session ([b205f64](https://github.com/igorlfs/nvim-dap-view/commit/b205f64ec52d7c8f7226ded076491e49b2307535))
* remove useless command ([e85210b](https://github.com/igorlfs/nvim-dap-view/commit/e85210be1561ff4951e6ef22aeef7aa35d2617ff))
* removes trailing comma ([273bcde](https://github.com/igorlfs/nvim-dap-view/commit/273bcde82713604d8ef489a28dff3f514bf69bfa))
* respect windows.terminal.width option ([9aa35a6](https://github.com/igorlfs/nvim-dap-view/commit/9aa35a66997449cbc9e99f38f37676a008c3a3c6))
* restore current adapter ([926d326](https://github.com/igorlfs/nvim-dap-view/commit/926d3263c22b07e067c9355106e1f89a3f2dedbb))
* revert not deleting term buf when no session was run yet ([c88146e](https://github.com/igorlfs/nvim-dap-view/commit/c88146e6652858467e1f18306fe616857fe5f23d))
* **scopes:** explicit message when no scopes are returned ([654bd03](https://github.com/igorlfs/nvim-dap-view/commit/654bd0355c8b63126c21a9efb57da57952c599f0))
* **scopes:** recreate widget when state.buffer changes ([e75ac47](https://github.com/igorlfs/nvim-dap-view/commit/e75ac47ce597fe80f82ce576f2cd71913296ce18))
* some files were in the wrong place for some reason ([922d21d](https://github.com/igorlfs/nvim-dap-view/commit/922d21d29fce5906945f7b33f74efdc03f192193))
* **startup:** lazy load dap-view module ([#53](https://github.com/igorlfs/nvim-dap-view/issues/53)) ([f07180d](https://github.com/igorlfs/nvim-dap-view/commit/f07180d6e16646f89484f8beee0df34a16e55ed3))
* **term:** apply term_position option when creating term ([19ea1e5](https://github.com/igorlfs/nvim-dap-view/commit/19ea1e5f076a43c11501c4785a328c3a44093fde))
* **term:** delete buffers when finishing sessions ([a37ff2c](https://github.com/igorlfs/nvim-dap-view/commit/a37ff2c1809dacce5b17c3b4675cd5b5a7e12724))
* **term:** make buf unlisted ([ebed529](https://github.com/igorlfs/nvim-dap-view/commit/ebed5294735a9ed9a843c1a2479d9fa37f75620c))
* **term:** make children inherit term buf from their parent ([e83c5e9](https://github.com/igorlfs/nvim-dap-view/commit/e83c5e9e62c8fe10d99d821fc552fb689c0c827c))
* **threads:** avoid out of sync frame ids ([fc03150](https://github.com/igorlfs/nvim-dap-view/commit/fc0315087a871f9e74ef88559760b81dae81bc6d)), closes [#61](https://github.com/igorlfs/nvim-dap-view/issues/61)
* **threads:** do not refresh after stackTrace ([278fb4a](https://github.com/igorlfs/nvim-dap-view/commit/278fb4a90962e67d3fbf2607ffb426ad817c0b44))
* **threads:** don't use an empty table inside request ([dd949de](https://github.com/igorlfs/nvim-dap-view/commit/dd949de720c641a083ed639a0bf31709986ca29c))
* **threads:** restore cursor position ([4eac690](https://github.com/igorlfs/nvim-dap-view/commit/4eac690a061aedf9523afc1557beb965cac18c1f))
* **ui:** account for double-width characters in label width calculation ([ecc95c9](https://github.com/igorlfs/nvim-dap-view/commit/ecc95c9bfec0fa79c817c849e1e69a6a7017cd17))
* **ui:** incorrect calculation of `controls_len` ([aa5315d](https://github.com/igorlfs/nvim-dap-view/commit/aa5315d4d211c749efe0512a81fb4d955e4a7fb2))
* use default namespace when defining hlgroups ([a9d8b51](https://github.com/igorlfs/nvim-dap-view/commit/a9d8b51c984796e32a579ac1f672411b1e2e7f45))
* uses terse style for setting buftype and updates readme ([75845f4](https://github.com/igorlfs/nvim-dap-view/commit/75845f4bbd0751017762989f046ab80dd2b62ca4))
* **watches:** always reevaluate expressions, even if hidden ([7fbdd14](https://github.com/igorlfs/nvim-dap-view/commit/7fbdd1432646c89d13af587bb240743a8a60ac1d))
* **watches:** clear stored cache on redraw ([cbf4f05](https://github.com/igorlfs/nvim-dap-view/commit/cbf4f05b86dbbf01b74717b7445df8a63310da71))
* **watches:** improve cursor position restoration ([25d8ef1](https://github.com/igorlfs/nvim-dap-view/commit/25d8ef1a815946fd4563215ff57e2fc127fce68c))
* **watches:** reset expanded state when setting var/expr ([57f31df](https://github.com/igorlfs/nvim-dap-view/commit/57f31df68a35510cb062bbe93835d2eddb84bf0f))
* **watches:** trimming variables too much ([eea1ec3](https://github.com/igorlfs/nvim-dap-view/commit/eea1ec389b60392aca42fc8ab8640e8fe4512f65))
* **watches:** workaround should only be used if there are expressions ([033b675](https://github.com/igorlfs/nvim-dap-view/commit/033b675efc3067a0fc7501f3b5247f02f5adedd9))
* **winbar:** fail gracefully if view is not found ([e4145c4](https://github.com/igorlfs/nvim-dap-view/commit/e4145c4851c536a4f35ddd5b7b2d80d4daa096ed))
* **winbar:** improve validations ([aa189f0](https://github.com/igorlfs/nvim-dap-view/commit/aa189f0f4d9e998f761a3a348e2d15bb484992ec))
* **winbar:** only consider enabled fields to calculate length ([25dead9](https://github.com/igorlfs/nvim-dap-view/commit/25dead9fc459ca8a1e555dda74fcfea711917290))
* **winbar:** only count useful characters in length calculation ([aaaf2aa](https://github.com/igorlfs/nvim-dap-view/commit/aaaf2aa0e2dcaf7b0f8d5f531662a9f181a7b89d))


### Documentation

* remove help file ([efa8f25](https://github.com/igorlfs/nvim-dap-view/commit/efa8f259046ae4b37cf2d65c7de262885d7fd892))


### Miscellaneous Chores

* cleanup README ([3a25929](https://github.com/igorlfs/nvim-dap-view/commit/3a259295786315fd059774e6ef615142af6cd12d))


### Continuous Integration

* do not autogenerate help file ([f9071c8](https://github.com/igorlfs/nvim-dap-view/commit/f9071c8e8a734b5cca54a31d3dd8f6b3313bd32c))
