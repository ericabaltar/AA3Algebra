class FishClass {
  PVector position;
  PVector velocity;
  PVector acceleration;

  FishClass(PVector position) {
    this.position = position;
    this.velocity = PVector.random3D();
    this.acceleration = new PVector(0, 0, 0);
  }

  void update() {
    velocity.add(acceleration);
    position.add(velocity);
    acceleration.mult(0);
    
    // Limitar la velocidad máxima
    velocity.limit(2);

    // Mantener el pez dentro del acuario
    if (position.x > width) position.x = 0;
    if (position.x < 0) position.x = width;
    if (position.y > height) position.y = 0;
    if (position.y < 0) position.y = height;
    if (position.z > 200) position.z = -200;
    if (position.z < -200) position.z = 200;
  }

  void applyForce(PVector force) {
    acceleration.add(force);
  }

  PVector separate(ArrayList<FishClass> fishes) {
    float desiredSeparation = 50;
    PVector steer = new PVector(0, 0, 0);
    int count = 0;
    for (FishClass other : fishes) {
      float d = PVector.dist(position, other.position);
      if ((d > 0) && (d < desiredSeparation)) {
        PVector diff = PVector.sub(position, other.position);
        diff.normalize();
        diff.div(d);
        steer.add(diff);
        count++;
      }
    }
    if (count > 0) {
      steer.div((float) count);
    }
    if (steer.mag() > 0) {
      steer.setMag(2);
      steer.sub(velocity);
      steer.limit(0.1);
    }
    return steer;
  }

  PVector avoid(ArrayList<Obstacle> obstacles) {
    float desiredSeparation = 50;
    PVector steer = new PVector(0, 0, 0);
    int count = 0;
    for (Obstacle obstacle : obstacles) {
      float d = PVector.dist(position, obstacle.position);
      if (d < (desiredSeparation + obstacle.size / 2)) {
        PVector diff = PVector.sub(position, obstacle.position);
        diff.normalize();
        diff.div(d);
        steer.add(diff);
        count++;
      }
    }
    if (count > 0) {
      steer.div((float) count);
    }
    if (steer.mag() > 0) {
      steer.setMag(2);
      steer.sub(velocity);
      steer.limit(0.1);
    }
    return steer;
  }

  PVector seek(PVector target) {
    PVector desired = PVector.sub(target, position);
    desired.setMag(2);
    PVector steer = PVector.sub(desired, velocity);
    steer.limit(0.1);
    return steer;
  }

  void display() {
    stroke(0);
    fill(255, 215, 0);
    pushMatrix();
    translate(position.x, position.y, position.z);
    sphere(10);
    popMatrix();
  }
}
