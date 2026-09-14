# Desarmes por partida

O campo `PlayerStat.tackles` registra um inteiro não negativo, com padrão zero. O lançamento fica nas estatísticas da pelada (tabela, celular e times), e a votação mostra Desarmes junto de gols, assistências e foto.

A nota final mantém 85% de votação e 15% de estatísticas. Quando há desarmes na partida, a nota estatística combina a fórmula anterior com desarmes relativos ao maior número registrado na rodada. A parcela dos desarmes é 35% para zagueiros/volantes, 20% para meias/outras posições e 10% para atacantes/goleiros. A parcela anterior é multiplicada por 1 menos esse peso. Sem desarmes na partida, a fórmula anterior é preservada.

A ação de aplicar votos usa o mesmo cálculo das premiações. A migração adiciona somente a coluna com padrão zero; não recalcula notas históricas.

Validação: `node scripts/test-tackles.cjs`.
Publicação: aplicar `npm run prisma:deploy`, gerar o cliente Prisma e publicar/reiniciar a aplicação.
