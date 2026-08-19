# Modelo Site de Pelada

Projeto base white-label para criar um site de pelada com painel admin, jogadores, peladas, rankings, votacoes, financeiro e imagens de compartilhamento.

## Como criar um novo cliente

1. Copie `.env.example` para `.env`.
2. Configure banco, admin e segredo:
   - `DATABASE_URL`
   - `ADMIN_EMAIL`
   - `ADMIN_PASSWORD`
   - `JWT_SECRET`
3. Configure a marca:
   - `SITE_NAME`
   - `SITE_SHORT_NAME`
   - `SITE_TAGLINE`
   - `SITE_INSTAGRAM`
   - `SITE_INSTAGRAM_URL`
   - `TEAM_LABEL_PREFIX`
4. Troque os logos em `public/img/logo-*.svg` ou aponte o `.env` para novos arquivos:
   - `SITE_LOGO_PATH`
   - `SITE_LOGO_SMALL_PATH`
   - `SITE_LOGO_LARGE_PATH`
5. Instale e prepare o banco:
   ```bash
   npm install
   npx prisma migrate deploy
   npm run prisma:seed
   ```
6. Rode local:
   ```bash
   npm run dev
   ```

## Projeto zerado

Este modelo nao traz jogadores, partidas, estatisticas ou fotos cadastradas. As pastas `public/uploads/players` e `public/uploads/weekly` ficam vazias para receber as imagens do novo cliente pelo painel.

## Times genericos

O sorteador e o torneio usam nomes genericos por padrao:

- Time 1
- Time 2
- Time 3
- Time 4

Para mudar o prefixo, ajuste:

```env
TEAM_LABEL_PREFIX=Equipe
```

Com isso, os nomes passam a ser `Equipe 1`, `Equipe 2`, e assim por diante.

## Baixa memoria local

Para simular ambiente pequeno:

```bash
npm run start:lowmem
```

Para testar tambem com `global.gc` disponivel:

```bash
npm run start:lowmem:gc
```
