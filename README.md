# Salus Gym

This project aims to be a full-featured gym management system written in Flutter to allow a single codebase to serve desktop, web and (eventually) iOS/Android. The idea is to manage gym members hystorical records, attendance, billing, gym professionals calendar, etc, all at ease and with planned integrations to other services (payment gateways, e-mail, SMS, chatbots, etc).

This project is being mainly developed by [Jonathan Santos do Carmo Lazaro](https://github.com/jonathanlazaro1) as part of an [Extension Project (PEx)](http://portal.mec.gov.br/index.php?option=com_docman&view=download&alias=104251-rces007-18&category_slug=dezembro-2018-pdf&Itemid=30192) for [Descomplica Faculdade Digital](https://no.descomplica.com.br/knowledge/o-que-%C3%A9-projeto-de-extens%C3%A3o).

## Current Features

- Calendar control (WIP)
  - Planned to be available for Windows/Linux desktop software only, using SQLite
  - Creation and updating working
  - Date persistence in UTC and exhibition in local time _seems_ to be working
  - _It needs better visuals, probably_ 😅

## Planned features

- Gym members management
- i18n
- Firebase integration (for use on web/mobile)
- Payment gateways integration

## Licensing/Contributing

This project is licensed under [MIT license](./LICENSE). You are very welcome to help it to grow! Just make sure you follow the [contributing guide](./CONTRIBUTING.md).
