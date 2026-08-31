const env = process.env;

function cleanPath(value, fallback) {
  const raw = String(value || "").trim();
  if (!raw) return fallback;
  return raw.startsWith("/") ? raw : `/${raw}`;
}

function cleanHandle(value) {
  const raw = String(value || "").trim();
  if (!raw) return "";
  return raw.startsWith("@") ? raw : `@${raw}`;
}

const brand = {
  name: env.SITE_NAME || "Segundona FC",
  shortName: env.SITE_SHORT_NAME || "Segundona",
  tagline: env.SITE_TAGLINE || "Futebol - Resenha - Cerveja",
  description:
    env.SITE_DESCRIPTION ||
    "Site oficial da Segundona FC com rankings, estatisticas, votacoes, financeiro e imagens para compartilhar.",
  instagramHandle: cleanHandle(env.SITE_INSTAGRAM || ""),
  instagramUrl: env.SITE_INSTAGRAM_URL || "",
  logo: cleanPath(env.SITE_LOGO_PATH, "/img/logo-128x128.png"),
  logoSmall: cleanPath(env.SITE_LOGO_SMALL_PATH, "/img/logo-32x32.png"),
  logoLarge: cleanPath(env.SITE_LOGO_LARGE_PATH, "/img/logo-512x512.png"),
  url: env.SITE_URL || "",
  teamPrefix: env.TEAM_LABEL_PREFIX || "Time",
  teamNamesByColor: {
    Amarelo: env.TEAM_NAME_AMARELO || "Matheus Fully",
    Vermelho: env.TEAM_NAME_VERMELHO || "Marmorart",
    Azul: env.TEAM_NAME_AZUL || "Khedecon",
    Preto: env.TEAM_NAME_PRETO || "Gripphen",
    Branco: env.TEAM_NAME_BRANCO || `${env.TEAM_LABEL_PREFIX || "Time"} 5`,
  },
  colors: {
    primary: env.BRAND_PRIMARY || "#f5b21b",
    secondary: env.BRAND_SECONDARY || "#0b6b2a",
    background: env.BRAND_BACKGROUND || "#050805",
  },
};

brand.hasInstagram = Boolean(brand.instagramHandle && brand.instagramUrl);
brand.instagramLabel = brand.instagramHandle;

module.exports = brand;
