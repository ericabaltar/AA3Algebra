class InterpolationCurve {
  PVector[] controlPoints;
  int numPoints;
  PVector[] coefs;

  InterpolationCurve(PVector[] controlPoints, int numPoints) {
    this.controlPoints = controlPoints;
    this.numPoints = numPoints;
    coefs = new PVector[4];
    for (int i = 0; i < 4; i++) {
      coefs[i] = new PVector(0.0, 0.0);
    }
    calculateCoefs();
  }

  void calculateCoefs() {
    coefs[0].x = controlPoints[0].x;
    coefs[0].y = controlPoints[0].y;
    coefs[1].x = -5.5 * controlPoints[0].x + 9 * controlPoints[1].x - 4.5 * controlPoints[2].x + controlPoints[3].x;
    coefs[1].y = -5.5 * controlPoints[0].y + 9 * controlPoints[1].y - 4.5 * controlPoints[2].y + controlPoints[3].y;
    coefs[2].x = 9 * controlPoints[0].x - 22.5 * controlPoints[1].x + 18 * controlPoints[2].x - 4.5 * controlPoints[3].x;
    coefs[2].y = 9 * controlPoints[0].y - 22.5 * controlPoints[1].y + 18 * controlPoints[2].y - 4.5 * controlPoints[3].y;
    coefs[3].x = -4.5 * controlPoints[0].x + 13.5 * controlPoints[1].x - 13.5 * controlPoints[2].x + 4.5 * controlPoints[3].x;
    coefs[3].y = -4.5 * controlPoints[0].y + 13.5 * controlPoints[1].y - 13.5 * controlPoints[2].y + 4.5 * controlPoints[3].y;
  }

  PVector calculatePoint(float t) {
    PVector point = new PVector(0, 0);
    point.x = coefs[0].x + coefs[1].x * t + coefs[2].x * t * t + coefs[3].x * t * t * t;
    point.y = coefs[0].y + coefs[1].y * t + coefs[2].y * t * t + coefs[3].y * t * t * t;
    return point;
  }
}
