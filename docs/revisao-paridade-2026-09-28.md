# Revisão de funcionamento do Segundona — 28/09/2026

Comparação dos arquivos funcionais com a cópia local do Horriver Plate, mantendo identidade, times, desarmes e armazenamento persistente de fotos do Segundona.

Correções:
- Separação das identidades de jogadores cadastrados e convidados na votação, mesmo quando seus IDs numéricos coincidem; convidados ficam no time correto.
- Foto do convidado preservada ao salvar o sorteio; sincronização de convidados também no sorteio inicial.
- Cache dos rankings compartilhado com a invalidação das estatísticas.
- Exclusão de pelada recalcula os totais dos participantes e preserva o registro/foto do destaque semanal, removendo apenas o vínculo com a pelada.
- URLs válidas nas imagens de prévia de perfil e pelada. Fotos incorporadas ao banco usam o logotipo como prévia social.
- Publicação dos campos de gols contra e edição da pelada já existentes nas duas cópias locais.

Validação: 67 templates EJS, 57 arquivos JavaScript, scripts inline de lançamento/sorteio, 9 testes de regressão, testes de desarmes por posição e schema Prisma. Onze páginas públicas responderam HTTP 200 sem mensagem de erro de servidor. Exclusão e salvamento foram testados com dados simulados, sem excluir ou alterar peladas reais.

Limites: essa revisão não garante ausência de todo bug. Operações financeiras e todos os cenários de administração não foram executados no banco real. As fotos antigas que retornam 404 precisam ser reenviadas; registros históricos de presença/foto não foram adivinhados nem modificados.
