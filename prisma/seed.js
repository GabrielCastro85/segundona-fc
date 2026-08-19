// prisma/seed.js
require("dotenv").config();
const { PrismaClient } = require("@prisma/client");
const bcrypt = require("bcryptjs");

const prisma = new PrismaClient();

async function main() {
  console.log("🌱 Iniciando seed...");

  const email = process.env.ADMIN_EMAIL || "admin@pelada.local";
  const plainPassword = process.env.ADMIN_PASSWORD || "senha123";

  // Verifica se já existe admin com esse e-mail
  const existingAdmin = await prisma.admin.findUnique({
    where: { email },
  });

  if (!existingAdmin) {
    const hashedPassword = await bcrypt.hash(plainPassword, 10);

    await prisma.admin.create({
      data: {
        email,
        passwordHash: hashedPassword, // ✅ campo correto do schema
      },
    });

    console.log("✅ Admin criado com sucesso:");
    console.log(`   Email: ${email}`);
    console.log(`   Senha: ${plainPassword}`);
  } else {
    console.log("ℹ️ Admin já existe, nenhum novo admin criado.");
  }

  // ====== Catálogo de conquistas ======
  const achievements = [
    // Gols
    { code: "gols_10", title: "Pé na Forma", description: "Marque 10 gols", category: "gols", rarity: "bronze", targetValue: 10, isNumeric: true, sortOrder: 10 },
    { code: "gols_25", title: "Artilheiro de Bairro", description: "Marque 25 gols", category: "gols", rarity: "prata", targetValue: 25, isNumeric: true, sortOrder: 11 },
    { code: "gols_50", title: "Matador", description: "Marque 50 gols", category: "gols", rarity: "ouro", targetValue: 50, isNumeric: true, sortOrder: 12 },
    { code: "gols_75", title: "Camisa 9 de Ouro", description: "Marque 75 gols", category: "gols", rarity: "ouro", targetValue: 75, isNumeric: true, sortOrder: 13 },
    { code: "gols_100", title: "Lenda do Gol", description: "Marque 100 gols", category: "gols", rarity: "lendaria", targetValue: 100, isNumeric: true, sortOrder: 14 },
    { code: "gols_150", title: "Canhão Humano", description: "Marque 150 gols", category: "gols", rarity: "lendaria", targetValue: 150, isNumeric: true, sortOrder: 15 },
    { code: "gols_250", title: "Imortal da Pelada", description: "Marque 250 gols", category: "gols", rarity: "lendaria", targetValue: 250, isNumeric: true, sortOrder: 16 },
    { code: "gols_500", title: "Recordista Mundial", description: "Marque 500 gols", category: "gols", rarity: "lendaria", targetValue: 500, isNumeric: true, sortOrder: 17 },
    // Assistências
    { code: "ast_10", title: "Garçom", description: "Dê 10 assistências", category: "assistencias", rarity: "bronze", targetValue: 10, isNumeric: true, sortOrder: 20 },
    { code: "ast_25", title: "Prato Principal", description: "Dê 25 assistências", category: "assistencias", rarity: "prata", targetValue: 25, isNumeric: true, sortOrder: 21 },
    { code: "ast_50", title: "Mestre das Assistências", description: "Dê 50 assistências", category: "assistencias", rarity: "ouro", targetValue: 50, isNumeric: true, sortOrder: 22 },
    { code: "ast_75", title: "Maestro", description: "Dê 75 assistências", category: "assistencias", rarity: "ouro", targetValue: 75, isNumeric: true, sortOrder: 23 },
    { code: "ast_100", title: "Gênio do Último Passe", description: "Dê 100 assistências", category: "assistencias", rarity: "lendaria", targetValue: 100, isNumeric: true, sortOrder: 24 },
    { code: "ast_150", title: "Lenda dos Cruzamentos", description: "Dê 150 assistências", category: "assistencias", rarity: "lendaria", targetValue: 150, isNumeric: true, sortOrder: 25 },
    { code: "ast_200", title: "O Xavi da Pelada", description: "Dê 200 assistências", category: "assistencias", rarity: "lendaria", targetValue: 200, isNumeric: true, sortOrder: 26 },
    // Presença
    { code: "pres_20", title: "Nunca Falta", description: "20 presenças", category: "presenca", rarity: "bronze", targetValue: 20, isNumeric: true, sortOrder: 30 },
    { code: "pres_50", title: "Vivo no Campo", description: "50 presenças", category: "presenca", rarity: "prata", targetValue: 50, isNumeric: true, sortOrder: 31 },
    { code: "pres_100", title: "Morador da Terça", description: "100 presenças", category: "presenca", rarity: "ouro", targetValue: 100, isNumeric: true, sortOrder: 32 },
    { code: "pres_150", title: "Contrato Vitalício", description: "150 presenças", category: "presenca", rarity: "ouro", targetValue: 150, isNumeric: true, sortOrder: 33 },
    { code: "pres_200", title: "Se Me Procurar, Tô na Pelada", description: "200 presenças", category: "presenca", rarity: "lendaria", targetValue: 200, isNumeric: true, sortOrder: 34 },
    // Notas
    { code: "nota_media_6", title: "Regularzão", description: "Média ≥ 6.0", category: "notas", rarity: "bronze", targetValue: 6, isNumeric: true, sortOrder: 40 },
    { code: "nota_media_7", title: "Batedor de Carteira", description: "Média ≥ 7.0", category: "notas", rarity: "prata", targetValue: 7, isNumeric: true, sortOrder: 41 },
    { code: "nota_10x8", title: "Craque do Jogo", description: "10 notas ≥ 8", category: "notas", rarity: "ouro", targetValue: 10, isNumeric: true, sortOrder: 42 },
    { code: "nota_25x9", title: "Monstro Sagrado", description: "25 notas ≥ 9", category: "notas", rarity: "ouro", targetValue: 25, isNumeric: true, sortOrder: 43 },
    { code: "nota_10", title: "Nota Messi", description: "Uma nota 10", category: "notas", rarity: "lendaria", targetValue: 1, isNumeric: true, sortOrder: 44 },
    // Prêmios
    { code: "prem_semana_1", title: "Craque da Semana", description: "1 vez craque da semana", category: "premio", rarity: "prata", targetValue: 1, isNumeric: true, sortOrder: 50 },
    { code: "prem_semana_5", title: "Bicho Papão da Semana", description: "5 vezes craque da semana", category: "premio", rarity: "ouro", targetValue: 5, isNumeric: true, sortOrder: 51 },
    { code: "prem_mes_1", title: "Craque do Mês", description: "1 vez craque do mês", category: "premio", rarity: "ouro", targetValue: 1, isNumeric: true, sortOrder: 52 },
    { code: "prem_mes_3", title: "MVP Mensal", description: "3 vezes craque do mês", category: "premio", rarity: "ouro", targetValue: 3, isNumeric: true, sortOrder: 53 },
    { code: "prem_mes_10", title: "Rei das Terças", description: "10 prêmios mensais", category: "premio", rarity: "lendaria", targetValue: 10, isNumeric: true, sortOrder: 54 },
    { code: "prem_mes_20", title: "O Messi da Resenha", description: "20 prêmios mensais", category: "premio", rarity: "lendaria", targetValue: 20, isNumeric: true, sortOrder: 55 },
    // Lendárias não numéricas
    { code: "lendaria_infinito", title: "O Inabalável", description: "Proeza lendária", category: "lendaria", rarity: "lendaria", symbol: "∞", isNumeric: false, sortOrder: 90 },
    { code: "lendaria_coroa", title: "Rei da Pelada", description: "Conquista máxima", category: "lendaria", rarity: "lendaria", symbol: "👑", isNumeric: false, sortOrder: 91 },
    { code: "lendaria_estrela", title: "Lenda Viva", description: "Conquista especial", category: "lendaria", rarity: "lendaria", symbol: "★", isNumeric: false, sortOrder: 92 },
  ];

  for (const ach of achievements) {
    await prisma.achievement.upsert({
      where: { code: ach.code },
      update: ach,
      create: ach,
    });
  }

  console.log(`✅ Catálogo de conquistas upsertado: ${achievements.length} itens`);

  console.log("🌱 Seed finalizado.");
}

main()
  .catch((e) => {
    console.error("❌ Erro ao executar seed:", e);
    process.exit(1);
  })
  .finally(async () => {
    await prisma.$disconnect();
  });
