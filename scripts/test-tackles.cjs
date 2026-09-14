const fs = require('node:fs');
const vm = require('node:vm');
const assert = require('node:assert/strict');
const source = fs.readFileSync('utils/match_ratings.js', 'utf8');
function load(code, stats) {
  const module = { exports: {} };
  vm.runInNewContext(code, { module, exports: module.exports, require(name) {
    if (name === './db') return { voteBallot: { findMany: async () => [{ ratings: stats.map(s => ({playerId:s.playerId,rating:4})), guestRatings:[], rankings:[] }] }, playerStat:{findMany:async()=>stats} };
    if (name.includes('weeklyVoteValidation')) return { isWeeklyVoteBallotValid:()=>true };
    if (name === './weekly_selection') return { buildWeeklySelection:()=>[], normalizePositionGroup:x=>x, syncMatchGuestsFromLatestLineup:async()=>[] };
    throw Error(name);
  } });
  return module.exports.computeMatchRatingsAndAwards(1);
}
(async()=>{
 for (const position of ['Goleiro','Zagueiro','Volante','Meia','Atacante','Outro']) {
  const stats = [0,1].map(i=>({id:i+1,playerId:i+1,player:{id:i+1,position},goals:i,assists:i,saves:position==='Goleiro'?i*8:null,appearedInPhoto:!!i}));
  const unchanged=await load(source,stats);
  assert.equal(unchanged.scores.get(1).finalRating,6.8);
  if(position!=='Goleiro') assert.equal(unchanged.scores.get(2).finalRating,8.3);
  stats[0].tackles=5;
  const changed=await load(source,stats);
  assert(changed.scores.get(1).finalRating>unchanged.scores.get(1).finalRating,position+' reward');
  for(const score of changed.scores.values()) assert(score.finalRating>=0&&score.finalRating<=10);
  stats[0].tackles=0;stats[1].tackles=0;
  const zero=await load(source,stats);
  assert.equal(zero.scores.get(1).finalRating,unchanged.scores.get(1).finalRating);
 }
 console.log('PASS: six positions, historical compatibility, zero tackles, positive contribution and rating bounds');
})().catch(e=>{console.error(e);process.exitCode=1});
