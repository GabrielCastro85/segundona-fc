// scripts/createAdmin.js
const prisma = require("../utils/db");
const bcrypt = require("bcryptjs"); // se der erro de módulo, rode: npm i bcryptjs

async function main() {
  const email = process.env.ADMIN_EMAIL || "admin@pelada.local";
  const password = process.env.ADMIN_PASSWORD || "admin123";

  // gera o hash da senha
  const passwordHash = await bcrypt.hash(password, 10);

  // verifica se já existe alguém com esse e-mail
  const existing = await prisma.admin.findUnique({
    where: { email },
  });

  if (existing) {
    console.log("Já existe um admin com esse e-mail:", email);
    return;
  }

  await prisma.admin.create({
    data: {
      email,
      passwordHash,
    },
  });

  console.log("Admin criado com sucesso!");
  console.log("E-mail:", email);
  console.log("Senha :", password);
}

main()
  .catch((err) => {
    console.error("Erro ao criar admin:", err);
  })
  .finally(async () => {
    await prisma.$disconnect();
  });
