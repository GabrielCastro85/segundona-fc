const test = require('node:test');
const assert = require('node:assert/strict');
const fs = require('node:fs');
const vm = require('node:vm');
const path = require('node:path');
const root = process.env.TEST_SOURCE_ROOT || path.resolve(__dirname, '..');
const read = f => fs.readFileSync(path.join(root, f), 'utf8');
function extract(source, name, indent = '') {
 const start = source.indexOf(`function ${name}(`);
 assert(start >= 0, name);
 const end = source.indexOf(`\n${indent}}`, start);
 return source.slice(start, end + indent.length + 2);
}
test('opening photo controls preserves saved and partial teams; unchecking another team does not erase them', () => {
 const fields = [[{value:'on',disabled:false},{value:'',disabled:true}],[{value:'',disabled:true}]];
 const cards = fields.map(group=>({querySelectorAll:()=>group}));
 const toggles = cards.map(card=>({checked:false,dataset:{},closest:()=>card,addEventListener(_,fn){this.change=fn;}}));
 const dialog={querySelectorAll:sel=>sel==='[data-team-photo-toggle]'?toggles:cards};
 vm.runInNewContext(extract(read('views/partials/admin_match/_scripts_main.ejs'),'setupTeamPhotoToggles','    ')+';setupTeamPhotoToggles();',{dialog});
 assert.equal(fields[0][0].value,'on'); assert.equal(fields[0][0].disabled,false);
 toggles[1].change();assert.equal(fields[0][0].value,'on');
 toggles[1].checked=true;toggles[1].change();assert.equal(fields[0][0].disabled,true);assert.equal(fields[1][0].value,'on');
});
test('sorter excludes unconfirmed players from teams and available bench', () => {
 const statsTeamGrid={dataset:{}};
 vm.runInNewContext(extract(read('views/partials/admin_match/_scripts_main.ejs'),'syncStatsTeamsFromSorter','    ')+';syncStatsTeamsFromSorter();',{
 statsTeamGrid,getStatsFieldValues:()=>({1:{present:'on'},3:{present:'on'}}),
 collectTeamsFromSorter:()=>[{players:[{id:1},{id:2}]},{players:[{id:3},{id:4}]}],
 buildStatsTeamCard:t=>JSON.stringify(t.players),setupTeamPhotoToggles:()=>{}
 });
 assert(!statsTeamGrid.innerHTML.includes('"id":2'));assert(!statsTeamGrid.innerHTML.includes('"id":4'));assert(statsTeamGrid.innerHTML.includes('"id":3'));
});
test('server ignores injected presence for an absent player in the stats wizard', async () => {
 const updates=[],creates=[];
 const prisma={player:{findMany:async()=>[{id:1},{id:2}]},playerStat:{findMany:async()=>[{id:11,playerId:1,present:true,rating:8}],update:async x=>updates.push(x),create:async x=>creates.push(x)},match:{findUnique:async()=>({id:1,playedAt:new Date()})}};
 const source='async '+extract(read('routes/admin/matches.js'),'saveMatchStatsFromBody');
 const context={prisma,isGoalkeeperPosition:()=>false,clearCache:()=>{},recomputeTotalsForPlayers:async()=>{},recalculateOverallForAllPlayers:async()=>{},updateAllPlayersOverallAfterMatch:async()=>{},ensureFinanceSettings:async()=>({})};
 vm.runInNewContext(source+';this.save=saveMatchStatsFromBody;',context);
 await context.save(1,{present_1:'on',present_2:'on',photo_1:'on',ownGoals_1:'2',goals_2:'3'},{confirmedOnly:true});
 assert.equal(creates.length,0);assert.equal(updates.length,1);assert.equal(updates[0].data.rating,8);assert.equal(updates[0].data.appearedInPhoto,true);assert.equal(updates[0].data.ownGoals,2);
});
test('weekly image survives deletion of its temporary upload', async () => {
 const sharp=require('sharp'),os=require('node:os');
 const temp=fs.mkdtempSync(path.join(os.tmpdir(),'segundona-photo-'));const file=path.join(temp,'photo.png');
 try{
 await sharp({create:{width:20,height:10,channels:3,background:'#123456'}}).png().toFile(file);
 const mod={exports:{}};vm.runInNewContext(read('utils/upload.js'),{require,module:mod,__dirname:path.join(root,'utils')});
 const saved=await mod.exports.persistWeeklyTeamPhoto({path:file});fs.unlinkSync(file);
 assert(saved.startsWith('data:image/jpeg;base64,'));const image=await sharp(Buffer.from(saved.split(',')[1],'base64')).metadata();assert.equal(image.width,20);
 }finally{fs.rmSync(temp,{recursive:true,force:true});}
});
test('overall average ignores absences and does not invent a score for a match without votes', async()=>{
 const player={id:1,stats:[{playerId:1,present:true,rating:8,match:{id:1}},{playerId:1,present:false,rating:0,match:{id:2}}]};
 const mod={exports:{}};
 vm.runInNewContext(read('utils/live_overall.js'),{module:mod,console,require:name=>{
 if(name==='./db')return {match:{findMany:async()=>[{id:1},{id:2}]},player:{findMany:async()=>[player]}};
 if(name==='./overall')return {computeOverallFromEntries:entries=>({computed:entries.map(e=>({...e,overall:80}))})};
 if(name==='./match_ratings')return {computeMatchRatingsAndAwards:async()=>({publicVotes:[],scores:new Map([[1,{player:{id:1},finalRating:4.25,votesCount:0}]])})};
 throw Error(name);
 }});
 const result=await mod.exports.getDynamicOverallSnapshot();assert.equal(result.entries[0].rating,8);assert.equal(result.entries[0].matches,1);
});
