import fisica.*;
import processing.net.*;
import processing.sound.*;
import controlP5.*;



SoundFile music, coinSound;
Sound sound;
int psc = 0;

ControlP5 cp5;
Server s;
Client c;
String input;
float data[];

boolean isRunning, play = false;

FWorld world;

color white = #FFFFFF;
color black = #000000;
color cyan = #75daec;
color middleGreen = #00FF00;
color green = #87e700;
color pink = #ffa4b3  ;
color red = #ff151f;
color blue = #386df7;
color orange = #ff8100;
color brown = #996633;
color sky = #17acd1;

PImage dirt, ice, stone, tree, flower, bad, treeTrunk, energy, jump, sklon1, sklon2, coin, spike, trans, conc1, conc2, conc3, brick;
int gridSize = 32;
float zoom = 1.5;
boolean upkey, downkey, leftkey, rightkey, wkey, akey, skey, dkey, qkey, ekey, spacekey;
boolean fileLoaded = false;
boolean sp = false;
boolean waiting = true;
String filePath = "";
String settingsPath = System.getenv("APPDATA") + "/Puzhius/settings.txt";
FPlayer player;
FBox player2;
Enemy[] enemies = new Enemy[10];
FBox[] coins = new FBox[500];
FBox[] bricks = new FBox[500];
PParticleEmitter[] brickParticleSystem = new PParticleEmitter[500];
int cc = 0;
FBox[] boxes = new FBox[10];
PButton[] buttons = new PButton[10];
boolean otherGrab = false;

Menu menu;

String dirtTile = "0";
String grassTile = "1";
String energyTile = "2";
String flowerTile = "3";
String iceTile = "4";
String jumpPlatformTile = "5";
String treeTile = "6";
String enemyTile = "7";
String sklon1Tile = "8";
String sklon2Tile = "9";
String coinTile = "10";
String concreteTile = "11";
String transTile = "12";
String PBoxTile = "13";
String PButtonTile = "14";
String BrickTile = "15";
String SpikeTile = "16";

String airTile = "-1";


String[] lines = new String[4];
String[] linesToSave = new String[4];

int cs, score = 0;
String ip = "";


void setup() {
  sound = new Sound(this);
  coinSound = new SoundFile(this, "data/coin.mp3");
  size(1000, 1000);
  textSize(128);

  surface.setFrameRate(60);


  text("Loading...", height/2, width/2);

  smooth(8);

  menu = new Menu();
  cp5 = new ControlP5(this);

  menu.init(cp5);




  try {
    lines = loadStrings(settingsPath);

    cs = int(lines[0]);

    ip = lines[1];

    filePath = lines[2];

    menu.setVolume(float(lines[3]));
  }
  catch(Exception e) {
    saveConfig();
  }



  menu.setIpAddress(ip);
  menu.setMap(filePath);


  Fisica.init(this);

  dirt = loadImage("data/dirt.png");
  stone = loadImage("data/grass.png");
  ice = loadImage("data/ice.png");
  tree = loadImage("data/tree.png");
  flower = loadImage("data/flower.png");
  bad = loadImage("data/enemy.png");
  energy = loadImage("data/energy.png");
  jump = loadImage("data/JumpPlatform.png");
  sklon1 = loadImage("data/sklon1.png");
  sklon2 = loadImage("data/sklon2.png");
  trans = loadImage("data/trans.png");
  coin = loadImage("data/coin.png");
  brick = loadImage("data/brick.png");
  spike = loadImage("data/spike.png");

  conc1 = loadImage("data/conc1.png");
  conc2 = loadImage("data/conc2.png");
  conc3 = loadImage("data/conc3.png");
}

