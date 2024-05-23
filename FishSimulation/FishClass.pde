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
  }

  void applyForce(PVector force) {
    acceleration.add(force);
  }

  void display() {
    stroke(0);
    fill(175);
    pushMatrix();
    translate(position.x, position.y, position.z);
    sphere(8);
    popMatrix();
  }
}
