public interface Organism {
  void run(ArrayList<Boid> boids);
  void applyForce(PVector force);
  void flock(ArrayList<Boid> boids);
  void update();
  PVector seek(PVector target);
  void tail(PVector f);
  void setOrganismColor(color setColor);
  void display();
  void borders();
  PVector separate(ArrayList<Boid> boids);
  PVector align(ArrayList<Boid> boids);
  PVector cohesion(ArrayList<Boid> boids);
}