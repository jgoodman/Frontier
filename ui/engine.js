var canvas = document.getElementById('myCanvas');
var pctx = canvas.getContext('2d');
var secondaryCanvas = document.createElement("canvas");
secondaryCanvas.width = canvas.width;
secondaryCanvas.height = canvas.height;
var ctx = secondaryCanvas.getContext('2d');

var longRange = 2000;
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
    if (!imageList[obj.image]) {
      imageList[obj.image] = {};
    }
    if (!imageList[obj.image][obj.image_scale]) {
      imageList[obj.image][obj.image_scale] = new Image();
      imageList[obj.image][obj.image_scale].addEventListener("load", function() { imageLoaded(imageList[obj.image][obj.image_scale],obj.image_scale); });
      imageList[obj.image][obj.image_scale].src = 'images/' + obj.image;
    }
    return imageList[obj.image][obj.image_scale];
}

function imageLoaded(image,image_scale) {
  image.srcHeight = image.height;
  image.srcWidth = image.width;
  image.width = image.srcWidth * image_scale;
  image.height = image.srcHeight * image_scale;
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
  updateLongRange();
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
  if (obj.shield === null) { return }
  obj2 = json.obj_is[obj.object_id];
  for (var thing in {x:1,y:1,move_radians:1,object_radians:1} ) {
    diff = (obj[thing] - obj2[thing]) * drawTimeMod;
    obj2[thing] = obj2[thing] + diff;
  }
}

function updateLongRange() {
      ctx.beginPath();
      ctx.arc(70, 70, 50, 0, 2 * Math.PI, false);
      ctx.fillStyle = '#222';
      ctx.fill();
      ctx.translate(70,70);

scanRadius = 44;

longScale = scanRadius / longRange;

      ctx.fillStyle = 'red';
      for (var key in json.obj) {
        if (json.obj[key].shield === null) {
          ctx.rotate(-json.obj[key].object_direction);
          ctx.fillRect(scanRadius,0,2,2);
          ctx.rotate(json.obj[key].object_direction);
        } else {
  	  ctx.fillRect(json.obj[key]['x'] * longScale ,json.obj[key]['y'] * -longScale ,2,2);
        }
      }

      ctx.translate(-70,-70);
      ctx.arc(70, 70, 50, 0, 2 * Math.PI, false);
      ctx.lineWidth = 5;
      ctx.strokeStyle = '#333';
      ctx.stroke();
}

function drawObj(obj) {
  if (obj.shield === null) { return }
  imageObj=preloadImages(obj);
  ctx.translate(obj.x, -obj.y);
  ctx.rotate(-obj.object_radians);
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
  ctx.rotate(obj.object_radians);

  ctx.fillStyle="blue";
  ctx.fillRect(-25,25,obj.shield / 2,3);
  ctx.fillStyle="green";
  ctx.fillRect(-25,29,obj.hull / 2,3);
  ctx.fillStyle="red";
  ctx.fillRect(-25,33,obj.energy / 2,3);

  ctx.translate(-obj.x, obj.y);
}

function getScan() {
    var xmlhttp = new XMLHttpRequest();
    var url = "http://192.168.174.129:50443/frontier/ship_scan/testing";

    xmlhttp.onreadystatechange = function() {
        if (xmlhttp.readyState == 4 && xmlhttp.status == 200) {
            var myArr = JSON.parse(xmlhttp.responseText);
            move(myArr);
        }
    }
    xmlhttp.open("POST", url, true);
    xmlhttp.setRequestHeader("Content-type","application/x-www-form-urlencoded");
    xmlhttp.send('ship_id=1&ship_pass=ship123');
}

function move(myjson) {
  json.obj = myjson.obj;
  longRange = myjson.long_range;

  newTime = performance.now();
  moveTime = newTime - lastTime;
  lastTime = newTime;

  for (var id in json.obj) {
    obj = json.obj[id];
    if (!json.obj_is[id]) {
      json.obj_is[id] = {};
      for (var key in obj) {
        json.obj_is[id][key] = obj[key];
      }
      if (obj.origin_id) {
        json.obj_is[id]['x'] = json.obj_is[obj.origin_id]['x'];
        json.obj_is[id]['y'] = json.obj_is[obj.origin_id]['y'];
      }
    }
    json.obj_is[id].image = json.obj[id].image; // make sure we get image updates
  }
  setTimeout(function(){getScan()},1000);
}

myVar = setInterval(drawBoard, 20);
getScan();
