class Obstacle {
  PVector position;
  float size;

  Obstacle(PVector position, float size) {
    this.position = position;
    this.size = size;
  }

  void display() {
    pushMatrix();
    translate(position.x, position.y, position.z);
    fill(150);
    noStroke();
    box(size);
    popMatrix();
  }
}
