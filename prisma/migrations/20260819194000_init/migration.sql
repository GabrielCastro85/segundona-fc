-- CreateEnum
CREATE TYPE "SeasonAwardCategory" AS ENUM ('ARTILHEIRO', 'ASSISTENTE', 'MELHOR_JOGADOR', 'MELHOR_GOLEIRO', 'MELHOR_ZAGUEIRO', 'MELHOR_MEIA', 'MELHOR_ATACANTE', 'REI_DAS_FOTOS');

-- CreateEnum
CREATE TYPE "VoteCategory" AS ENUM ('GOLEIRO', 'ZAGUEIRO', 'MEIA', 'ATACANTE', 'CRAQUE');

-- CreateEnum
CREATE TYPE "TournamentStage" AS ENUM ('GROUP', 'SEMI', 'FINAL');

-- CreateEnum
CREATE TYPE "TournamentGameDecidedBy" AS ENUM ('ADVANTAGE', 'PENALTIES');

-- CreateEnum
CREATE TYPE "MonthlyFeeStatus" AS ENUM ('PENDING', 'PAID', 'PARTIAL', 'EXEMPT');

-- CreateEnum
CREATE TYPE "MonthlyFeeBillingMode" AS ENUM ('MONTHLY', 'PER_MATCH', 'LATE_PER_MATCH', 'EXEMPT');

-- CreateEnum
CREATE TYPE "FinancePaymentMethod" AS ENUM ('PIX', 'CASH', 'TRANSFER', 'CARD', 'OTHER');

-- CreateEnum
CREATE TYPE "FinanceParticipantType" AS ENUM ('MONTHLY', 'PER_MATCH', 'GUEST', 'EXEMPT', 'SPECIAL');

-- CreateEnum
CREATE TYPE "FinanceChargeBehavior" AS ENUM ('AUTOMATIC', 'ASSISTED', 'MANUAL_ONLY');

-- CreateEnum
CREATE TYPE "FinanceTransactionType" AS ENUM ('INCOME', 'EXPENSE');

-- CreateEnum
CREATE TYPE "FinanceTransactionOrigin" AS ENUM ('MANUAL', 'MONTHLY_FEE', 'GUEST_PAYMENT', 'RECURRING_EXPENSE');

-- CreateEnum
CREATE TYPE "FinanceTransactionCategory" AS ENUM ('MONTHLY_FEE', 'GUEST', 'EXTRA', 'SPONSORSHIP', 'OTHER_INCOME', 'COURT', 'BALL', 'BIB', 'REFEREE', 'DRINK', 'MAINTENANCE', 'PRIZE', 'OTHER_EXPENSE');

