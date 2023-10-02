// A class to describe a group of Particles
// An ArrayList is used to manage the list of Particles 

class PParticleEmitter {
  ArrayList<Particle> particles;
  PVector origin;
  color pc;

  PParticleEmitter(PVector position, color _pc) {
    pc = _pc;
    origin = position.copy();
    particles = new ArrayList<Particle>();
  }

  void addParticle() {
    particles.add(new Particle(origin, pc));
  }

  void run() {
    for (int i = particles.size()-1; i >= 0; i--) {
      Particle p = particles.get(i);
      p.Update();
    }
  }
}
