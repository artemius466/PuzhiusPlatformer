void keyPressed() {
  if(key == 'S' || key == 's') skey = true;
  if(key == 'W' || key == 'w') wkey = true;
  if(key == 'A' || key == 'a') akey = true;
  if(key == 'D' || key == 'd') dkey = true;
  if(key == 'Q' || key == 'q') qkey = true;
  if(key == ' ') spacekey = true;
  if(keyCode == DOWN) downkey = true;
  if(keyCode == UP) upkey = true;
  if(keyCode == LEFT) leftkey = true;
  if(keyCode == RIGHT) rightkey = true;
}

void keyTyped() {
  if(key == 'E' || key == 'e') ekey = true;
  if(key == ESC) println("ESCAPE");
}

void keyReleased() {
  if(key == 'S' || key == 's') skey = false;
  if(key == 'W' || key == 'w') wkey = false;
  if(key == 'A' || key == 'a') akey = false;
  if(key == 'D' || key == 'd') dkey = false;
  if(key == 'Q' || key == 'q') qkey = false;
  if(key == ' ') spacekey = false;
  if(keyCode == DOWN) downkey = false;
  if(keyCode == UP) upkey = false;
  if(keyCode == LEFT) leftkey = false;
  if(keyCode == RIGHT) rightkey = false;
}
