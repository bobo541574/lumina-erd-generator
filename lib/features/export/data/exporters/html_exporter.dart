import 'dart:convert';
import '../../../schema_parser/domain/models/project_schema.dart';

class HtmlExporter {
  HtmlExporter._();

  static String export(ProjectSchema schema) {
    final tablesJson = schema.tables.map((t) {
      return {
        'name': t.name,
        'columns': t.columns.map((c) => {
              'name': c.name,
              'type': c.displayType,
              'nullable': c.nullable,
              'primary': c.primary,
              'unique': c.unique,
              'foreignKey': c.isForeignKey,
              'defaultValue': c.defaultValue,
            }).toList(),
        'isPivot': t.isPivot,
      };
    }).toList();

    final relationshipsJson = schema.relationships.map((r) => {
          'type': r.type.name,
          'source': r.sourceTable,
          'target': r.targetTable,
          'foreignKey': r.foreignKey,
          'inferred': r.isInferred,
        }).toList();

    return '''<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>${schema.projectName} - ERD</title>
<style>
*{margin:0;padding:0;box-sizing:border-box}
body{font-family:system-ui,-apple-system,sans-serif;background:#f5f5f5;color:#333;overflow:hidden;height:100vh}
.header{background:#fff;padding:12px 20px;border-bottom:1px solid #e0e0e0;display:flex;align-items:center;justify-content:space-between;z-index:10;position:relative}
.header h1{font-size:18px;font-weight:600}
.header .stats{font-size:13px;color:#666}
.controls{position:fixed;bottom:20px;right:20px;display:flex;flex-direction:column;gap:8px;z-index:10}
.controls button{width:40px;height:40px;border:none;border-radius:8px;background:#fff;box-shadow:0 2px 8px rgba(0,0,0,0.15);cursor:pointer;font-size:18px;display:flex;align-items:center;justify-content:center;transition:background 0.2s}
.controls button:hover{background:#e3f2fd}
.controls button.active{background:#e3f2fd;color:#1976d2}
canvas{display:block;width:100%;height:calc(100vh - 56px);cursor:grab}
canvas:active{cursor:grabbing}
.tooltip{position:fixed;background:#fff;padding:12px;border-radius:8px;box-shadow:0 4px 16px rgba(0,0,0,0.2);pointer-events:none;z-index:100;max-width:300px;display:none}
.tooltip h3{font-size:14px;margin-bottom:8px;padding-bottom:6px;border-bottom:1px solid #eee}
.tooltip .col{font-size:12px;padding:2px 0;font-family:monospace}
.tooltip .pk{color:#1976d2;font-weight:bold}
.tooltip .fk{color:#f57c00}
.tooltip .type{color:#7b1fa2;margin-left:8px}
.legend{position:fixed;bottom:20px;left:20px;background:#fff;padding:12px;border-radius:8px;box-shadow:0 2px 8px rgba(0,0,0,0.15);font-size:12px;z-index:10}
.legend .item{display:flex;align-items:center;gap:8px;margin:4px 0}
.legend .swatch{width:20px;height:3px;border-radius:2px}
</style>
</head>
<body>
<div class="header">
  <h1>${schema.projectName}</h1>
  <div class="stats">${schema.tables.length} tables &middot; ${schema.relationships.length} relationships</div>
</div>
<canvas id="canvas"></canvas>
<div class="tooltip" id="tooltip"></div>
<div class="controls">
  <button onclick="zoomIn()" title="Zoom In">+</button>
  <button onclick="zoomOut()" title="Zoom Out">&minus;</button>
  <button onclick="fitToScreen()" title="Fit">Fit</button>
  <button onclick="resetView()" title="Reset">Reset</button>
</div>
<div class="legend">
  <div class="item"><div class="swatch" style="background:#1976d2"></div> Migration FK</div>
  <div class="item"><div class="swatch" style="background:#f57c00"></div> Inferred</div>
  <div class="item"><div class="swatch" style="background:#9c27b0"></div> Primary Key</div>
</div>
<script>
const tables=${jsonEncode(tablesJson)};
const rels=${jsonEncode(relationshipsJson)};
const canvas=document.getElementById('canvas');
const ctx=canvas.getContext('2d');
const tooltip=document.getElementById('tooltip');
let scale=1,offsetX=0,offsetY=0,dragging=false,lastX,lastY,selectedTable=null;
const nodeW=220,nodeH=40,colH=18;
const positions={};
function init(){layoutGrid();resize();draw()}
function resize(){canvas.width=window.innerWidth;canvas.height=window.innerHeight-56;draw()}
function layoutGrid(){const cols=Math.ceil(Math.sqrt(tables.length));tables.forEach((t,i)=>{const c=i%cols,r=Math.floor(i/cols);positions[t.name]={x:c*(nodeW+40)+50,y:r*((t.columns.length*colH)+nodeH+40)+50}})}
function draw(){ctx.clearRect(0,0,canvas.width,canvas.height);ctx.save();ctx.translate(offsetX,offsetY);ctx.scale(scale,scale);drawGrid();drawRelationships();drawTables();ctx.restore()}
function drawGrid(){ctx.strokeStyle='#e0e0e0';ctx.lineWidth=0.5;const s=40;const sx=(-offsetX/scale)%s;const sy=(-offsetY/scale)%s;for(let x=sx;x<canvas.width/scale;x+=s){ctx.beginPath();ctx.moveTo(x,0);ctx.lineTo(x,canvas.height/scale);ctx.stroke()}for(let y=sy;y<canvas.height/scale;y+=s){ctx.beginPath();ctx.moveTo(0,y);ctx.lineTo(canvas.width/scale,y);ctx.stroke()}}
function drawRelationships(){rels.forEach(r=>{const s=positions[r.source],t=positions[r.target];if(!s||!t)return;const sx=s.x+nodeW/2,sy=s.y+nodeH/2,tx=t.x+nodeW/2,ty=t.y+nodeH/2;const highlighted=selectedTable&&(r.source===selectedTable||r.target===selectedTable);ctx.beginPath();ctx.strokeStyle=r.inferred?'rgba(245,124,0,0.5)':'rgba(25,118,210,0.5)';ctx.lineWidth=highlighted?2.5:1.5;const mx=(sx+tx)/2,my=(sy+ty)/2;ctx.moveTo(sx,sy);ctx.quadraticCurveTo(mx,sy,tx,ty);ctx.stroke();const angle=Math.atan2(ty-sy,tx-sx);const al=10;ctx.fillStyle=ctx.strokeStyle;ctx.beginPath();ctx.moveTo(tx,ty);ctx.lineTo(tx-al*Math.cos(angle-0.5),ty-al*Math.sin(angle-0.5));ctx.lineTo(tx-al*Math.cos(angle+0.5),ty-al*Math.sin(angle+0.5));ctx.fill()})}
function drawTables(){tables.forEach(t=>{const p=positions[t.name];if(!p)return;const h=nodeH+t.columns.length*colH;const sel=selectedTable===t.name;ctx.fillStyle=sel?'#e3f2fd':'#fff';ctx.strokeStyle=sel?'#1976d2':'#e0e0e0';ctx.lineWidth=sel?2:1;ctx.beginPath();ctx.roundRect(p.x,p.y,nodeW,h,6);ctx.fill();ctx.stroke();ctx.fillStyle='#e3f2fd';ctx.beginPath();ctx.roundRect(p.x,p.y,nodeW,nodeH,6);ctx.fill();ctx.fillStyle='#333';ctx.font='bold 13px monospace';ctx.fillText(t.name,p.x+10,p.y+24);ctx.font='11px sans-serif';ctx.fillStyle='#666';ctx.fillText(t.columns.length+' cols',p.x+nodeW-50,p.y+24);t.columns.forEach((c,i)=>{const cy=p.y+nodeH+i*colH;if(i%2===0){ctx.fillStyle='rgba(0,0,0,0.02)';ctx.fillRect(p.x,cy,nodeW,colH)}ctx.fillStyle=c.primary?'#1976d2':c.foreignKey?'#f57c00':'#555';ctx.font=c.primary||c.foreignKey?'bold 11px monospace':'11px monospace';ctx.fillText(c.name,p.x+10,cy+13);ctx.fillStyle='#999';ctx.font='10px monospace';ctx.fillText(c.type,p.x+nodeW-70,cy+13)})})}
function getTableAt(mx,my){const x=(mx-offsetX)/scale,y=(my-offsetY)/scale;for(let i=tables.length-1;i>=0;i--){const t=tables[i],p=positions[t.name];if(!p)continue;const h=nodeH+t.columns.length*colH;if(x>=p.x&&x<=p.x+nodeW&&y>=p.y&&y<=p.y+h)return t.name}return null}
function showTooltip(tname,mx,my){const t=tables.find(t=>t.name===tname);if(!t)return;let h='<h3>'+tname+'</h3>';t.columns.forEach(c=>{const cls=c.primary?'pk':c.foreignKey?'fk':'';h+='<div class="col '+cls+'">'+c.name+'<span class="type">'+c.type+'</span></div>'});tooltip.innerHTML=h;tooltip.style.display='block';tooltip.style.left=(mx+15)+'px';tooltip.style.top=(my+15)+'px'}
function hideTooltip(){tooltip.style.display='none'}
canvas.addEventListener('mousedown',e=>{dragging=true;lastX=e.clientX;lastY=e.clientY;const t=getTableAt(e.clientX,e.clientY);selectedTable=t;draw()});
canvas.addEventListener('mousemove',e=>{if(dragging){offsetX+=e.clientX-lastX;offsetY+=e.clientY-lastY;lastX=e.clientX;lastY=e.clientY;draw()}else{const t=getTableAt(e.clientX,e.clientY);if(t){canvas.style.cursor='pointer';showTooltip(t,e.clientX,e.clientY)}else{canvas.style.cursor='grab';hideTooltip()}}});
canvas.addEventListener('mouseup',()=>{dragging=false;canvas.style.cursor='grab'});
canvas.addEventListener('mouseleave',()=>{dragging=false;hideTooltip()});
canvas.addEventListener('wheel',e=>{e.preventDefault();const d=e.deltaY>0?0.9:1.1;const mx=e.clientX,my=e.clientY;offsetX=mx-(mx-offsetX)*d;offsetY=my-(my-offsetY)*d;scale*=d;scale=Math.max(0.1,Math.min(3,scale));draw()},{passive:false});
function zoomIn(){scale=Math.min(3,scale*1.2);draw()}
function zoomOut(){scale=Math.max(0.1,scale/1.2);draw()}
function fitToScreen(){if(!tables.length)return;let minX=Infinity,minY=Infinity,maxX=-Infinity,maxY=-Infinity;tables.forEach(t=>{const p=positions[t.name];if(!p)return;minX=Math.min(minX,p.x);minY=Math.min(minY,p.y);maxX=Math.max(maxX,p.x+nodeW);maxY=Math.max(maxY,p.y+200)});const cw=maxX-minX+80,ch=maxY-minY+80;scale=Math.min(canvas.width/cw,canvas.height/ch)*0.9;offsetX=(canvas.width-cw*scale)/2-minX*scale+40*scale;offsetY=(canvas.height-ch*scale)/2-minY*scale+40*scale;draw()}
function resetView(){scale=1;offsetX=0;offsetY=0;selectedTable=null;draw()}
window.addEventListener('resize',resize);
init();
</script>
</body>
</html>''';
  }
}