void loadWorld(String filePath) {
  int x = 0;
  int y = 0;

  String[] file = loadStrings(filePath);
  String[] idS = split(file[0], ",");

  for (int w = 0; w < idS.length; w++) {
    x++;
  }

  for (int h = 0; h < file.length; h++) {
    y++;
  }



  println("X: " + str(x*gridSize) + ", Y: ", str(y*gridSize));
  x = 0;
  y = 0;
  world = new FWorld(0, 0, 2000, 2000);
  world.setGravity(0, 900);
  world.setGrabbable(false);

  cc = 0;
  int bc = 0;
  int bbc = 0;
  int ec = 0;

  for (y = 0; y < file.length; y++) {
    idS = split(file[y], ",");
    for (x = 0; x < idS.length; x++) {
      String block = idS[x];

      if (!block.equals(airTile)) {
        FBox b = new FBox(gridSize, gridSize);
        b.setPosition(x*gridSize, y*gridSize);
        b.setStatic(true);

        if (block.equals(grassTile)) {
          b.attachImage(stone);
          b.setFriction(4);
          b.setName("Jump");
          world.add(b);
        }
        if (block.equals(iceTile)) {
          b.attachImage(ice);
          b.setFriction(0);
          b.setName("Jump");
          world.add(b);
        }
        if (block.equals(treeTile)) {
          b.attachImage(tree);
          b.setSensor(true);
          b.setName("Sensor");
          world.add(b);
        }
        if (block.equals(flowerTile)) {
          b.attachImage(flower);
          b.setSensor(true);
          b.setName("Sensor");
          world.add(b);
        }
        if (block.equals(enemyTile)) {
          enemies[ec] = new Enemy();
          enemies[ec].setPosition(x*gridSize, y*gridSize);
          if (cs == 1) enemies[ec].setStatic(true);
          world.add(enemies[ec]);
          ec++;
        }
        if (block.equals(energyTile)) {
          b.attachImage(energy);
          b.setSensor(true);
          b.setName("Jump");
          world.add(b);
        }
        if (block.equals(jumpPlatformTile)) {
          b.attachImage(jump);
          b.setFriction(4);
          b.setName("JumpPlatform");
          world.add(b);
        }
        if (block.equals(dirtTile)) {
          b.attachImage(dirt);
          b.setFriction(4);
          b.setName("Jump");
          world.add(b);
        }
        if (block.equals(sklon1Tile)) {
          b.attachImage(sklon1);
          b.setSensor(true);
          b.setName("?");

          FBox c1 = new FBox(gridSize, gridSize);
          c1.setPosition(x*gridSize-12, y*gridSize+8);
          c1.setStatic(true);
          c1.attachImage(trans);
          c1.setFriction(0);
          c1.setName("Jump");
          c1.setRotation(62);



          world.add(b);
          world.add(c1);
        }
        if (block.equals(sklon2Tile)) {
          b.attachImage(sklon2);
          b.setSensor(true);
          b.setName("?");

          FBox c1 = new FBox(gridSize, gridSize);
          c1.setPosition(x*gridSize+12, y*gridSize+8);
          c1.setStatic(true);
          c1.attachImage(trans);
          c1.setFriction(0);
          c1.setName("Jump");
          c1.setRotation(-62);



          world.add(b);
          world.add(c1);
        }
        if (block.equals(coinTile)) {
          coins[cc] = new FBox(gridSize, gridSize);
          coins[cc].attachImage(coin);
          coins[cc].setPosition(x*gridSize, y*gridSize);
          coins[cc].setSensor(true);
          coins[cc].setStatic(true);
          coins[cc].setName("coin");
          world.add(coins[cc]);

          cc++;
        }
        if (block.equals(concreteTile)) {
          int puzha = int(random(0, 2));

          if (puzha == 0) {
            b.attachImage(conc1);
            b.setFriction(4);
            b.setName("Jump");
            world.add(b);
          } else if (puzha == 1) {
            b.attachImage(conc2);
            b.setFriction(4);
            b.setName("Jump");
            world.add(b);
          } else if (puzha == 2) {
            b.attachImage(conc3);
            b.setFriction(4);
            b.setName("Jump");
            world.add(b);
          }
        }
        if (block.equals(transTile)) {
          b.attachImage(trans);
          b.setFriction(0);
          b.setName("Trans");
          world.add(b);
        }
        if (block.equals(PBoxTile)) {
          println(bbc);
          boxes[bbc] = new FBox(gridSize, gridSize);
          boxes[bbc].setPosition(x*gridSize, y*gridSize);
          boxes[bbc].setStatic(false);
          boxes[bbc].setFillColor(green);
          boxes[bbc].setName("Grab");
          world.add(boxes[bbc]);
          if (bbc != 9) {
            bbc++;
          }
        }
        if (block.equals(PButtonTile)) {
          b = new FBox(gridSize, gridSize*3);
          b.setStatic(true);
          b.setName("Jump");
          b.setPosition(x*gridSize+3*gridSize, y*gridSize-32);

          buttons[bc] = new PButton(b);
          buttons[bc].setPosition(x*gridSize, y*gridSize);
          buttons[bc].init();
          world.add(buttons[bc]);

          bc++;
        }
        if (block.equals(BrickTile)) {
          FBox c1 = new FBox(gridSize, gridSize/2);
          c1.setPosition(x*gridSize, y*gridSize+gridSize/2);
          c1.setSensor(true);
          c1.setStatic(true);
          c1.attachImage(trans);
          c1.setName("brick");

          b.attachImage(brick);
          b.setPosition(x*gridSize, y*gridSize);
          b.setStatic(true);
          b.setName("Jump");

          c1.setParent(b);

          world.add(b);
          world.add(c1);
        }
        if (block.equals(SpikeTile)) {
          b.attachImage(spike);
          b.setName("enemy");
          world.add(b);
        }
      }
    }
  }


  player2 = new FBox(gridSize, gridSize);
  player2.setFillColor(blue);
  world.add(player2);
  player2.setName("Player");
  loadPlayer();
  thread("playMusic");
  play = true;
}
void loadPlayer() {
  player = new FPlayer();
  world.add(player);
}

