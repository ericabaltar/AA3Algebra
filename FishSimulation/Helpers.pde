PVector seek(FishClass f, PVector target) {
  PVector desired = PVector.sub(target, f.position);
  desired.setMag(2);
  PVector steer = PVector.sub(desired, f.velocity);
  steer.limit(0.1);
  return steer;
}

PVector avoidCrowdedAreas(FishClass f) {
  PVector steer = new PVector(0, 0, 0);
  int count = 0;
  for (FishClass other : fishSchool) {
    float d = PVector.dist(f.position, other.position);
    if ((d > 0) && (d < 50)) {
      PVector diff = PVector.sub(f.position, other.position);
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
    steer.sub(f.velocity);
    steer.limit(0.1);
  }
  return steer;
}
