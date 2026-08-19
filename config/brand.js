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
  name: env.SITE_NAME || "Nome da Pelada",
  shortName: env.SITE_SHORT_NAME || "Pelada",
  tagline: env.SITE_TAGLINE || "Pelada - Stats - Resenha",
  description:
    env.SITE_DESCRIPTION ||
    "Site da pelada com rankings, estatisticas, votacoes, financeiro e imagens para compartilhar.",
  instagramHandle: cleanHandle(env.SITE_INSTAGRAM || "@sua_pelada"),
  instagramUrl: env.SITE_INSTAGRAM_URL || "",
  logo: cleanPath(env.SITE_LOGO_PATH, "/img/logo-128x128.svg"),
  logoSmall: cleanPath(env.SITE_LOGO_SMALL_PATH, "/img/logo-32x32.svg"),
  logoLarge: cleanPath(env.SITE_LOGO_LARGE_PATH, "/img/logo-512x512.svg"),
  url: env.SITE_URL || "",
  teamPrefix: env.TEAM_LABEL_PREFIX || "Time",
  colors: {
    primary: env.BRAND_PRIMARY || "#ff7a1a",
    secondary: env.BRAND_SECONDARY || "#8b1320",
    background: env.BRAND_BACKGROUND || "#050509",
  },
};

brand.instagramLabel = brand.instagramHandle || "Instagram";

module.exports = brand;