void checkCoinP2() {
  Object[] contacts = player2.getContacts().toArray();

  for (Object obj : contacts) {
    if (obj instanceof fisica.FContact) {
      fisica.FContact contact = (fisica.FContact) obj;

      fisica.FBody bodyA = contact.getBody1();

      String name = bodyA.getName();

      if (name == "coin") {
        world.remove(bodyA);
        score++;
      }
      try {
        if (name.equals("brick")) {
          brickParticleSystem[psc] = new PParticleEmitter(new PVector(bodyA.getX(), bodyA.getY()), brown);

          brickParticleSystem[psc].addParticle();
          brickParticleSystem[psc].addParticle();
          brickParticleSystem[psc].addParticle();
          brickParticleSystem[psc].addParticle();
          brickParticleSystem[psc].addParticle();
          brickParticleSystem[psc].addParticle();
          brickParticleSystem[psc].addParticle();
          brickParticleSystem[psc].addParticle();

          world.remove(bodyA.getParent());
          world.remove(bodyA);

          psc++;
        }
      }
      catch (Exception e) {
      }
    }
  }
}

void draw() {
  if (play == true)
  {
    if (waiting) {
      background(black);
      text("Waiting...", width/2, height/2);
    } else {

      for (PButton butt : buttons) {
        if (butt != null) {
          butt.act();
        }
      }

      for (Enemy e : enemies) {
        if (e != null) {
          if (cs == 2) {
            e.act(player, player2);
          }
        }
      }



      background(pink);
      textAlign(LEFT);
      text("Coins: " + score/2, 50, height/10);
      drawWorld();
      player.act();
      checkCoinP2();
      for (PParticleEmitter ps : brickParticleSystem) {
        if (ps != null && ps.origin != null) {
          ps.run();
        }
      }
    }

    if (!sp) {
      player2.setVelocity(0, 0);
      if (cs == 2) {

        // Data To Send Generation
        String dataToSend = "";

        dataToSend+=(player.getX() + " " + player.getY()); // Player
        

        for (FBox b : boxes) {
          if (b != null) {
            dataToSend+=(" " + b.getX() + " " + b.getY());
          }
        }

        for (Enemy e : enemies) {
          if (e != null) {
            dataToSend+=(" " + e.getX() + " " + e.getY());
          }
        }

        dataToSend+="\n";

        s.write(dataToSend);

        // Client
        c = s.available();
        if (c != null) {
          input = c.readString();
          println(input);
          String inputSplit[] = input.split("\n");


          if (waiting) {
            waiting = false;
          } else {
            data = float(split(inputSplit[0], ' '));  // Split values into an array
            try {
              player2.setPosition(data[0], data[1]);
            }
            catch(Exception e) {
            }
          }
        }
      } else { // For client
        c.write(player.getX() + " " + player.getY() + "\n"); // Send Position To Another Player

        if (c.available() > 0) {
          input = c.readString();
          if (input == "grab\n") {
          } else {
            String inputSplit[] = input.split("\n");  // Only up to the newline

            data = float(split(inputSplit[0], ' '));  // Split values into an array
            

            player2.setPosition(data[0], data[1]);



            int bcount = 2;
            for (FBox b : boxes) {
              if (b != null) {
                b.setPosition(data[bcount], data[bcount+1]);
                bcount+= 2;
              }
            }
            for (Enemy e : enemies) {
              if (e != null) {
                e.setPosition(data[bcount], data[bcount+1]);
                bcount+=2;
              }
            }
          }
        }
      }
    }
  } else {
    menu.act();
    if (menu.getServerBtn()) {
      cs = 2;
      play();
    }
    if (menu.getClientBtn()) {
      cs = 1;
      play();
    }
    if (menu.getSP()) {
      cs = 2;
      sp = true;
      play();
    }
  }
}


void drawWorld() {
  pushMatrix();
  translate(-player.getX()*zoom+width/2, -player.getY()*zoom+height/2);
  scale(zoom);
  world.step();
  world.draw();
  popMatrix();
}

void play() {
  menu.destroy();
  background(black);
  text("Puzhius Loading", width/2, height/2);
  ip = menu.getIpAddress();
  filePath = menu.getMap();
  if (!sp) {
    if (cs == 2) {
      s = new Server(this, 5060);
    } else {
      c = new Client(this, ip, 5060);
      c.write("join" + "\n");
      waiting = false;
    }
  } else {
    waiting = false;
  }

  sound.volume(menu.getVolume());

  saveConfig();
  loadWorld(filePath);
}


void saveConfig() {
  linesToSave[0] = str(cs);
  linesToSave[1] = ip;
  linesToSave[2] = filePath;
  linesToSave[3] = str(menu.getVolume());

  saveStrings(settingsPath, linesToSave);
}

void playMusic() {
  music = new SoundFile(this, "data/music.mp3");
  while (true) {
    delay(10000);
    if (!music.isPlaying() && waiting == false) {
      music.play();
    }
  }
}
