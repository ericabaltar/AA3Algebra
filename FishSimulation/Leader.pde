class LeaderFish {
  PVector position;
  PVector velocity;
  PVector acceleration;
  PVector destination;
  BezierCurve bezierTrajectory;
  InterpolationCurve interpolationTrajectory;
  PVector[] controlPoints;
  float t;
  float tIncrement;
  boolean useBezier;
  float maxSpeed;

  LeaderFish(PVector[] controlPoints, int numPoints, boolean useBezier, PVector destination, float maxSpeed) {
    this.position = new PVector(0, 0, 0);
    this.velocity = new PVector(0, 0, 0);
    this.acceleration = new PVector(0, 0, 0);
    this.controlPoints = controlPoints;
    this.bezierTrajectory = new BezierCurve(controlPoints, numPoints);
    this.interpolationTrajectory = new InterpolationCurve(controlPoints, numPoints);
    this.t = 0;
    this.tIncrement = 1.0 / numPoints;
    this.useBezier = useBezier;
    this.destination = destination;
    this.maxSpeed = maxSpeed;  // Establecer la velocidad máxima
  }

  void applyForce(PVector force) {
    acceleration.add(force);
  }

  void update() {
    controlPoints[3] = destination; // Actualizar el punto final de la curva al destino
    if (useBezier) {
      bezierTrajectory.calculateCoefs();
    } else {
      interpolationTrajectory.calculateCoefs();
    }

    if (t > 1) {
      t = 1;  // Detener la curva al final
    }
    PVector curvePosition;
    if (useBezier) {
      curvePosition = bezierTrajectory.calculatePoint(t);
    } else {
      curvePosition = interpolationTrajectory.calculatePoint(t);
    }

    // Dirigir el líder hacia el destino
    PVector desired = PVector.sub(destination, position);
    float d = desired.mag();
    desired.setMag(maxSpeed);  // Ajustar la velocidad máxima
    PVector steer = PVector.sub(desired, velocity);
    steer.limit(0.1);
    applyForce(steer);

    velocity.add(acceleration);
    position.add(velocity);
    acceleration.mult(0);

    // Mantener el líder en la curva pero moviéndose hacia el destino
    if (d > 10) {  // Solo mover a lo largo de la curva si no estamos cerca del destino
      t += tIncrement;
      position.lerp(curvePosition, 0.05);
    }
  }

  void display() {
    stroke(255, 0, 0);
    fill(255, 215, 0);
    pushMatrix();
    translate(position.x, position.y, position.z);
    sphere(15);
    popMatrix();
  }
}
