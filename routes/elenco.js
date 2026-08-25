const express = require("express");
const router = express.Router();
const prisma = require("../utils/db");
const { getCache, setCache } = require("../utils/page_cache");
const { getDynamicOverallSnapshot } = require("../utils/live_overall");

const ELENCO_CACHE_TTL = 5 * 60 * 1000; // 5 minutos

// Página de elenco (pública)
router.get("/", async (req, res) => {
  try {
    const query = (req.query.q || "").toString().trim();
    const position = (req.query.position || "all").toString().trim().toLowerCase();

    const isDefaultView = !query && position === "all";
    if (isDefaultView) {
      const cached = getCache("elenco", ELENCO_CACHE_TTL);
      if (cached) return res.render("elenco", cached);
    }

    const positionMap = {
      goleiro: "Goleiro",
      zagueiro: "Zagueiro",
      meia: "Meia",
      atacante: "Atacante",
    };

    const where = {};
    if (position && position !== "all") {
      where.position = positionMap[position] || position;
    }
    if (query) {
      where.OR = [
        { name: { contains: query, mode: "insensitive" } },
        { nickname: { contains: query, mode: "insensitive" } },
      ];
    }

    const [playersRaw, dynamicOverall] = await Promise.all([
      prisma.player.findMany({
        where,
        orderBy: { name: "asc" },
        include: {
          overallHistory: {
            orderBy: { calculatedAt: "desc" },
            take: 3,
          },
        },
      }),
      getDynamicOverallSnapshot({ playerWhere: where }),
    ]);

    const players = playersRaw.map((player) => {
      const latestHistory = player.overallHistory?.[0]?.overall;
      const displayOverall =
        dynamicOverall.scoreMap.get(player.id) ??
        (latestHistory != null ? Math.round(latestHistory) : null) ??
        (player.overallDynamic != null ? Math.round(player.overallDynamic) : null) ??
        Math.round(player.baseOverall || 60);

      return {
        ...player,
        displayOverall,
      };
    });

    const payload = {
      title: "Elenco",
      activePage: "elenco",
      players,
      query,
      position,
    };

    if (isDefaultView) setCache("elenco", payload);

    res.render("elenco", payload);
  } catch (err) {
    console.error("Erro ao carregar elenco:", err);
    res.status(500).send("Erro ao carregar a pagina de elenco.");
  }
});
module.exports = router;
