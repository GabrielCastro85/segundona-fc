// Open Graph requires an HTTP image URL; embedded database photos stay in the page.
function publicImageUrl(baseUrl, source, fallback, thumbUrl = (url) => url) {
  const image = typeof source === "string" && !source.startsWith("data:") ? source : fallback;
  return new URL(thumbUrl(image || "/img/logo-512x512.png", 1200), baseUrl).href;
}
module.exports = { publicImageUrl };
