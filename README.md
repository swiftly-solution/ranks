<p align="center">
  <a href="https://github.com/swiftly-solution/ranks">
    <img src="https://cdn.swiftlycs2.net/swiftly-logo.png" alt="SwiftlyLogo" width="80" height="80">
  </a>

  <h3 align="center">[Swiftly] Rank System</h3>

  <p align="center">
    A simple plugin for Swiftly that implements an Rank System.
    <br/>
  </p>
</p>

<p align="center">
  <img src="https://img.shields.io/github/downloads/swiftly-solution/ranks/total" alt="Downloads"> 
  <img src="https://img.shields.io/github/contributors/swiftly-solution/ranks?color=dark-green" alt="Contributors">
  <img src="https://img.shields.io/github/issues/swiftly-solution/ranks" alt="Issues">
  <img src="https://img.shields.io/github/license/swiftly-solution/ranks" alt="License">
</p>

---

### Installation 👀

1. Download the newest [release](https://github.com/swiftly-solution/ranks/releases).
2. Everything is drag & drop, so i think you can do it!
3. Setup database connection in `addons/swiftly/configs/databases.json` with the key `swiftly_ranks` like in the following example:

```json
{
  "swiftly_ranks": {
    "hostname": "...",
    "username": "...",
    "password": "...",
    "database": "...",
    "port": 3306
  }
}
```

(!) Don't forget to replace the `...` with the actual values !!

### Configuring the plugin 🧐

- After installing the plugin, you should change the default prefix from `addons/swiftly/translations/translation.ranks.json` (optional)
- To change the value of the points, edit `addons/swiftly/configs/plugins/ranks.json` after the first start of the plugin.

### Ranks Exports 🛠️

The following exports are available:

|     Name    |    Arguments    |                            Description                            |
|:-----------:|:---------------:|:-----------------------------------------------------------------:|
|   FetchStatistics  | playerid | Returns the statistics of a player  |

### Ranks Commands 💬

* Base commands provided by this plugin:

|      Command     |        Flag       |               Description              |
|:----------------:|:-----------------:|:--------------------------------------:|
|     !lvl    |       NONE     |        Ranks Menu.        |
|   !lvl_admin   |       z     |    Ranks Admin Menu.   |
|   !lvl_reset | z/CONSOLE | Reset Statistics |

### Creating A Pull Request 😃

1. Fork the Project
2. Create your Feature Branch
3. Commit your Changes
4. Push to the Branch
5. Open a Pull Request

### Have ideas/Found bugs? 💡

Join [Swiftly Discord Server](https://swiftlycs2.net/discord) and send a message in the topic from `📕╎plugins-sharing` of this plugin!

---
