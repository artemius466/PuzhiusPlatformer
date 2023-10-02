

class Enemy extends FBox {
  Enemy() {
    super(gridSize, gridSize);
    attachImage(bad);
    setName("enemy");
    setStatic(false);
    setPosition(1000, 1000);
  }


  int speed = 150;
  int ovy = -700;
  int radius = 7;



  void act(FPlayer player, FBox player2) {
    if (cs == 2) {
      if (checkContact("JumpPlatform")) {
        setVelocity(getVelocityX(), ovy);
        if (ovy != 0) ovy = ovy + 100;
      } else {
        ovy = -700;
      }
      setRotation(0);
    }
    handleInput(player, player2);
  }

  void handleInput(FPlayer player, FBox player2) {
    float vx = getVelocityX();
    float vy = getVelocityY();
    float r1 = 0f;
    float r2 = 0f;
    float rb = 100000000000f;
    PVector bp = new PVector(0.0f, 0.0f);

    for (FBox box : boxes) {
      if (box != null) {
        float vrb = 0f;
  
        if (box.getX() < getX()) vrb = getX()-box.getX();
        else if (box.getX() > getX()) vrb = box.getX()-getX();

  
        if (vrb < rb) {
          rb = vrb;
          bp.x = box.getX();
          bp.y = box.getY();
        }
      }
    }
    

    int target = 0;

    if (player.getX() < getX()) r1 = getX()-player.getX();
    else if (player.getX() > getX()) r1 = player.getX()-getX();

    if (player2.getX() < getX()) r2 = getX()-player2.getX();
    else if (player2.getX() > getX()) r2 = player2.getX()-getX();
    
    if (rb < radius*32) target = 3;
    if (r1 < r2 && r1 < radius*32) target = 1;
    else if (r1 > r2 && r2 < radius*32 && sp == false) target = 2;

    if (target == 1) {
      if (cs == 2) {
        if (player.getX() < getX()) setVelocity(-speed, vy);
        else if (player.getX() > getX()) setVelocity(speed, vy);
        if (player.getY() < getY()) setVelocity(vx, -speed);
      }
    } else if (target == 2) {
      if (cs == 2) {
        if (player2.getX() < getX()) setVelocity(-speed, vy);
        else if (player2.getX() > getX()) setVelocity(speed, vy);
        if (player2.getY() < getY()) setVelocity(vx, -speed);
      }
    } else if (target == 3) {
      if (cs == 2) {
        if (bp.x < getX()) setVelocity(-speed, vy);
        else if (bp.x > getX()) setVelocity(speed, vy);
        if (bp.y < getY()) setVelocity(vx, -speed);
      }
    } else if (target == 0) {
      if (cs == 2) {
        int movement = int(random(0, 100000));
        int jump = int(random(0, 100));
        
        
        if (movement < 50000) setVelocity(-1000, vy); else setVelocity(1000, vy);
        if (jump <= 5) setVelocity(vx, -speed);
      }
    }
  }

  String[] getContactsNames() {
    Object[] contacts = getContacts().toArray();
    String[] names = new String[100];
    int i = 0;

    for (Object obj : contacts) {
      if (obj instanceof fisica.FContact) {
        fisica.FContact contact = (fisica.FContact) obj;

        fisica.FBody bodyA = contact.getBody1();

        String name = bodyA.getName();

        names[i] = name;
        i++;
      }
    }

    return names;
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
}
