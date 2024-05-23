class IsometricCamera {
  void setView() {
    float camX = width / 2.0;
    float camY = height / 2.0;
    float camZ = (height / 2.0) / tan(PI / 6);

    float centerX = width / 2.0;
    float centerY = height / 2.0;
    float centerZ = 0;

    float upX = 0;
    float upY = 1;
    float upZ = 0;

    camera(camX, camY, camZ, centerX, centerY, centerZ, upX, upY, upZ);
    ortho(-width / 2, width / 2, -height / 2, height / 2, -1000, 1000);
  }
}
