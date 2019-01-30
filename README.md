[hubot]: https://github.com/github/hubot
[coffeestyle]: https://github.com/polarmobile/coffeescript-style-guide

# hubot-tea-timer
[![Build Status](https://travis-ci.org/fundor333/hubot-tea-timer.svg?branch=master)](https://travis-ci.org/fundor333/hubot-tea-timer)
![](https://img.shields.io/npm/v/hubot-tea-timer.svg?style=flat)
![](https://img.shields.io/github/last-commit/fundor333/hubot-tea-timer.svg?style=flat)
![](https://img.shields.io/github/issues-raw/fundor333/hubot-tea-timer.svg?style=flat)

A [Hubot][hubot] script for all your tea timer needs. Simply start a timer and Hubot will notify you when the tea is ready.


## Install It

Install with **npm** using ```--save``` to add to your ```package.json``` dependencies.
```
  > npm install --save hubot-tea-timer
```

Then add **"hubot-tea-timer"** to your ```external-scripts.json```.

Example external-scripts.json
```json
["hubot-tea-timer"]
```

Or if you prefer, just drop **tea-timer.coffee** in your [Hubot][hubot] scripts folder and enjoy.

## Use It

Each user can start a single timer per chat room. Everyone in a chatroom can start their own timer. 

* `hubot tea start` - start a tea timer
* `hubot tea stop` - stop a tea timer
* `hubot tea info` - show info about the current tea timer
* `hubot tea mine` - show info about all of my current tea timers
* `hubot tea all` -  show all the tea timers, everywhere
* `hubot tea short break` - start a short break timer
* `hubot tea long break` - start a long break timer
* `hubot tea stop break` - stop a tea break timer
* `hubot tea help` - return the allowed commands

## Configure It

If you don't like the default `:tea:` emoji, you can override using `HUBOT_TEA_TIMER_EMOJI`.
