const test=require('node:test'),assert=require('node:assert/strict'),fs=require('node:fs'),vm=require('node:vm');
const {publicImageUrl}=require('../utils/public_image_url');
test('share metadata uses valid HTTP URLs for relative, external and embedded photos',()=>{
 assert.equal(publicImageUrl('https://example.com','/img/a.jpg'), 'https://example.com/img/a.jpg');
 assert.equal(publicImageUrl('https://example.com','https://cdn.example.com/a.jpg'), 'https://cdn.example.com/a.jpg');
 assert.equal(publicImageUrl('https://example.com','data:image/jpeg;base64,YQ==','/img/logo.png'), 'https://example.com/img/logo.png');
});
test('voting places a registered player and guest with the same database id in separate teams',async()=>{
 const src=fs.readFileSync(require.resolve('../routes/vote'),'utf8');const start=src.indexOf('async function decoratePlayersWithLineup');const end=src.indexOf('\nasync function loadContext',start);
 const context={prisma:{lineupDraw:{findFirst:async()=>({result:{teams:[{name:'A',players:[{id:7}]},{name:'B',players:[{id:'guest-joao',guest:true}]}]}})}},normalizeTeamColorName:()=> 'Azul',TEAM_COLOR_THEMES:{Azul:{},Laranja:{}},displayTeamName:t=>t.name,positionRank:()=>0};
 vm.runInNewContext(src.slice(start,end)+';this.decorate=decoratePlayersWithLineup;',context);
 const result=await context.decorate(1,[{id:7,name:'Regular',voteKey:'7'},{id:7,name:'Guest',voteKey:'guest_7',isGuest:true,lineupKey:'guest-joao'}]);
 assert.equal(result.length,2);assert.equal(result.find(p=>!p.isGuest).teamName,'A');assert.equal(result.find(p=>p.isGuest).teamName,'B');
});
test('deleting a match preserves weekly photographs and refreshes affected player totals',async()=>{
 const src=fs.readFileSync(require.resolve('../routes/admin/matches'),'utf8');const start=src.indexOf('router.post("/matches/:id/delete"');const end=src.indexOf('\n});',start)+4;
 const operations=[];let handler;const noop={findMany:async()=>[],deleteMany:x=>Promise.resolve(x)};
 const prisma=new Proxy({playerStat:{findMany:async()=>[{playerId:31}],deleteMany:x=>Promise.resolve(x)},tournament:{findUnique:async()=>null},weeklyAward:{updateMany:x=>{operations.push(['award',x]);return Promise.resolve(x);}},match:{delete:x=>Promise.resolve(x)},$executeRaw:()=>Promise.resolve(),$transaction:async x=>Promise.all(x)},{get:(t,k)=>t[k]||noop});
 const context={router:{post:(p,a,h)=>handler=h},requireAdmin:()=>{},prisma,recomputeTotalsForPlayers:async ids=>operations.push(['totals',Array.from(ids)]),recalculateOverallForAllPlayers:async()=>operations.push(['overall']),clearCache:()=>operations.push(['cache']),console};
 vm.runInNewContext(src.slice(start,end),context);await handler({params:{id:10}},{redirect:()=>{}});
 assert.equal(operations[0][0],'award');assert.equal(operations[0][1].data.winningMatchId,null);assert.deepEqual(operations.find(x=>x[0]==='totals')[1],[31]);assert(operations.some(x=>x[0]==='cache'));
});
test('shared cache invalidation clears ranking pages',()=>{
 const cache=require('../utils/page_cache');cache.setCache('rankings:2026:9:all',{rating:8});cache.clearCache();assert.equal(cache.getCache('rankings:2026:9:all',60000),null);
});
