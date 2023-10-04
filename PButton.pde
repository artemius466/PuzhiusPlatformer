class PButton extends FBox {
  PButton(FBox doorr) {
    super(gridSize, gridSize);
    setFillColor(red);
    setName("Button");
    door = doorr;
  }

  FBox door;
  
  boolean doorrr = false;  

  void init() {
    setStatic(true);
    setPosition(getX(), getY()+30);
    setFriction(8);
  }

  void act() {
    println(checkContact("Player"));
    if (checkContact("Grab") || checkContact("Player") || checkContact("enemy")) {
      if (doorrr == true) {
        doorrr = false;
        world.remove(door);
      }
    } else {
      if (doorrr == false) {
        doorrr = true;
        world.add(door);
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
