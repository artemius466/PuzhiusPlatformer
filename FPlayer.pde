class FPlayer extends FBox {
  FPlayer() {
    super(gridSize, gridSize);
    setPosition(startx, starty);
    setFillColor(red);
    setName("Player");
  }

  public int speed = 200;
  public int startx = 300;
  public int starty = 100;

  private int ovy = -700;


  void act() {
    if (checkContact("JumpPlatform")) {
      setVelocity(getVelocityX(), ovy);
      if (ovy != 0) ovy = ovy + 100;
    } else if (checkContact("enemy")) {
      setPosition(startx, starty);
    }
    setRotation(0);
    handleInput();
    checkInter();
  }

  int psc = 0;

  String[] getContactsNames() {
    Object[] contacts = getContacts().toArray();
    String[] names = new String[1000];
    int i = 0;

    for (Object obj : contacts) {
      if (obj instanceof fisica.FContact) {
        fisica.FContact contact = (fisica.FContact) obj;

        fisica.FBody bodyA = contact.getBody1();
        fisica.FBody bodyB = contact.getBody2();

        String name = bodyA.getName();

        names[i] = name;
        i++;
        String name1 = bodyB.getName();

        names[i] = name1;
        i++;
      }
    }

    return names;
  }

  void checkInter() {
    Object[] contacts = getContacts().toArray();

    for (Object obj : contacts) {
      if (obj instanceof fisica.FContact) {
        fisica.FContact contact = (fisica.FContact) obj;

        fisica.FBody bodyA = contact.getBody1();
        fisica.FBody bodyB = contact.getBody2();

        String name = bodyA.getName();

        String name1 = bodyB.getName();
        

        if (name == "coin" || name1 == "coin") {
          world.remove(bodyA);
          coinSound.play();
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

            setVelocity(getVelocityX(), 0);

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

  boolean checkContact(String nameToFind) {
    String[] contactNames = getContactsNames();
    for (String name : contactNames) {
      if (name == nameToFind) {
        return true;
      }
    }

    return false;
  }

  void handleInput() {
    float vx = getVelocityX();
    float vy = getVelocityY();
    if (akey || leftkey) setVelocity(-speed, vy);
    if (dkey || rightkey) setVelocity(speed, vy);


    if ((wkey) && (checkContact("Jump")) || upkey && (checkContact("Jump"))) {
      setVelocity(vx, -500);
      ovy = -700;
    }
    if ((wkey) && (checkContact("JumpPlatform")) || upkey && (checkContact("JumpPlatform"))) {
      setVelocity(vx, -2000);
      ovy = -700;
    }
  }

  void setSpeed(int newSpeed) {
    speed = newSpeed;
  }
}
