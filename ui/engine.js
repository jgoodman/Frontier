var canvas = document.getElementById('myCanvas');
var pctx = canvas.getContext('2d');
var secondaryCanvas = document.createElement("canvas");
secondaryCanvas.width = canvas.width;
secondaryCanvas.height = canvas.height;
var ctx = secondaryCanvas.getContext('2d');

var moveTime = 0.0001;
var updateTime = moveTime;
var lastTime = performance.now();
var imageList = {};
var json = {
  "obj_is" : {},
  "obj" : {},
};

function resize_canvas(){
    canvas.width  = window.innerWidth;
    canvas.height = window.innerHeight - 90;
    secondaryCanvas.width  = window.innerWidth;
    secondaryCanvas.height = window.innerHeight - 90;
}

function preloadImages(obj) {
    if (!imageList[obj.img]) {
      imageList[obj.img] = {};
    }
    if (!imageList[obj.img][obj.scale]) {
      imageList[obj.img][obj.scale] = new Image();
      imageList[obj.img][obj.scale].addEventListener("load", function() { imageLoaded(imageList[obj.img][obj.scale],obj.scale); });
      imageList[obj.img][obj.scale].src = 'images/' + obj.img;
    }
    return imageList[obj.img][obj.scale];
}

function imageLoaded(img,scale) {
  img.srcHeight = img.height;
  img.srcWidth = img.width;
  img.width = img.srcWidth * scale;
  img.height = img.srcHeight * scale;
}

function drawBoard() {
  ctx.translate(canvas.width/2,canvas.height/2);
  ctx.fillStyle="black";
  ctx.fillRect(-canvas.width,-canvas.height,2*canvas.width,2*canvas.height);

  newTime = performance.now();
  diffTime = newTime - updateTime;
  updateTime = newTime;
  drawTimeMod = diffTime / moveTime;
  moveTime = moveTime - diffTime;
  if (drawTimeMod > 1) { drawTimeMod = 1; moveTime = 0; }

  for (var key in json.obj) {
    updateObj(json.obj[key]);
    drawObj(json.obj_is[key]);
  }
  ctx.translate(-canvas.width/2,-canvas.height/2);
  pctx.drawImage(secondaryCanvas,0,0);
  if (json.logs) {
    logs = document.getElementById('logs');
    json.logs.forEach(function(msg) {
      msg = msg + "\n" + logs.innerText;
      logs.innerText = msg.substring(0,1000);
    });
    delete json.logs;
  } 
}

function updateObj(obj) {
  obj2 = json.obj_is[obj.id];
  for (var thing in {x:1,y:1,move_radians:1,ship_radians:1} ) {
    diff = (obj[thing] - obj2[thing]) * drawTimeMod;
    obj2[thing] = obj2[thing] + diff;
  }
}

function drawObj(obj) {
  imageObj=preloadImages(obj);
  ctx.translate(obj.x, obj.y);
  ctx.rotate(obj.ship_radians);
  if (imageObj.srcWidth) {
    width = imageObj.width;
    height = imageObj.height;
    ctx.drawImage(imageObj, -width / 2, -height / 2, width, height);
  } else {
    // just in case there is no image
    ctx.fillStyle="#C00";
    ctx.fillRect(-15,-2,30,3);
    ctx.fillStyle="blue";
    ctx.fillRect(15,-2,5,3);
  }
  ctx.rotate(-obj.ship_radians);

  ctx.fillStyle="blue";
  ctx.fillRect(-25,25,50*obj.shield,3);
  ctx.fillStyle="green";
  ctx.fillRect(-25,29,50*obj.hull,3);
  ctx.fillStyle="red";
  ctx.fillRect(-25,33,50*obj.energy,3);

  ctx.translate(-obj.x, -obj.y);
}

function move() {

  // mimic a request to the server
  json.obj = mock_server();

  newTime = performance.now();
  moveTime = newTime - lastTime;
  lastTime = newTime;

  for (var id in json.obj) {
    obj = json.obj[id];
    for (var thing in {x:1,y:1,ship_radians:1,move_radians:1,scale:1} ) {
      obj[thing] = Number(obj[thing]); // omg NaN sucks
    }
    if (!json.obj_is[id]) {
      json.obj_is[id] = {};
      for (var key in obj) {
        json.obj_is[id][key] = obj[key];
      }
    }
  }
  setTimeout(function(){move()},1000);
}

myVar = setInterval(drawBoard, 20);
move();
