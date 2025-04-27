# Salus Gym

[![en](https://img.shields.io/badge/lang-en-red.svg)](https://github.com/jolaz-dev/salus-gym/blob/main/README.md)

Este projeto visa ser um sistema completo de gerenciamento de academias escrito em Flutter para permitir que a mesma base de código sirva as plataformas desktop, web e (eventualmente) iOS/Android. A ideia é gerenciar o histórico dos alunos, frequência, pagamentos, o calendário dos profissionais da academia, etc, tudo de forma fácil e com posterior integração com outros serviços (gateways de pagamento, e-mail, SMS, chatbots, etc).

Este projeto está sendo mantido majoritariamente por [Jonathan Santos do Carmo Lazaro](https://github.com/jonathanlazaro1) como um [Projeto de Extensão (PEx)](http://portal.mec.gov.br/index.php?option=com_docman&view=download&alias=104251-rces007-18&category_slug=dezembro-2018-pdf&Itemid=30192) para a [Descomplica Faculdade Digital](https://no.descomplica.com.br/knowledge/o-que-%C3%A9-projeto-de-extens%C3%A3o), como parte de sua graduação em Engenharia de Software na referida instituição.

## Funcionalidades atuais

- Controle de agenda (em progresso)
  - Planejado (e testado) para ser usado apenas nas plataformas Windows/Linux, usando [SQLite](https://www.sqlite.org/)
  - Criação e atualização de compromissos funcionando
  - Persistência de dados em UTC e exibição em horário local _parece_ estar funcionando
  - _Provavelmente a interface gráfica precisa de um carinho_ 😅

## Funcionalidades planejadas

- Gerenciamento dos alunos da academia
- Internacionalização (i18n)
- Integração com Firebase (para uso na web/mobile)
- Integração com gateways de pagamento

## Licensing/Contributing

Este projeto é distribuído através da [licença MIT](./LICENSE). Sua contribuição é muito bem-vinda! Apenas garanta que você está seguindo o [guia de contribuição](./CONTRIBUTING.md).
