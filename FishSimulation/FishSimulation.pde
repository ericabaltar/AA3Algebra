IsometricCamera isoCam;
TopViewCamera topViewCam;
ArrayList<Fish> fishSchool;
ArrayList<Obstacle> obstacles;
boolean isometricView = false;
boolean topView = false;
boolean useBezier = true;
LeaderFish leader;
float camX, camY, camZ;
PVector destination;
float leaderSpeed;

// Variables para fuerzas de fricción y viento
boolean applyFriction = false;
boolean applyWind = false;
PVector windForce = new PVector(0.01, 0, 0);  // Fuerza del viento constante en la dirección x
float frictionCoefficient = 0.01;

void setup() {
  size(800, 800, P3D);  // Configura el entorno 3D
  isoCam = new IsometricCamera();
  topViewCam = new TopViewCamera();
  camX = width / 2.0;
  camY = height / 2.0;
  camZ = (height / 2.0) / tan(PI * 30.0 / 180.0);

  // Crear 20 peces
  fishSchool = new ArrayList<Fish>();
  for (int i = 0; i < 20; i++) {
    fishSchool.add(new Fish(new PVector(random(width), random(height), random(-200, 200))));
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

  // Puntos de control para la trayectoria del pez líder
  PVector[] controlPoints = new PVector[4];
  controlPoints[0] = new PVector(100, 100);
  controlPoints[1] = new PVector(700, 100);
  controlPoints[2] = new PVector(100, 700);
  controlPoints[3] = destination;  // El último punto es el destino

  leaderSpeed = 0.05;  // Velocidad constante del líder, más lenta

  // Crear el pez líder con la trayectoria seleccionada
  leader = new LeaderFish(controlPoints, 100, useBezier, destination, leaderSpeed);
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
    camera(camX, camY, camZ, width / 2.0, height - 50, 0, 0, 1, 0);
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

  // Aplicar fricción y viento al líder
  if (applyWind) {
    leader.applyForce(windForce);
  }
  if (applyFriction) {
    PVector friction = leader.velocity.copy();
    friction.mult(-1);
    friction.normalize();
    friction.mult(frictionCoefficient);
    leader.applyForce(friction);
  }
  leader.update();
  leader.display();

  // Actualizar y dibujar los peces
  for (Fish fish : fishSchool) {
    fish.flock(fishSchool);  // Aplicar las fuerzas de agrupamiento
    PVector avoidForce = fish.avoid(obstacles);
    PVector seekForce = fish.seek(leader.position);
    fish.applyForce(avoidForce);
    fish.applyForce(seekForce);
    if (applyWind) {
      fish.applyForce(windForce);
    }
    if (applyFriction) {
      PVector friction = fish.velocity.copy();
      friction.mult(-1);
      friction.normalize();
      friction.mult(frictionCoefficient);
      fish.applyForce(friction);
    }
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
  if (key == 'f' || key == 'F') {
    applyFriction = !applyFriction;  // Alternar la aplicación de la fricción
  }
  if (key == 'w' || key == 'W') {
    applyWind = !applyWind;  // Alternar la aplicación del viento
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
  if (key == 'b' || key == 'B') {
    useBezier = !useBezier;
    PVector[] controlPoints = new PVector[4];
    controlPoints[0] = new PVector(100, 100);
    controlPoints[1] = new PVector(700, 100);
    controlPoints[2] = new PVector(100, 700);
    controlPoints[3] = destination;  // El último punto es el destino
    leader = new LeaderFish(controlPoints, 100, useBezier, destination, leaderSpeed);
  }
}

void mousePressed() {
  // Cambiar el destino a la posición del ratón
  destination = new PVector(mouseX, mouseY, 0);
  leader.destination = destination; // Actualizar el destino del líder también
}
