var mock_obj = {
    "0" : { // id = 0 is alway "you"
      "id" : "0", // must match the obj hash key
      "img" : "redship.png",
      "type" : "ship",
      "team" : 0, // useful for friendly fire
// origin_id tells you where the object (usually a projectile) came from
      "scale" : 1,
      "shield" : 0.5,
      "hull" : 0.1,
      "energy" : 1,
      "x" : 0,
      "y" : 0,
      "move_radians" : 0, // direction I am moving
      "obj_radians" : 0, // direction I am facing
      "obj_speed" : 123 // current speed
    },
    "1" : {
      "id" : "1",
      "img" : "greyship.png",
      "type" : "ship",
      "team" : 1,
      "scale" : 1,
      "hull" : 1,
      "shield" : 1,
      "energy" : 1,
      "x" : 100,
      "y" : -100,
      "move_radians" : 0,
      "obj_radians" : 0,
      "obj_speed" : 123
    },
    "3" : {
      "id" : "3",
      "img" : "ship.png",
      "type" : "ship",
      "team" : 1,
      "scale" : 1,
      "hull" : 1,
      "shield" : 1,
      "energy" : 1,
      "x" : 450,
      "y" : 250,
      "move_radians" : 0,
      "obj_radians" : 0,
      "obj_speed" : 123
    },
    "4" : {
      "id" : "4",
      "img" : "blueship.png",
      "type" : "ship",
      "team" : 1,
      "scale" : 1,
      "hull" : 1,
      "shield" : 1,
      "energy" : 1,
      "x" : -50,
      "y" : -10,
      "move_radians" : 0,
      "obj_radians" : 0,
      "obj_speed" : 123
    }
};

function mock_server_long() {
  return {
    "5" : 3,
    "6" : 1,
    "7" : 2,
    "8" : 1.5,
  };
}

mock_cnt=0;
function mock_server() {
  // update the json with the new location
  //
  // currently ignoring obj_speed
  mock_cnt = mock_cnt+1;

  obj = mock_obj[0];
  obj.move_radians = obj.move_radians + Math.PI/15;
  obj.obj_radians = obj.move_radians; // simple

  obj = mock_obj[1];
  obj.move_radians = obj.move_radians + Math.PI/6;
  obj.obj_radians = obj.move_radians; // simple
  obj.x = obj.x + Math.cos(obj.move_radians) * 350;
  obj.y = obj.y + Math.sin(obj.move_radians) * 350;

  obj = mock_obj[2];
if (obj) {
  obj.move_radians = obj.move_radians - Math.PI/6;
  obj.obj_radians = obj.move_radians; // simple
  obj.x = obj.x + Math.cos(obj.move_radians) * 150;
  obj.y = obj.y + Math.sin(obj.move_radians) * 50;
} else if (mock_cnt > 5) {
  obj = {
    "id" : "2",
    "origin_id" : "4", // where the object came from
    "img" : "missile.png",
    "type" : "projectile",
    "team" : 1,
    "scale" : 0.5,
    "x" : mock_obj[4].x - 50,
    "y" : mock_obj[4].y + 50,
    "move_radians" : mock_obj[4].obj_radians,
    "obj_radians" : mock_obj[4].obj_radians,
    "obj_speed" : 123
  };
  mock_obj[2] = obj;
}

  obj = mock_obj[3];
  obj.move_radians = obj.move_radians - Math.PI/9;
  obj.obj_radians = obj.move_radians; // simple
  obj.x = obj.x + Math.cos(obj.move_radians) * 350;
  obj.y = obj.y + Math.sin(obj.move_radians) * 350;

  obj = mock_obj[4];
  obj.move_radians = obj.move_radians - Math.PI/9;
  obj.obj_radians = obj.move_radians - Math.PI/2; // fly sideways
  obj.x = obj.x + Math.cos(obj.move_radians) * 50;
  obj.y = obj.y + Math.sin(obj.move_radians) * 50;

  if (Math.random() > 0.88) {
    json.logs = ['This is a random message '+Math.random(),'Message 2'];
  }
  return mock_obj;
}
