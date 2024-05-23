ArrayList<FishClass> fishSchool;
PVector destination;
boolean applyFriction = true;
boolean applyWind = true;
boolean isometricView = false;
PVector[] obstacles = {new PVector(200, 200, 0), new PVector(600, 200, 0), new PVector(200, 600, 0), new PVector(600, 600, 0)};
Leader leader;
IsometricCamera isoCam;

void setup() {
  size(800, 800, P3D);
  fishSchool = new ArrayList<FishClass>();
  for (int i = 0; i < 20; i++) {
    fishSchool.add(new FishClass(new PVector(random(width), random(height), random(-200, 200))));
  }
  destination = new PVector(width / 2, height / 2, 0);
  leader = new Leader(new PVector(width / 2, height / 2, 0));
  isoCam = new IsometricCamera();
}

void draw() {
  background(255);
  if (isometricView) {
    isoCam.setView();
  } else {
    // Vista de perspectiva para un entorno 3D
    perspective();
    camera(width/2, height/2, (height/2) / tan(PI/6), width/2, height/2, 0, 0, 1, 0);
  }

  PVector wind = new PVector(0.1, 0, 0);
  for (FishClass f : fishSchool) {
    if (applyWind) f.applyForce(wind);
    if (applyFriction) {
      PVector friction = f.velocity.copy();
      friction.mult(-1);
      friction.normalize();
      friction.mult(0.05);
      f.applyForce(friction);
    }
    f.applyForce(seek(f, destination));
    f.applyForce(avoidCrowdedAreas(f));
    f.update();
    f.display();
  }

  leader.applyForce(seek(leader, destination));
  leader.update();
  leader.display();

  // Dibujar obstáculos
  fill(150);
  for (PVector o : obstacles) {
    pushMatrix();
    translate(o.x, o.y, o.z);
    sphere(10);
    popMatrix();
  }
}

void keyPressed() {
  if (key == 'f') applyFriction = !applyFriction;
  if (key == 'w') applyWind = !applyWind;
  if (key == 'v') isometricView = !isometricView;
}
