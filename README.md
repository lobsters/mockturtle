2026-11-24: Archiving this repo. I [merged its history into lobsters/lobsters](https://github.com/lobsters/lobsters/commit/0ebeed00d783717f28dc3c6e825bbc3d4a38910b) and future development will happen there.

# mockturtle.js

The NodeJS based IRC bot which runs in [`#lobsters`](https://lobste.rs/chat). 

## Dev

```sh
$ yarn install
```

## Test

```sh
$ yarn standard --fix
$ yarn ospec
```

## Running

```sh
$ node src/index.js 'irc://username:password@example.com:6697/#channel1,##channel2`
```

## License

```
Copyright 2021 Hunter Madison

 Licensed under the Apache License, Version 2.0 (the "License");
 you may not use this file except in compliance with the License.
 You may obtain a copy of the License at

     http://www.apache.org/licenses/LICENSE-2.0

 Unless required by applicable law or agreed to in writing, software
 distributed under the License is distributed on an "AS IS" BASIS,
 WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 See the License for the specific language governing permissions and
 limitations under the License.
 ```

