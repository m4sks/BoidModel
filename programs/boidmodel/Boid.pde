Boid boid;
class Boid implements Organism {
  PVector position;
  PVector velocity;
  PVector force;
  PVector acceleration;
  
  float x, y;
  float weight, size, maxForce, maxSpeed;
  float tailSpeed, tailRad;
  color organismColor;
  
  Boid (float weight, float size, float xpos, float ypos) {
    Initialize(weight, size, xpos, ypos);
    setOrganismColor(color(0));
    maxSpeed = 3;
    maxForce = 0.03;
  }
  
  void Initialize(float weight, float size, float xpos, float ypos) {
    this.weight = weight;
    this.size = size;
    this.position = new PVector(xpos, ypos);
    this.velocity = PVector.random2D();
    this.force = new PVector(0, 0);
    this.acceleration = new PVector(0, 0);
    this.tailSpeed = 0;
    this.tailRad = 0;
  }
  
  void run(ArrayList<Boid> boids) {
    flock(boids);
    update();
    borders();
    display();
  }
  
  void update() {
    acceleration = force.div(weight);
    velocity.add(acceleration);
    //velocity.limit(maxSpeed);
    position.add(velocity);
    force.mult(0);
    acceleration.mult(0);
    tail(velocity);
  }
  
  void flock(ArrayList<Boid> boids) {
    PVector sep = separate(boids);   // Separation
    PVector ali = align(boids);      // Alignment
    PVector coh = cohesion(boids);   // Cohesion
    
    PVector res = resistance(); //resistance
    
    sep.mult(1.5);
    ali.mult(1.0);
    coh.mult(1.0);
    res.mult(0.01);
    
    applyForce(sep);
    applyForce(ali);
    applyForce(coh);
    applyForce(res);
  }
  
  void applyForce(PVector f) {
    force.add(f);
  }
  
  // Separation
  PVector separate (ArrayList<Boid> boids) {
    float desiredseparation = 25.0f;
    PVector steer = new PVector(0, 0, 0);
    int count = 0;
    for (Boid other : boids) {
      float d = PVector.dist(position, other.position);
      if ((d > 0) && (d < desiredseparation)) {
        PVector diff = PVector.sub(position, other.position);
        diff.normalize();
        diff.div(d);
        steer.add(diff);
        count++;
      }
    }
    if (count > 0) {
      steer.div((float)count);
    }
    if (steer.mag() > 0) {
      steer.normalize();
      steer.mult(maxSpeed);
      steer.sub(velocity);
      steer.limit(maxForce);
    }
    return steer;
  }

  // Alignment
  PVector align (ArrayList<Boid> boids) {
    float neighbordist = 50;
    PVector sum = new PVector(0, 0);
    int count = 0;
    for (Boid other : boids) {
      float d = PVector.dist(position, other.position);
      if ((d > 0) && (d < neighbordist)) {
        sum.add(other.velocity);
        count++;
      }
    }
    if (count > 0) {
      sum.div((float)count);
      sum.normalize();
      sum.mult(maxSpeed);
      PVector steer = PVector.sub(sum, velocity);
      steer.limit(maxForce);
      return steer;
    } 
    else {
      return new PVector(0, 0);
    }
  }

  // Cohesion
  PVector cohesion (ArrayList<Boid> boids) {
    float neighbordist = 50;
    PVector sum = new PVector(0, 0);
    int count = 0;
    for (Boid other : boids) {
      float d = PVector.dist(position, other.position);
      if ((d > 0) && (d < neighbordist)) {
        sum.add(other.position);
        count++;
      }
    }
    if (count > 0) {
      sum.div(count);
      return seek(sum);
    } 
    else {
      return new PVector(0, 0);
    }
  }
  
  PVector seek(PVector target) {
    PVector desired = PVector.sub(target, position);
    
    desired.normalize();
    desired.mult(maxSpeed);
    
    desired.setMag(maxSpeed);

    // Steering = Desired minus Velocity
    PVector steer = PVector.sub(desired, velocity);
    steer.limit(maxForce);
    return steer;
  }
  
  PVector resistance () {
    PVector velocityTemp = new PVector();
    velocityTemp = velocity.copy();
    velocityTemp.mult(-1);
    return velocityTemp;
  }
  
  void tail(PVector f){
    tailSpeed = f.mag()*5;
    tailRad += tailSpeed;
    if (tailRad > 100 || tailRad < -100) {
      tailSpeed *= -1;
    }
  }
  
  void setOrganismColor(color setColor) {
    organismColor = setColor;
  }
  
  void display(){
    float theta = velocity.heading() + PI/2;
    noStroke();
    fill(organismColor);
    pushMatrix();
    translate(position.x, position.y);
    rotate(theta);
    beginShape();
    vertex(0, -size*1);
    bezierVertex(size*1.1/3, size*(-0.9)/2, size*1.1/2, size*0.1/2, size*1/3, size*0.5/3);
    bezierVertex(size*0.8/2, size*1.3*0.7, 0, size*1.4/3, 0 + size*sin(radians(tailRad))*0.3, size*2.0*0.8 + size*abs(cos(radians(tailRad)))*0.3);
    bezierVertex(0, size*1.4, size*(-0.8)/2, size*1.3/2, size*(-1)/3, size*0.5/2);
    bezierVertex(size*(-1.1)/2, size*0.1/2*5, size*(-1.1)/3, size*(-0.9)/4*6, 0, -size*1);
    endShape();
    popMatrix();
  }
  
  // Wraparound
  void borders() {
    if (position.x < -size) position.x = width + size;
    if (position.y < -size) position.y = height + size;
    if (position.x > width + size) position.x = -size;
    if (position.y > height + size) position.y = -size;
  }
  
}