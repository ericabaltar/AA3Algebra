IsometricCamera isoCam;
TopViewCamera topViewCam;
ArrayList<FishClass> fishSchool;
ArrayList<Obstacle> obstacles;
boolean isometricView = false;
boolean topView = false;
float camX, camY, camZ;
PVector destination;

void setup() {
  size(800, 800, P3D);  // Configura el entorno 3D
  isoCam = new IsometricCamera();
  topViewCam = new TopViewCamera();
  camX = width / 2.0;
  camY = height / 2.0;
  camZ = (height / 2.0) / tan(PI * 30.0 / 180.0);

  // Crear 20 peces
  fishSchool = new ArrayList<FishClass>();
  for (int i = 0; i < 20; i++) {
    fishSchool.add(new FishClass(new PVector(random(width), random(height), random(-200, 200))));
  }

  // Crear obstáculos
  obstacles = new ArrayList<Obstacle>();
  float floorHeight = height - 55; // Posición del suelo
  obstacles.add(new Obstacle(new PVector(width / 3, floorHeight, 0), 50));
  obstacles.add(new Obstacle(new PVector(2 * width / 3, floorHeight, 0), 50));
  obstacles.add(new Obstacle(new PVector(width / 3, floorHeight, -100), 50));
  obstacles.add(new Obstacle(new PVector(2 * width / 3, floorHeight, -100), 50));

  // Inicializar el destino en el centro de la pantalla
  destination = new PVector(width / 2, height / 2, 0);
}

void draw() {
  background(0, 0, 128);  // Fondo azul oscuro para simular el agua

  if (isometricView) {
    isoCam.setView();
  } else if (topView) {
    topViewCam.setView();
  } else {
    // Configurar la cámara para una vista en perspectiva
    perspective();
    camera(camX, camY, camZ, width / 2.0, height / 2.0, 0, 0, 1, 0);
  }

  // Dibujar el "suelo" del acuario
  fill(139, 69, 19);  // Color marrón para el suelo
  noStroke();
  pushMatrix();
  translate(width / 2, height - 50, 0);  // Ajusta la posición del suelo
  box(800, 10, 800);  // Dibujar una caja delgada como suelo
  popMatrix();

  // Dibujar el destino
  fill(255, 0, 0);  // Color rojo para el destino
  pushMatrix();
  translate(destination.x, destination.y, destination.z);
  sphere(10);
  popMatrix();

  // Dibujar obstáculos
  for (Obstacle obstacle : obstacles) {
    obstacle.display();
  }

  // Actualizar y dibujar los peces
  for (FishClass fish : fishSchool) {
    PVector separationForce = fish.separate(fishSchool);
    PVector seekForce = fish.seek(destination);
    PVector avoidForce = fish.avoid(obstacles);
    fish.applyForce(separationForce);
    fish.applyForce(seekForce);
    fish.applyForce(avoidForce);
    fish.applyForce(PVector.random3D().mult(0.1));
    fish.update();
    fish.display();
  }
}

void keyPressed() {
  if (key == 'v' || key == 'V') {
    isometricView = !isometricView;  // Alternar entre vista isométrica y perspectiva
    if (isometricView) topView = false; // Asegurar que no esté activada la vista superior
  }
  if (key == 't' || key == 'T') {
    topView = !topView;  // Alternar entre vista superior y perspectiva
    if (topView) isometricView = false; // Asegurar que no esté activada la vista isométrica
  }
  if (key == CODED) {
    if (keyCode == UP) {
      camY -= 20;
    } else if (keyCode == DOWN) {
      camY += 20;
    } else if (keyCode == LEFT) {
      camX -= 20;
    } else if (keyCode == RIGHT) {
      camX += 20;
    }
  }
}

void mousePressed() {
  // Cambiar el destino a la posición del ratón
  destination = new PVector(mouseX, mouseY, 0);
}
