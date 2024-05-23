class TopViewCamera {
  void setView() {
    // Configuración de la cámara para la vista ortográfica superior
    float camX = width / 2.0;
    float camY = -500;  // Eleva la cámara para una vista superior
    float camZ = height / 2.0;

    float centerX = width / 2.0;
    float centerY = 0;
    float centerZ = height / 2.0;

    float upX = 0;
    float upY = 0;
    float upZ = -1;  // Invertir el eje Z para mirar hacia abajo

    camera(camX, camY, camZ, centerX, centerY, centerZ, upX, upY, upZ);
    ortho(-width / 2, width / 2, -height / 2, height / 2, -1000, 1000);
  }
}