-- CreateTable
CREATE TABLE "Admin" (
    "id" SERIAL NOT NULL,
    "email" TEXT NOT NULL,
    "passwordHash" TEXT NOT NULL,

    CONSTRAINT "Admin_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "AuditLog" (
    "id" SERIAL NOT NULL,
    "adminId" INTEGER,
    "adminEmail" TEXT,
    "method" TEXT NOT NULL,
    "path" TEXT NOT NULL,
    "action" TEXT NOT NULL,
    "summary" TEXT,
    "details" JSONB,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "AuditLog_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Player" (
    "id" SERIAL NOT NULL,
    "name" TEXT NOT NULL,
    "nickname" TEXT,
    "position" TEXT NOT NULL,
    "photoUrl" TEXT,
    "totalGoals" INTEGER NOT NULL DEFAULT 0,
    "totalAssists" INTEGER NOT NULL DEFAULT 0,
    "totalSaves" INTEGER NOT NULL DEFAULT 0,
    "totalMatches" INTEGER NOT NULL DEFAULT 0,
    "totalPhotos" INTEGER NOT NULL DEFAULT 0,
    "totalRating" DOUBLE PRECISION NOT NULL DEFAULT 0,
    "financeActive" BOOLEAN NOT NULL DEFAULT true,
    "isMonthlyMember" BOOLEAN NOT NULL DEFAULT true,
    "financeParticipantType" "FinanceParticipantType" NOT NULL DEFAULT 'MONTHLY',
    "financeAmountOverride" DECIMAL(10,2),
    "financeMatchLimit" INTEGER,
    "financeExtraMatchAmount" DECIMAL(10,2),
    "financeAutoDiscountAmount" DECIMAL(10,2) NOT NULL DEFAULT 0,
    "financeNotes" TEXT,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,
    "whatsapp" TEXT,
    "hallBadges" JSONB,
    "hallInductedAt" TIMESTAMP(3),
    "hallReason" TEXT,
    "hallTitle" TEXT,
    "isHallOfFame" BOOLEAN NOT NULL DEFAULT false,
    "baseOverall" DOUBLE PRECISION NOT NULL DEFAULT 60,
    "overallDynamic" DOUBLE PRECISION,
    "overallLastUpdated" TIMESTAMP(6),

    CONSTRAINT "Player_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Match" (
    "id" SERIAL NOT NULL,
    "playedAt" TIMESTAMP(3) NOT NULL,
    "description" TEXT,
    "winnerTeam" TEXT,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,
    "votingToken" TEXT,
    "votingStatus" TEXT DEFAULT 'CLOSED',
    "winnerColor" TEXT,

    CONSTRAINT "Match_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Tournament" (
    "id" SERIAL NOT NULL,
    "matchId" INTEGER NOT NULL,
    "title" TEXT,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "Tournament_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "TournamentTeam" (
    "id" SERIAL NOT NULL,
    "tournamentId" INTEGER NOT NULL,
    "name" TEXT NOT NULL,
    "color" TEXT,
    "seed" INTEGER,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "TournamentTeam_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "TournamentGame" (
    "id" SERIAL NOT NULL,
    "tournamentId" INTEGER NOT NULL,
    "stage" "TournamentStage" NOT NULL,
    "round" INTEGER,
    "homeTeamId" INTEGER NOT NULL,
    "awayTeamId" INTEGER NOT NULL,
    "homeGoals" INTEGER,
    "awayGoals" INTEGER,
    "homePenalties" INTEGER,
    "awayPenalties" INTEGER,
    "winnerTeamId" INTEGER,
    "decidedBy" "TournamentGameDecidedBy",
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "TournamentGame_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "PlayerStat" (
    "id" SERIAL NOT NULL,
    "playerId" INTEGER NOT NULL,
    "matchId" INTEGER NOT NULL,
    "present" BOOLEAN NOT NULL DEFAULT false,
    "goals" INTEGER NOT NULL DEFAULT 0,
    "assists" INTEGER NOT NULL DEFAULT 0,
    "saves" INTEGER,
    "rating" DOUBLE PRECISION,
    "appearedInPhoto" BOOLEAN NOT NULL DEFAULT false,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "PlayerStat_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "WeeklyAward" (
    "id" SERIAL NOT NULL,
    "weekStart" TIMESTAMP(3) NOT NULL,
    "teamPhotoUrl" TEXT,
    "bestPlayerId" INTEGER,
    "winningMatchId" INTEGER,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "WeeklyAward_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "MonthlyAward" (
    "id" SERIAL NOT NULL,
    "month" INTEGER NOT NULL,
    "year" INTEGER NOT NULL,
    "craqueId" INTEGER,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "MonthlyAward_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "SeasonAward" (
    "id" SERIAL NOT NULL,
    "year" INTEGER NOT NULL,
    "category" "SeasonAwardCategory" NOT NULL,
    "playerId" INTEGER NOT NULL,
    "featuredOnHome" BOOLEAN NOT NULL DEFAULT false,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "SeasonAward_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "VoteSession" (
    "id" SERIAL NOT NULL,
    "matchId" INTEGER NOT NULL,
    "expiresAt" TIMESTAMP(3),
    "createdByAdminId" INTEGER,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "VoteSession_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "VoteToken" (
    "id" SERIAL NOT NULL,
    "token" TEXT NOT NULL,
    "voteSessionId" INTEGER NOT NULL,
    "playerId" INTEGER NOT NULL,
    "usedAt" TIMESTAMP(3),
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "VoteToken_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "VoteBallot" (
    "id" SERIAL NOT NULL,
    "voteTokenId" INTEGER NOT NULL,
    "bestOverallPlayerId" INTEGER,
    "isInvalid" BOOLEAN NOT NULL DEFAULT false,
    "invalidReason" TEXT,
    "invalidCode" TEXT,
    "validatedManually" BOOLEAN NOT NULL DEFAULT false,
    "validatedManuallyAt" TIMESTAMP(3),
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "VoteBallot_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "VoteRating" (
    "id" SERIAL NOT NULL,
    "voteBallotId" INTEGER NOT NULL,
    "playerId" INTEGER NOT NULL,
    "rating" INTEGER NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "VoteRating_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "VoteRanking" (
    "id" SERIAL NOT NULL,
    "voteBallotId" INTEGER NOT NULL,
    "position" TEXT NOT NULL,
    "playerId" INTEGER NOT NULL,
    "rank" INTEGER NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "VoteRanking_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "VoteLink" (
    "id" SERIAL NOT NULL,
    "token" TEXT NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "usedAt" TIMESTAMP(3),
    "playerId" INTEGER NOT NULL,
    "matchId" INTEGER NOT NULL,
    "phone" TEXT,

    CONSTRAINT "VoteLink_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "MonthlyVoteSession" (
    "id" SERIAL NOT NULL,
    "month" INTEGER NOT NULL,
    "year" INTEGER NOT NULL,
    "candidates" JSONB NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "expiresAt" TIMESTAMP(3),
    "createdByAdminId" INTEGER,

    CONSTRAINT "MonthlyVoteSession_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "MonthlyVoteToken" (
    "id" SERIAL NOT NULL,
    "token" TEXT NOT NULL,
    "sessionId" INTEGER NOT NULL,
    "playerId" INTEGER NOT NULL,
    "usedAt" TIMESTAMP(3),
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "MonthlyVoteToken_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "MonthlyVoteBallot" (
    "id" SERIAL NOT NULL,
    "tokenId" INTEGER NOT NULL,
    "candidateId" INTEGER NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "MonthlyVoteBallot_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "VoteChoice" (
    "id" SERIAL NOT NULL,
    "category" "VoteCategory" NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "voteLinkId" INTEGER NOT NULL,
    "targetPlayerId" INTEGER NOT NULL,

    CONSTRAINT "VoteChoice_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Achievement" (
    "id" SERIAL NOT NULL,
    "description" TEXT NOT NULL,
    "category" TEXT NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "code" TEXT NOT NULL,
    "title" TEXT NOT NULL,
    "rarity" TEXT NOT NULL,
    "targetValue" INTEGER,
    "symbol" TEXT,
    "isNumeric" BOOLEAN NOT NULL DEFAULT false,
    "sortOrder" INTEGER NOT NULL DEFAULT 0,

    CONSTRAINT "Achievement_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "PlayerAchievement" (
    "id" SERIAL NOT NULL,
    "playerId" INTEGER NOT NULL,
    "achievementId" INTEGER NOT NULL,
    "unlockedAt" TIMESTAMP(3),
    "progressValue" INTEGER NOT NULL DEFAULT 0,
    "createdAt" TIMESTAMP(6) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(6) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "PlayerAchievement_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "OverallHistory" (
    "id" SERIAL NOT NULL,
    "playerId" INTEGER NOT NULL,
    "overall" DOUBLE PRECISION NOT NULL,
    "window" TEXT,
    "source" JSONB,
    "calculatedAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "OverallHistory_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "LineupDraw" (
    "id" SERIAL NOT NULL,
    "matchId" INTEGER NOT NULL,
    "seed" TEXT NOT NULL,
    "parameters" JSONB,
    "result" JSONB NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "LineupDraw_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "FinanceSettings" (
    "id" SERIAL NOT NULL,
    "defaultMonthlyAmount" DECIMAL(10,2) NOT NULL DEFAULT 50,
    "dueDay" INTEGER NOT NULL DEFAULT 10,
    "latePerMatchAmount" DECIMAL(10,2) NOT NULL DEFAULT 25,
    "pixKey" TEXT,
    "pixReceiverName" TEXT,
    "defaultWhatsappMessage" TEXT,
    "defaultIncludedMatches" INTEGER NOT NULL DEFAULT 0,
    "defaultExtraMatchAmount" DECIMAL(10,2) NOT NULL DEFAULT 0,
    "defaultAutoDiscountAmount" DECIMAL(10,2) NOT NULL DEFAULT 0,
    "chargeBehavior" "FinanceChargeBehavior" NOT NULL DEFAULT 'ASSISTED',
    "autoGenerateCompetence" BOOLEAN NOT NULL DEFAULT false,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "FinanceSettings_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "FinanceEventLog" (
    "id" SERIAL NOT NULL,
    "action" TEXT NOT NULL,
    "entity" TEXT NOT NULL,
    "entityId" TEXT,
    "sourceTab" TEXT,
    "adminId" INTEGER,
    "adminEmail" TEXT,
    "payload" JSONB,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "FinanceEventLog_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "RecurringExpense" (
    "id" SERIAL NOT NULL,
    "name" TEXT NOT NULL,
    "amount" DECIMAL(10,2) NOT NULL,
    "category" "FinanceTransactionCategory" NOT NULL DEFAULT 'COURT',
    "dayOfMonth" INTEGER NOT NULL DEFAULT 1,
    "isActive" BOOLEAN NOT NULL DEFAULT true,
    "startMonth" INTEGER NOT NULL,
    "startYear" INTEGER NOT NULL,
    "endMonth" INTEGER,
    "endYear" INTEGER,
    "description" TEXT,
    "note" TEXT,
    "createdByAdminId" INTEGER,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "RecurringExpense_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "RecurringExpenseRun" (
    "id" SERIAL NOT NULL,
    "recurringExpenseId" INTEGER NOT NULL,
    "month" INTEGER NOT NULL,
    "year" INTEGER NOT NULL,
    "cashTransactionId" INTEGER NOT NULL,
    "generatedAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "RecurringExpenseRun_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "MonthlyFee" (
    "id" SERIAL NOT NULL,
    "playerId" INTEGER NOT NULL,
    "month" INTEGER NOT NULL,
    "year" INTEGER NOT NULL,
    "amountDue" DECIMAL(10,2) NOT NULL,
    "amountPaid" DECIMAL(10,2) NOT NULL DEFAULT 0,
    "status" "MonthlyFeeStatus" NOT NULL DEFAULT 'PENDING',
    "billingMode" "MonthlyFeeBillingMode" NOT NULL DEFAULT 'MONTHLY',
    "dueDate" TIMESTAMP(3),
    "paidAt" TIMESTAMP(3),
    "paymentMethod" "FinancePaymentMethod",
    "note" TEXT,
    "participantType" "FinanceParticipantType" NOT NULL DEFAULT 'MONTHLY',
    "baseAmount" DECIMAL(10,2) NOT NULL DEFAULT 0,
    "autoDiscountAmount" DECIMAL(10,2) NOT NULL DEFAULT 0,
    "manualDiscountAmount" DECIMAL(10,2) NOT NULL DEFAULT 0,
    "extraAmount" DECIMAL(10,2) NOT NULL DEFAULT 0,
    "matchesPlayed" INTEGER NOT NULL DEFAULT 0,
    "lateMatchesPlayed" INTEGER NOT NULL DEFAULT 0,
    "matchLimitApplied" INTEGER,
    "latePerMatchAmount" DECIMAL(10,2) NOT NULL DEFAULT 25,
    "customAmountApplied" BOOLEAN NOT NULL DEFAULT false,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "MonthlyFee_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "GuestPayment" (
    "id" SERIAL NOT NULL,
    "guestName" TEXT NOT NULL,
    "date" TIMESTAMP(3) NOT NULL,
    "amount" DECIMAL(10,2) NOT NULL,
    "note" TEXT,
    "month" INTEGER,
    "year" INTEGER,
    "matchId" INTEGER,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,
    "deletedAt" TIMESTAMP(3),

    CONSTRAINT "GuestPayment_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "CashTransaction" (
    "id" SERIAL NOT NULL,
    "type" "FinanceTransactionType" NOT NULL,
    "category" "FinanceTransactionCategory" NOT NULL,
    "amount" DECIMAL(10,2) NOT NULL,
    "description" TEXT NOT NULL,
    "date" TIMESTAMP(3) NOT NULL,
    "note" TEXT,
    "origin" "FinanceTransactionOrigin" NOT NULL DEFAULT 'MANUAL',
    "playerId" INTEGER,
    "monthlyFeeId" INTEGER,
    "guestPaymentId" INTEGER,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,
    "deletedAt" TIMESTAMP(3),

    CONSTRAINT "CashTransaction_pkey" PRIMARY KEY ("id")
);

-- CreateIndex
CREATE UNIQUE INDEX "Admin_email_key" ON "Admin"("email");

-- CreateIndex
CREATE INDEX "AuditLog_createdAt_idx" ON "AuditLog"("createdAt");

-- CreateIndex
CREATE INDEX "AuditLog_adminId_idx" ON "AuditLog"("adminId");

-- CreateIndex
CREATE INDEX "Match_playedAt_idx" ON "Match"("playedAt");

-- CreateIndex
CREATE UNIQUE INDEX "Tournament_matchId_key" ON "Tournament"("matchId");

-- CreateIndex
CREATE INDEX "PlayerStat_matchId_idx" ON "PlayerStat"("matchId");

-- CreateIndex
CREATE UNIQUE INDEX "PlayerStat_playerId_matchId_key" ON "PlayerStat"("playerId", "matchId");

-- CreateIndex
CREATE UNIQUE INDEX "WeeklyAward_weekStart_key" ON "WeeklyAward"("weekStart");

-- CreateIndex
CREATE UNIQUE INDEX "MonthlyAward_month_year_key" ON "MonthlyAward"("month", "year");

-- CreateIndex
CREATE UNIQUE INDEX "SeasonAward_year_category_key" ON "SeasonAward"("year", "category");

-- CreateIndex
CREATE UNIQUE INDEX "VoteToken_token_key" ON "VoteToken"("token");

-- CreateIndex
CREATE INDEX "VoteToken_playerId_idx" ON "VoteToken"("playerId");

-- CreateIndex
CREATE UNIQUE INDEX "VoteToken_voteSessionId_playerId_key" ON "VoteToken"("voteSessionId", "playerId");

-- CreateIndex
CREATE UNIQUE INDEX "VoteBallot_voteTokenId_key" ON "VoteBallot"("voteTokenId");

-- CreateIndex
CREATE INDEX "VoteBallot_isInvalid_idx" ON "VoteBallot"("isInvalid");

-- CreateIndex
CREATE INDEX "VoteBallot_validatedManually_idx" ON "VoteBallot"("validatedManually");

-- CreateIndex
CREATE INDEX "VoteRating_playerId_idx" ON "VoteRating"("playerId");

-- CreateIndex
CREATE UNIQUE INDEX "VoteRating_voteBallotId_playerId_key" ON "VoteRating"("voteBallotId", "playerId");

-- CreateIndex
CREATE INDEX "VoteRanking_playerId_idx" ON "VoteRanking"("playerId");

-- CreateIndex
CREATE UNIQUE INDEX "VoteRanking_voteBallotId_position_rank_key" ON "VoteRanking"("voteBallotId", "position", "rank");

-- CreateIndex
CREATE UNIQUE INDEX "VoteLink_token_key" ON "VoteLink"("token");

-- CreateIndex
CREATE INDEX "VoteLink_playerId_idx" ON "VoteLink"("playerId");

-- CreateIndex
CREATE INDEX "VoteLink_matchId_idx" ON "VoteLink"("matchId");

-- CreateIndex
CREATE UNIQUE INDEX "MonthlyVoteSession_month_year_key" ON "MonthlyVoteSession"("month", "year");

-- CreateIndex
CREATE UNIQUE INDEX "MonthlyVoteToken_token_key" ON "MonthlyVoteToken"("token");

-- CreateIndex
CREATE INDEX "MonthlyVoteToken_playerId_idx" ON "MonthlyVoteToken"("playerId");

-- CreateIndex
CREATE UNIQUE INDEX "MonthlyVoteToken_sessionId_playerId_key" ON "MonthlyVoteToken"("sessionId", "playerId");

-- CreateIndex
CREATE UNIQUE INDEX "MonthlyVoteBallot_tokenId_key" ON "MonthlyVoteBallot"("tokenId");

-- CreateIndex
CREATE INDEX "MonthlyVoteBallot_candidateId_idx" ON "MonthlyVoteBallot"("candidateId");

-- CreateIndex
CREATE INDEX "VoteChoice_voteLinkId_idx" ON "VoteChoice"("voteLinkId");

-- CreateIndex
CREATE INDEX "VoteChoice_targetPlayerId_idx" ON "VoteChoice"("targetPlayerId");

-- CreateIndex
CREATE UNIQUE INDEX "Achievement_code_key" ON "Achievement"("code");

-- CreateIndex
CREATE INDEX "PlayerAchievement_playerId_idx" ON "PlayerAchievement"("playerId");

-- CreateIndex
CREATE INDEX "PlayerAchievement_achievementId_idx" ON "PlayerAchievement"("achievementId");

-- CreateIndex
CREATE UNIQUE INDEX "PlayerAchievement_playerId_achievementId_key" ON "PlayerAchievement"("playerId", "achievementId");

-- CreateIndex
CREATE INDEX "OverallHistory_playerId_calculatedAt_idx" ON "OverallHistory"("playerId", "calculatedAt");

-- CreateIndex
CREATE INDEX "LineupDraw_matchId_createdAt_idx" ON "LineupDraw"("matchId", "createdAt");

-- CreateIndex
CREATE INDEX "FinanceEventLog_createdAt_idx" ON "FinanceEventLog"("createdAt");

-- CreateIndex
CREATE INDEX "FinanceEventLog_action_idx" ON "FinanceEventLog"("action");

-- CreateIndex
CREATE INDEX "FinanceEventLog_entity_entityId_idx" ON "FinanceEventLog"("entity", "entityId");

-- CreateIndex
CREATE INDEX "FinanceEventLog_adminId_idx" ON "FinanceEventLog"("adminId");

-- CreateIndex
CREATE INDEX "RecurringExpense_isActive_startYear_startMonth_idx" ON "RecurringExpense"("isActive", "startYear", "startMonth");

-- CreateIndex
CREATE INDEX "RecurringExpense_category_idx" ON "RecurringExpense"("category");

-- CreateIndex
CREATE INDEX "RecurringExpense_createdByAdminId_idx" ON "RecurringExpense"("createdByAdminId");

-- CreateIndex
CREATE UNIQUE INDEX "RecurringExpenseRun_cashTransactionId_key" ON "RecurringExpenseRun"("cashTransactionId");

-- CreateIndex
CREATE INDEX "RecurringExpenseRun_year_month_idx" ON "RecurringExpenseRun"("year", "month");

-- CreateIndex
CREATE UNIQUE INDEX "RecurringExpenseRun_recurringExpenseId_month_year_key" ON "RecurringExpenseRun"("recurringExpenseId", "month", "year");

-- CreateIndex
CREATE INDEX "MonthlyFee_playerId_year_month_idx" ON "MonthlyFee"("playerId", "year", "month");

-- CreateIndex
CREATE INDEX "MonthlyFee_year_month_status_idx" ON "MonthlyFee"("year", "month", "status");

-- CreateIndex
CREATE UNIQUE INDEX "MonthlyFee_playerId_month_year_key" ON "MonthlyFee"("playerId", "month", "year");

-- CreateIndex
CREATE INDEX "GuestPayment_date_idx" ON "GuestPayment"("date");

-- CreateIndex
CREATE INDEX "GuestPayment_year_month_idx" ON "GuestPayment"("year", "month");

-- CreateIndex
CREATE INDEX "GuestPayment_matchId_idx" ON "GuestPayment"("matchId");

-- CreateIndex
CREATE UNIQUE INDEX "CashTransaction_guestPaymentId_key" ON "CashTransaction"("guestPaymentId");

-- CreateIndex
CREATE INDEX "CashTransaction_date_type_idx" ON "CashTransaction"("date", "type");

-- CreateIndex
CREATE INDEX "CashTransaction_category_idx" ON "CashTransaction"("category");

-- CreateIndex
CREATE INDEX "CashTransaction_playerId_idx" ON "CashTransaction"("playerId");

-- CreateIndex
CREATE INDEX "CashTransaction_monthlyFeeId_idx" ON "CashTransaction"("monthlyFeeId");

-- AddForeignKey
ALTER TABLE "AuditLog" ADD CONSTRAINT "AuditLog_adminId_fkey" FOREIGN KEY ("adminId") REFERENCES "Admin"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Tournament" ADD CONSTRAINT "Tournament_matchId_fkey" FOREIGN KEY ("matchId") REFERENCES "Match"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "TournamentTeam" ADD CONSTRAINT "TournamentTeam_tournamentId_fkey" FOREIGN KEY ("tournamentId") REFERENCES "Tournament"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "TournamentGame" ADD CONSTRAINT "TournamentGame_tournamentId_fkey" FOREIGN KEY ("tournamentId") REFERENCES "Tournament"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "TournamentGame" ADD CONSTRAINT "TournamentGame_homeTeamId_fkey" FOREIGN KEY ("homeTeamId") REFERENCES "TournamentTeam"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "TournamentGame" ADD CONSTRAINT "TournamentGame_awayTeamId_fkey" FOREIGN KEY ("awayTeamId") REFERENCES "TournamentTeam"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "TournamentGame" ADD CONSTRAINT "TournamentGame_winnerTeamId_fkey" FOREIGN KEY ("winnerTeamId") REFERENCES "TournamentTeam"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "PlayerStat" ADD CONSTRAINT "PlayerStat_matchId_fkey" FOREIGN KEY ("matchId") REFERENCES "Match"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "PlayerStat" ADD CONSTRAINT "PlayerStat_playerId_fkey" FOREIGN KEY ("playerId") REFERENCES "Player"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "WeeklyAward" ADD CONSTRAINT "WeeklyAward_bestPlayerId_fkey" FOREIGN KEY ("bestPlayerId") REFERENCES "Player"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "WeeklyAward" ADD CONSTRAINT "WeeklyAward_winningMatchId_fkey" FOREIGN KEY ("winningMatchId") REFERENCES "Match"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "MonthlyAward" ADD CONSTRAINT "MonthlyAward_craqueId_fkey" FOREIGN KEY ("craqueId") REFERENCES "Player"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "SeasonAward" ADD CONSTRAINT "SeasonAward_playerId_fkey" FOREIGN KEY ("playerId") REFERENCES "Player"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "VoteSession" ADD CONSTRAINT "VoteSession_createdByAdminId_fkey" FOREIGN KEY ("createdByAdminId") REFERENCES "Admin"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "VoteSession" ADD CONSTRAINT "VoteSession_matchId_fkey" FOREIGN KEY ("matchId") REFERENCES "Match"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "VoteToken" ADD CONSTRAINT "VoteToken_playerId_fkey" FOREIGN KEY ("playerId") REFERENCES "Player"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "VoteToken" ADD CONSTRAINT "VoteToken_voteSessionId_fkey" FOREIGN KEY ("voteSessionId") REFERENCES "VoteSession"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "VoteBallot" ADD CONSTRAINT "VoteBallot_bestOverallPlayerId_fkey" FOREIGN KEY ("bestOverallPlayerId") REFERENCES "Player"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "VoteBallot" ADD CONSTRAINT "VoteBallot_voteTokenId_fkey" FOREIGN KEY ("voteTokenId") REFERENCES "VoteToken"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "VoteRating" ADD CONSTRAINT "VoteRating_playerId_fkey" FOREIGN KEY ("playerId") REFERENCES "Player"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "VoteRating" ADD CONSTRAINT "VoteRating_voteBallotId_fkey" FOREIGN KEY ("voteBallotId") REFERENCES "VoteBallot"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "VoteRanking" ADD CONSTRAINT "VoteRanking_playerId_fkey" FOREIGN KEY ("playerId") REFERENCES "Player"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "VoteRanking" ADD CONSTRAINT "VoteRanking_voteBallotId_fkey" FOREIGN KEY ("voteBallotId") REFERENCES "VoteBallot"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "VoteLink" ADD CONSTRAINT "VoteLink_matchId_fkey" FOREIGN KEY ("matchId") REFERENCES "Match"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "VoteLink" ADD CONSTRAINT "VoteLink_playerId_fkey" FOREIGN KEY ("playerId") REFERENCES "Player"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "MonthlyVoteSession" ADD CONSTRAINT "MonthlyVoteSession_createdByAdminId_fkey" FOREIGN KEY ("createdByAdminId") REFERENCES "Admin"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "MonthlyVoteToken" ADD CONSTRAINT "MonthlyVoteToken_sessionId_fkey" FOREIGN KEY ("sessionId") REFERENCES "MonthlyVoteSession"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "MonthlyVoteToken" ADD CONSTRAINT "MonthlyVoteToken_playerId_fkey" FOREIGN KEY ("playerId") REFERENCES "Player"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "MonthlyVoteBallot" ADD CONSTRAINT "MonthlyVoteBallot_tokenId_fkey" FOREIGN KEY ("tokenId") REFERENCES "MonthlyVoteToken"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "MonthlyVoteBallot" ADD CONSTRAINT "MonthlyVoteBallot_candidateId_fkey" FOREIGN KEY ("candidateId") REFERENCES "Player"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "VoteChoice" ADD CONSTRAINT "VoteChoice_targetPlayerId_fkey" FOREIGN KEY ("targetPlayerId") REFERENCES "Player"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "VoteChoice" ADD CONSTRAINT "VoteChoice_voteLinkId_fkey" FOREIGN KEY ("voteLinkId") REFERENCES "VoteLink"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "PlayerAchievement" ADD CONSTRAINT "PlayerAchievement_achievementId_fkey" FOREIGN KEY ("achievementId") REFERENCES "Achievement"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "PlayerAchievement" ADD CONSTRAINT "PlayerAchievement_playerId_fkey" FOREIGN KEY ("playerId") REFERENCES "Player"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "OverallHistory" ADD CONSTRAINT "OverallHistory_playerId_fkey" FOREIGN KEY ("playerId") REFERENCES "Player"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "LineupDraw" ADD CONSTRAINT "LineupDraw_matchId_fkey" FOREIGN KEY ("matchId") REFERENCES "Match"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "FinanceEventLog" ADD CONSTRAINT "FinanceEventLog_adminId_fkey" FOREIGN KEY ("adminId") REFERENCES "Admin"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "RecurringExpense" ADD CONSTRAINT "RecurringExpense_createdByAdminId_fkey" FOREIGN KEY ("createdByAdminId") REFERENCES "Admin"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "RecurringExpenseRun" ADD CONSTRAINT "RecurringExpenseRun_recurringExpenseId_fkey" FOREIGN KEY ("recurringExpenseId") REFERENCES "RecurringExpense"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "RecurringExpenseRun" ADD CONSTRAINT "RecurringExpenseRun_cashTransactionId_fkey" FOREIGN KEY ("cashTransactionId") REFERENCES "CashTransaction"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "MonthlyFee" ADD CONSTRAINT "MonthlyFee_playerId_fkey" FOREIGN KEY ("playerId") REFERENCES "Player"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "GuestPayment" ADD CONSTRAINT "GuestPayment_matchId_fkey" FOREIGN KEY ("matchId") REFERENCES "Match"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "CashTransaction" ADD CONSTRAINT "CashTransaction_playerId_fkey" FOREIGN KEY ("playerId") REFERENCES "Player"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "CashTransaction" ADD CONSTRAINT "CashTransaction_monthlyFeeId_fkey" FOREIGN KEY ("monthlyFeeId") REFERENCES "MonthlyFee"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "CashTransaction" ADD CONSTRAINT "CashTransaction_guestPaymentId_fkey" FOREIGN KEY ("guestPaymentId") REFERENCES "GuestPayment"("id") ON DELETE SET NULL ON UPDATE CASCADE;

