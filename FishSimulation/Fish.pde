class Fish {
  PVector position;
  PVector velocity;
  PVector acceleration;
  float maxSpeed;
  float maxForce;
  float desiredSeparation;
  float neighborDist;

  Fish(PVector position) {
    this.position = position.copy();
    velocity = PVector.random3D();
    acceleration = new PVector();
    maxSpeed = 2;
    maxForce = 0.03;
    desiredSeparation = 50.0;  // Aumentar la distancia deseada de separación entre peces
    neighborDist = 100.0;  // Aumentar la distancia para considerar a otros peces como vecinos
  }

  void applyForce(PVector force) {
    acceleration.add(force);
  }

  void update() {
    velocity.add(acceleration);
    velocity.limit(maxSpeed);
    position.add(velocity);
    acceleration.mult(0);
  }

  void display() {
    stroke(255);
    fill(175);
    pushMatrix();
    translate(position.x, position.y, position.z);
    sphere(10);
    popMatrix();
  }

  PVector separate(ArrayList<Fish> fish) {
    PVector steer = new PVector(0, 0, 0);
    int count = 0;
    for (Fish other : fish) {
      float d = PVector.dist(position, other.position);
      if ((d > 0) && (d < desiredSeparation)) {
        PVector diff = PVector.sub(position, other.position);
        diff.normalize();
        diff.div(d);  // Peso por distancia
        steer.add(diff);
        count++;
      }
    }
    if (count > 0) {
      steer.div((float) count);
    }
    if (steer.mag() > 0) {
      steer.setMag(maxSpeed);
      steer.sub(velocity);
      steer.limit(maxForce);
    }
    return steer;
  }

  PVector align(ArrayList<Fish> fish) {
    PVector sum = new PVector(0, 0, 0);
    int count = 0;
    for (Fish other : fish) {
      float d = PVector.dist(position, other.position);
      if ((d > 0) && (d < neighborDist)) {
        sum.add(other.velocity);
        count++;
      }
    }
    if (count > 0) {
      sum.div((float) count);
      sum.setMag(maxSpeed);
      PVector steer = PVector.sub(sum, velocity);
      steer.limit(maxForce);
      return steer;
    } else {
      return new PVector(0, 0, 0);
    }
  }

  PVector cohesion(ArrayList<Fish> fish) {
    PVector sum = new PVector(0, 0, 0);
    int count = 0;
    for (Fish other : fish) {
      float d = PVector.dist(position, other.position);
      if ((d > 0) && (d < neighborDist)) {
        sum.add(other.position);
        count++;
      }
    }
    if (count > 0) {
      sum.div((float) count);
      return seek(sum);
    } else {
      return new PVector(0, 0, 0);
    }
  }

  PVector seek(PVector target) {
    PVector desired = PVector.sub(target, position);
    desired.setMag(maxSpeed);
    PVector steer = PVector.sub(desired, velocity);
    steer.limit(maxForce);
    return steer;
  }

  void flock(ArrayList<Fish> fish) {
    PVector sep = separate(fish);
    PVector ali = align(fish);
    PVector coh = cohesion(fish);
    sep.mult(2.0);  // Aumentar el peso de la separación
    ali.mult(1.0);  // Mantener el peso de la alineación
    coh.mult(1.0);  // Mantener el peso de la cohesión
    applyForce(sep);
    applyForce(ali);
    applyForce(coh);
  }

  PVector avoid(ArrayList<Obstacle> obstacles) {
    PVector steer = new PVector(0, 0, 0);
    for (Obstacle obstacle : obstacles) {
      float d = PVector.dist(position, obstacle.position);
      if (d < obstacle.size + desiredSeparation) {
        PVector diff = PVector.sub(position, obstacle.position);
        diff.normalize();
        diff.mult(maxSpeed);
        steer.add(diff);
      }
    }
    steer.limit(maxForce);
    return steer;
  }
}
