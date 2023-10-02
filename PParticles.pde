class Particle extends FBox{
  int lifeTime = 200;
  
  Particle(PVector l, color c) {
    super(10, 10);
    setSensor(true);
    setVelocity(random(-45, 45), random(-500, -100));
    setFillColor(c);
    setPosition(l.x, l.y);
    world.add(this);
  }
  
  void Update() {
    lifeTime-=1;
    if (lifeTime <= 0) {
      world.remove(this);
    }
  }
}
