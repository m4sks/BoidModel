void settings() {
  size(900, 500);
}

void setup() {
  background(116, 169, 214);
  flock = new Flock();
  for (int i = 0; i < 200; i++) {
    //flock.addBoid(new Boid(1.5, 5, random(width), random(height)));
    flock.addBoid(new Boid(1.5, 10, width/2, height/2));
  }
  noCursor();
}

void draw() {
  background(116, 169, 214);
  flock.run();
}